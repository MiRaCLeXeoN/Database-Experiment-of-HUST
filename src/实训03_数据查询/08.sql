-- 8) 查询持有两张(含）以上信用卡的用户的名称、身份证号、手机号。
--    请用一条SQL语句实现该查询：

-- select c_name,c_id_card,c_phone
--     from client,bank_card
--     where client.c_id = bank_card.b_c_id and
--         bank_card.b_type = '信用卡'
--     group by c_id
--     having count(*)>=2; 

select c_name,c_id_card,c_phone
    from client c1
    where exists(
        select b_c_id from bank_card
            where bank_card.b_type = '信用卡' and
                bank_card.b_c_id = c1.c_id
            group by b_c_id
            having count(*) >= 2
    );


/*  end  of  your code  */