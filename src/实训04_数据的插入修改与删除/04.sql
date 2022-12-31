-- 请用一条SQL语句删除client表中没有银行卡的客户信息：

delete from client
    where not exists(
        select * from bank_card
            where bank_card.b_c_id = client.c_id
    );


/* the end of your code */ 