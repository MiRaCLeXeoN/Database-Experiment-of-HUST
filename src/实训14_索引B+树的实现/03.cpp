#include <sstream>

#include "common/exception.h"
#include "common/rid.h"
#include "storage/page/b_plus_tree_leaf_page.h"
#include "storage/page/b_plus_tree_internal_page.h"

namespace bustub {

/**
 * 函数功能：
 *  初始化this页，包括page type,size,page id,parent id and max page size
 */
INDEX_TEMPLATE_ARGUMENTS
void B_PLUS_TREE_LEAF_PAGE_TYPE::Init(page_id_t page_id, page_id_t parent_id, int max_size) {
  SetPageType(IndexPageType::LEAF_PAGE);
  SetSize(0);
  SetPageId(page_id);
  SetParentPageId(parent_id);
  SetMaxSize(max_size);
  SetNextPageId(INVALID_PAGE_ID);
}

/**
 * 函数功能：
 *  获取相邻叶子节点的page_id
 * 建议：
 *  next_page_id_属性
 */
INDEX_TEMPLATE_ARGUMENTS
page_id_t B_PLUS_TREE_LEAF_PAGE_TYPE::GetNextPageId() const { 
  return next_page_id_;
}
/**
 * 函数功能：
 *  设置相邻叶子节点的page_id
 * 建议：
 *  next_page_id_属性
 */
INDEX_TEMPLATE_ARGUMENTS
void B_PLUS_TREE_LEAF_PAGE_TYPE::SetNextPageId(page_id_t next_page_id) { 
  next_page_id_ = next_page_id;
}

/**
 * 函数功能：
 *  在key值有序排列的数组中，找到特定key值对应的index
 * 建议：
 *  1.如果当前节点尚不存在key值(size==0)，则可以返回首结点
 *  2.如果key值不存在，返回应插入的index的位置
 */
INDEX_TEMPLATE_ARGUMENTS
int B_PLUS_TREE_LEAF_PAGE_TYPE::KeyIndex(const KeyType &key, const KeyComparator &comparator) const {
  //如果当前节点尚不存在key值，则可以直接插入到第一个结点
	if (GetSize() == 0) return 0;
  //有序排列, 所以用二分查找
  int low = 0, high = GetSize() - 1, mid;
  while(low <= high) {
    mid = (low + high) / 2;
    if (comparator(array_[mid].first, key) < 0)
      low = mid + 1;
    else if (comparator(array_[mid].first, key) > 0)
      high = mid - 1;
    else
      return mid;
  }
  return low; 
}

/**
 * 函数功能：
 *  返回index处的key值
 * 建议：
 *  1.数组中元素为pair，first为key，second为RID
 */
INDEX_TEMPLATE_ARGUMENTS
KeyType B_PLUS_TREE_LEAF_PAGE_TYPE::KeyAt(int index) const {
  // replace with your own code
  return array_[index].first;
}


/**
 * 函数功能：
 *  返回index处的元素
 * 建议：
 *  1.数组中元素为pair，first为key，second为RID
 */
INDEX_TEMPLATE_ARGUMENTS
const MappingType &B_PLUS_TREE_LEAF_PAGE_TYPE::GetItem(int index) {
  // replace with your own code
  return array_[index];
}

/*****************************************************************************
 *插入
 *****************************************************************************/
/**
 * 函数功能：
 *  在保证有序地情况下插入新的键值对
 * 建议：
 *  1.元素溢出的情况无需处理，后续可以在外部处理
 *  2.当size为0时插入到数组头部
 *  3.更新size并返回当前size大小
 */
INDEX_TEMPLATE_ARGUMENTS
int B_PLUS_TREE_LEAF_PAGE_TYPE::Insert(const KeyType &key, const ValueType &value, const KeyComparator &comparator) {
  int index = KeyIndex(key, comparator);
  for(int i =GetSize();i>index;i--){
    array_[i]=array_[i-1];
  }
  array_[index].first = key;
  array_[index].second = value;
  IncreaseSize(1);
  return GetSize();
}

/*****************************************************************************
 * 分裂
 *****************************************************************************/
/**
 *函数功能：
 * 移动this结点中一半（向上取整）的元素到一个新生成的recipient结点中
 *建议：
 *  1.优先实现CopyNFrom函数
 *  2.在内部调用CopyNFrom函数实现该功能
 *  3.更新this结点和recipient结点的NextPageId属性，注意recipient结点显然是this结点后继结点
 *  eg:
 *      this == r1,  recipient == r2
 *      r1->[<0, r0>, <1, r1>, <2, r2>, <3, r3>, <4, r4>] ----MoveHalfTo--> r2[]
 *      result: r1->[<0, r0>, <1, r1>] ---> r2[<2, r2>, <3, r3>, <4, r4>]
 */
INDEX_TEMPLATE_ARGUMENTS
void B_PLUS_TREE_LEAF_PAGE_TYPE::MoveHalfTo(BPlusTreeLeafPage *recipient,
                                            __attribute__((unused)) BufferPoolManager *buffer_pool_manager) {
  int moveSize=(GetSize()+1)/2;                                            
  recipient->CopyNFrom(array_+GetSize()-moveSize, moveSize);
  SetSize(GetSize()-moveSize);
  recipient->SetNextPageId(GetNextPageId());
  SetNextPageId(recipient->GetPageId());
}

/**
 * 函数功能：从item处开始，截取size个键值对并入到结点的尾部
 * 建议：
 *  1.更新size大小
 */
INDEX_TEMPLATE_ARGUMENTS
void B_PLUS_TREE_LEAF_PAGE_TYPE::CopyNFrom(MappingType *items, int size) {
  int initialSize=GetSize();
  for(int i=initialSize; i<initialSize+size; i++){
    array_[i] = *items++;
  }
  IncreaseSize(size);
}

/*****************************************************************************
 * 查找
 *****************************************************************************/
/**
 * 函数功能：
 *  在key值有序排列的数组中，找到特定key值对应的value
 * 建议：
 *  1.可以调用KeyIndex()函数
 *  2.如果key值存在，存储key对应的value值，返回true
 *  3.如果key值不存在，直接返回false
 *  4.使用comparator进行key值的比较
 */
INDEX_TEMPLATE_ARGUMENTS
bool B_PLUS_TREE_LEAF_PAGE_TYPE::Lookup(const KeyType &key, ValueType *value, const KeyComparator &comparator) const {
  int index = KeyIndex(key, comparator);
  if (index < GetSize() && comparator(array_[index].first, key) == 0) {
    *value = array_[index].second;
    return true;
  }
  return false;
}

/*****************************************************************************
 * 移除
 *****************************************************************************/
/**
 * 函数功能：
 *  1.移除this结点中的index元素
 * 建议：
 *  1.当key不存在时，直接返回当前size
 *  1.注意元素的移动
 *  2.更新并返回size
 */
INDEX_TEMPLATE_ARGUMENTS
int B_PLUS_TREE_LEAF_PAGE_TYPE::RemoveAndDeleteRecord(const KeyType &key, const KeyComparator &comparator) {
  int index = KeyIndex(key, comparator);
  //如果不存在, 直接返回size
  if (index >= GetSize() || comparator(key, KeyAt(index)) != 0)
    return GetSize();
  //用前移的方式进行覆盖
  for (int i = index; i < GetSize() - 1; i++)
    array_[i] = array_[i + 1];
  IncreaseSize(-1);
  return GetSize();
}

/*****************************************************************************
 * 合并
 *****************************************************************************/
/**
 * 函数功能：
 *  合并this结点的元素至recipient结点中，即将this结点中的全部元素移至recipient结点的尾部
 * 建议：
 *  1.this结点显然是recipient结点后继叶结点，因此需要更新recipient结点的NextPageId为this
 *     结点的nextPageId。
 *  2.更新size大小
 *  3.this结点内容全部移动至sibling recipient结点，而this结点的父节点内容需要删除，但不用
 *    在本函数中实现。
 */
INDEX_TEMPLATE_ARGUMENTS
void B_PLUS_TREE_LEAF_PAGE_TYPE::MoveAllTo(BPlusTreeLeafPage *recipient, BufferPoolManager *buffer_pool_manager) { 
  int startIdx = recipient->GetSize(); 
  for (int i = 0; i < GetSize(); i++)
    recipient->array_[startIdx + i] = array_[i];
  recipient->SetNextPageId(GetNextPageId());
  recipient->IncreaseSize(GetSize());
  SetSize(0);
}

/*****************************************************************************
 * 重分配
 *****************************************************************************/
/**
 * 函数功能：
 *  移动this结点的首元素至recipient结点的末尾
 * 建议：
 *  1.recipient调用CopyLastFrom函数实现节点更新
 *  2.this结点更新size
 *  3.由于this结点首元素发生变化，因此父结点中this结点的索引key值需要更新
 */
INDEX_TEMPLATE_ARGUMENTS
void B_PLUS_TREE_LEAF_PAGE_TYPE::MoveFirstToEndOf(BPlusTreeLeafPage *recipient,
                                                  BufferPoolManager *buffer_pool_manager) {
  recipient->CopyLastFrom(array_[0]);
  for(int i=0; i<GetSize()-1; i++){
    array_[i]=array_[i+1];
  }
  IncreaseSize(-1);
  Page *page = buffer_pool_manager->FetchPage(GetParentPageId());
  B_PLUS_TREE_INTERNAL_PAGE *parent = reinterpret_cast<B_PLUS_TREE_INTERNAL_PAGE *>(page->GetData());
  parent->SetKeyAt(parent->ValueIndex(GetPageId()), array_[0].first);
  buffer_pool_manager->UnpinPage(GetParentPageId(), true);  //写脏
}

/**
 * 函数功能：
 *  将pair元素添加到this结点的尾部
 * 建议：
 *  1.更新size
 */
INDEX_TEMPLATE_ARGUMENTS
void B_PLUS_TREE_LEAF_PAGE_TYPE::CopyLastFrom(const MappingType &item) {
  array_[GetSize()]=item;
  IncreaseSize(1);
}

/**
 * 函数功能：
 *  移动this结点的尾部元素至recipient结点的头部
 * 建议：
 *  1.recipient调用CopyFirstFrom函数实现节点更新
 *  2.this结点更新size
 */
INDEX_TEMPLATE_ARGUMENTS
void B_PLUS_TREE_LEAF_PAGE_TYPE::MoveLastToFrontOf(BPlusTreeLeafPage *recipient,
                                                   BufferPoolManager *buffer_pool_manager) {
  recipient->CopyFirstFrom(array_[GetSize()-1], buffer_pool_manager)    ;
  IncreaseSize(-1);                                              
}

/**
 * 函数功能：
 *  移动pair元素至recipient结点的首部
 * 建议：
 *  1.由于结点首元素发生变化，父结点中this结点的索引key值需要更新
 *  2.更新size
 */
INDEX_TEMPLATE_ARGUMENTS
void B_PLUS_TREE_LEAF_PAGE_TYPE::CopyFirstFrom(const MappingType &item,
                                                BufferPoolManager *buffer_pool_manager) {
  //移动位置
  for(int i=GetSize();i>0;i--){
    array_[i] = array_[i-1];
  }                                                
  IncreaseSize(1);
  array_[0]=item;
  Page *page = buffer_pool_manager->FetchPage(GetParentPageId());
  B_PLUS_TREE_INTERNAL_PAGE *parent = reinterpret_cast<B_PLUS_TREE_INTERNAL_PAGE *>(page->GetData());
  parent->SetKeyAt(parent->ValueIndex(GetPageId()), array_[0].first);
  buffer_pool_manager->UnpinPage(GetParentPageId(), true); //写脏
}

template class BPlusTreeLeafPage<GenericKey<4>, RID, GenericComparator<4>>;
template class BPlusTreeLeafPage<GenericKey<8>, RID, GenericComparator<8>>;
template class BPlusTreeLeafPage<GenericKey<16>, RID, GenericComparator<16>>;
template class BPlusTreeLeafPage<GenericKey<32>, RID, GenericComparator<32>>;
template class BPlusTreeLeafPage<GenericKey<64>, RID, GenericComparator<64>>;
}  // namespace bustub
