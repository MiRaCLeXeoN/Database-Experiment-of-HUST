-- 20) 查询销售总额前三的理财产品
-- 请用一条SQL语句实现该查询：



select *
    from (
        select 
            extract(year from pro_purchase_time) pyear,
            rank() over(partition by pyear order by sumamount desc) as rk,
            p_id,
            SUM(pro_quantity*p_amount) as sumamount
        from property,finances_product
        where property.pro_pif_id = finances_product.p_id and
            property.pro_type = 1 and
            (pro_purchase_time like '2010%' or pro_purchase_time like '2011%')
        group by pyear,p_id
    )
    where rk<=3;



--/*  end  of  your code  */