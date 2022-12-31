-- 14) 查询每份保险金额第4高保险产品的编号和保险金额。
--     在数字序列8000,8000,7000,7000,6000中，
--     两个8000均为第1高，两个7000均为第2高,6000为第3高。
-- 请用一条SQL语句实现该查询：

select i_id,insurance.i_amount
    from insurance,(
        select i_amount, row_number() over (order by i_amount desc) as ranking
            from (
                select distinct i_amount
                    from insurance
                    order by i_amount
            )
    ) as newform
    where insurance.i_amount = newform.i_amount and
        newform.ranking = 4;

-- 实现方法2
select i_id,i_amount
    from (
        select *, dense_rank() over (order by i_amount desc) as ranking
            from insurance
    )
    where ranking=4;


/*  end  of  your code  */ 