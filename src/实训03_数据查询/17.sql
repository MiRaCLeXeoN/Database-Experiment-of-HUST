-- 17 查询2022年2月购买基金的高峰期。至少连续三个交易日，所有投资者购买基金的总金额超过100万(含)，则称这段连续交易日为投资者购买基金的高峰期。只有交易日才能购买基金,但不能保证每个交易日都有投资者购买基金。2022年春节假期之后的第1个交易日为2月7日,周六和周日是非交易日，其余均为交易日。请列出高峰时段的日期和当日基金的总购买金额，按日期顺序排序。总购买金额命名为total_amount。
--    请用一条SQL语句实现该查询：

with tmp as(
    select pro_purchase_time,
            SUM(pro_quantity*f_amount) as total,
            (pro_purchase_time-date'2022-02-07'-2*( floor((pro_purchase_time-date'2022-02-07')/7) )) workdayTH
            -- row_number() over(order by workdayTH) dayTH  --这部分不能在这里面加,不然会错位
        from property,fund
        where property.pro_type=3 and 
            property.pro_pif_id=fund.f_id and 
            pro_purchase_time like '2022-02-__'
        group by pro_purchase_time
        having total >= 1000000
        order by pro_purchase_time
)

select t2.pro_purchase_time,total as amount
    from (
        select *,COUNT(*) over(partition by t1.workdayTH-t1.dayTH) as cnt
            from (
                select *, row_number() over(order by workdayTH) dayTH
                    from tmp
            ) as t1
    ) as t2
    where t2.cnt>=3;




/*  end  of  your code  */