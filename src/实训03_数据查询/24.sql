      -- 24) 查询任意两个客户的相同理财产品数
--   请用一条SQL语句实现该查询：

select p1.pro_c_id,p2.pro_c_id,COUNT(*) as total_count
from property p1,property p2
where p1.pro_c_id!=p2.pro_c_id and
    p1.pro_type=1 and
    p2.pro_type=1 and
    p1.pro_pif_id=p2.pro_pif_id
group by p1.pro_c_id,p2.pro_c_id
having total_count>=2;





--/*  end  of  your code  */