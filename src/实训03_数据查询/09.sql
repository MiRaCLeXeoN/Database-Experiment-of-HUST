-- 9) 查询购买了货币型(f_type='货币型')基金的用户的名称、电话号、邮箱。
--   请用一条SQL语句实现该查询：

-- select c_name,c_phone,c_mail
--     from client
--     where exists(
--         select * from property,fund
--             where property.pro_c_id = client.c_id and
--                 property.pro_type = 3 and
--                 property.pro_pif_id = fund.f_id and
--                 fund.f_type = '货币型'
--     );

select c_name,c_phone,c_mail
    from client
    where exists(
        select * from property
            where exists(
                select * from fund
                    where property.pro_c_id = client.c_id and
                        property.pro_type = 3 and
                        property.pro_pif_id = fund.f_id and
                        fund.f_type = '货币型'
            )
    );

-- select c_name,c_phone,c_mail
--     from client
--     where exists(
--         select * from property,fund
--             where property.pro_c_id = client.c_id and
--                 property.pro_type = 3 and
--                 property.pro_pif_id = fund.f_id and
--                 fund.f_type = '货币型'
--     );


/*  end  of  your code  */