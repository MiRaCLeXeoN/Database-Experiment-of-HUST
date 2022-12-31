-- 19) 以日历表格式列出2022年2月每周每日基金购买总金额，输出格式如下：
-- week_of_trading Monday Tuesday Wednesday Thursday Friday
--               1
--               2    
--               3
--               4
--   请用一条SQL语句实现该查询：


select 
        weekid as week_of_trading,
        SUM(case when dayid=1 then daytotal else null end) Monday,
        SUM(case when dayid=2 then daytotal else null end) Tuesday,
        SUM(case when dayid=3 then daytotal else null end) Wendnesday,
        SUM(case when dayid=4 then daytotal else null end) Thursday,
        SUM(case when dayid=5 then daytotal else null end) Friday
    from (
        select extract(week from cast(pro_purchase_time as timestamp))-extract(week from timestamp'2022-02-01') as weekid,
            extract(dow from cast(pro_purchase_time as timestamp)) as dayid,
            SUM(property.pro_quantity*fund.f_amount) as daytotal
        from property
        left join fund  -- 必须要left join, 不然可能会导致部分天无法显示
        on property.pro_pif_id=fund.f_id 
        where property.pro_type=3 and 
            pro_purchase_time like '2022-02-__'
        group by pro_purchase_time
    ) as newform
    group by weekid
    order by week_of_trading;




/*  end  of  your code  */