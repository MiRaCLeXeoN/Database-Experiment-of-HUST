       -- 25) 查找相似的理财客户
--   请用一条SQL语句实现该查询：


-- 获取所有的组合
select *
from (
       select p1.pro_c_id as pac,p2.pro_c_id as pbc,COUNT(p2.pro_quantity) as common, rank() over(partition by pac order by common desc,pbc asc) as crank
       from property p1, property p2
       where p1.pro_type = 1 and
       p2.pro_type =1 and
       p1.pro_c_id != p2.pro_c_id and
       p1.pro_pif_id = p2.pro_pif_id
       group by p1.pro_c_id,p2.pro_c_id
)
where crank<=2
order by pac asc,crank asc;




--/*  end  of  your code  */