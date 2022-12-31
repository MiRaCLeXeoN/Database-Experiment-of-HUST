     -- 23) 查找相似的理财产品
--   请用一条SQL语句实现该查询：


-- 找出这些理财产品被持有的总量
select pro_pif_id,COUNT(distinct pro_c_id) as cc,dense_rank() over(order by cc desc) as prank
from property p1
where pro_type = 1 and
    pro_pif_id in (
         -- 找出这些用户所购买的所有的理财产品
          select p2.pro_pif_id
          from property p2
          where p2.pro_c_id in (
              select pro_c_id
            from (
                select pro_c_id, SUM(pro_quantity) as quantity, dense_rank() over(order by quantity desc) as rk
                from property
                where pro_pif_id=14 and
                    pro_type=1
                group by pro_c_id
            )
            where rk<=3
          ) and
               p2.pro_type = 1 and
               p2.pro_pif_id != 14
          group by p2.pro_pif_id
    )
group by pro_pif_id
order by prank asc, pro_pif_id asc;




--/*  end  of  your code  */