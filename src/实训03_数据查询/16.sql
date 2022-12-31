-- 16) 查询持有相同基金组合的客户对，如编号为A的客户持有的基金，编号为B的客户也持有，反过来，编号为B的客户持有的基金，编号为A的客户也持有，则(A,B)即为持有相同基金组合的二元组，请列出这样的客户对。为避免过多的重复，如果(1,2)为满足条件的元组，则不必显示(2,1)，即只显示编号小者在前的那一对，这一组客户编号分别命名为c_id1,c_id2。

-- 请用一条SQL语句实现该查询：

select t1.pro_c_id as c_id1, t2.pro_c_id as c_id2
    from (
        select pro_c_id,listagg(pro_pif_id,',') WITHIN GROUP(order by pro_pif_id) funds
            from property
            where pro_type=3
            group by pro_c_id
    ) as t1,(
        select pro_c_id,listagg(pro_pif_id,',') WITHIN GROUP(order by pro_pif_id) funds
            from property
            where pro_type=3
            group by pro_c_id
    ) as t2
    where t1.pro_c_id<t2.pro_c_id and
        t1.funds=t2.funds;

-- --实现方法2
-- select distinct p1.pro_c_id as c_id1, p2.pro_c_id as c_id2
--     from property p1
--     inner join property p2
--     on p1.pro_c_id != p2.pro_c_id
--     where p1.pro_c_id < p2.pro_c_id and
--         not exists(
--             select *
--                 from (
--                     select t1.pro_pif_id from property t1 where t1.pro_c_id = p1.pro_c_id and t1.pro_type = 3
--                 ) as t1
--                 where t1.pro_pif_id not in (
--                     select t2.pro_pif_id from property t2 where t2.pro_c_id = p2.pro_c_id and t2.pro_type = 3
--                 )
--             union all
--             select *
--                 from (
--                     select t2.pro_pif_id from property t2 where t2.pro_c_id = p2.pro_c_id and t2.pro_type = 3
--                 ) as t2
--                 where t2.pro_pif_id not in (
--                     select t1.pro_pif_id from property t1 where t1.pro_c_id = p1.pro_c_id and t1.pro_type = 3
--                 )
--             union all
--             select 1
--                 from (
--                     select COUNT(*) as cc from property t1 where t1.pro_c_id = p1.pro_c_id and t1.pro_type = 3
--                 )
--                 where cc=0
--         );

/*  end  of  your code  */