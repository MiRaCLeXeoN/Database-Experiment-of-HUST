-- 13) 综合客户表(client)、资产表(property)、理财产品表(finances_product)、
--     保险表(insurance)、基金表(fund)和投资资产表(property)，
--     列出所有客户的编号、名称和总资产，总资产命名为total_property。
--     总资产为储蓄卡余额，投资总额，投资总收益的和，再扣除信用卡透支的金额
--     (信用卡余额即为透支金额)。客户总资产包括被冻结的资产。
--    请用一条SQL语句实现该查询：


select client.c_id,c_name,SUM(total_balance.total_balance+total_investment.total_investment+total_income.total_income-total_debt.total_debt) as total_property
    from client,(
        -- 获得储蓄卡总余额
        select c_id,nvl(SUM(b_balance),0) as total_balance
            from client
            left join (select * from bank_card where b_type = '储蓄卡') as tmp
            on client.c_id=tmp.b_c_id
            group by c_id
    ) as total_balance,(
        -- 获得投资总金额
        select c_id,nvl(SUM(pro_quantity*amount),0) as total_investment
            from client
            left join(
                select *
                from property,(
                    select pro_id,p_amount as amount
                        from property,finances_product
                        where property.pro_pif_id=finances_product.p_id and
                            property.pro_type = 1
                    UNION
                    select pro_id,i_amount as amount
                        from property,insurance
                        where property.pro_pif_id=insurance.i_id and
                        property.pro_type = 2
                    UNION
                    select pro_id,f_amount as amount
                        from property,fund
                        where property.pro_pif_id=fund.f_id and
                        property.pro_type = 3
                ) as newform
                where property.pro_id=newform.pro_id
            ) as newform
            on client.c_id=newform.pro_c_id
            group by c_id
    ) as total_investment,(
        -- 获得投资总收益
        select c_id,nvl(SUM(pro_income),0) as total_income
            from client
            left join property
            on client.c_id=property.pro_c_id
            group by c_id
    ) as total_income,(
        -- 获得信用卡欠款
        select c_id,nvl(SUM(b_balance),0) as total_debt
            from client
                        left join (select * from bank_card where b_type = '信用卡') as tmp
            on client.c_id=tmp.b_c_id
            group by c_id
    ) as total_debt
    where client.c_id = total_balance.c_id and
        client.c_id = total_investment.c_id and
        client.c_id = total_income.c_id and
        client.c_id = total_debt.c_id
    group by client.c_id
    order by client.c_id;





/*  end  of  your code  */ 