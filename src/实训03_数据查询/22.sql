    -- 22) 查询购买了所有畅销理财产品的客户
--   请用一条SQL语句实现该查询：

with popular_fp as(
    select pro_pif_id
    from property
    where pro_type = 1
    group by pro_pif_id
    having count(distinct pro_c_id) >2
)

select distinct pro_c_id
from property p1
where not exists(
    select *
    from popular_fp
    where pro_pif_id not in(
        select p2.pro_pif_id
        from property p2
        where p1.pro_c_id=p2.pro_c_id and
            p2.pro_type=1
    )
)
order by pro_c_id asc;


--/*  end  of  your code  */