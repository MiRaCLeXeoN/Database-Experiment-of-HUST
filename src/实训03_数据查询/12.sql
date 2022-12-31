 -- 12) 综合客户表(client)、资产表(property)、理财产品表(finances_product)、保险表(insurance)和
 --     基金表(fund)，列出客户的名称、身份证号以及投资总金额（即投资本金，
 --     每笔投资金额=商品数量*该产品每份金额)，注意投资金额按类型需要查询不同的表，
 --     投资总金额是客户购买的各类资产(理财,保险,基金)投资金额的总和，总金额命名为total_amount。
 --     查询结果按总金额降序排序。
 -- 请用一条SQL语句实现该查询：

select c_name,c_id_card,nvl(SUM(pro_quantity*amount),0) as total_amount
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
    order by total_amount desc;
        


/*  end  of  your code  */ 