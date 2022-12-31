
-- 在金融应用场景数据库中，编程实现一个转账操作的存储过程sp_transfer_balance，实现从一个帐户向另一个帐户转账。
-- 请补充代码完成该过程：
create procedure sp_transfer(
                     IN applicant_id int,      
                     IN source_card_id char(30),
					 IN receiver_id int, 
                     IN dest_card_id char(30),
					 IN	amount numeric(10,2),
					 OUT return_code int)
as 
declare
    s_id int;
    r_id int;
    s_type bank_card.b_type%TYPE;
    r_type bank_card.b_type%TYPE;
    s_balance bank_card.b_balance%TYPE;
    r_balance bank_card.b_balance%TYPE;
    s_sym int := 1;
    r_sym int := 1;
begin	
    -- 获取转出卡信息
    select b_c_id, b_balance, b_type
    into s_id,s_balance,s_type
    from bank_card
    where b_number=source_card_id;

    -- 获取转入卡信息
    select b_c_id, b_balance, b_type
    into r_id,r_balance,r_type
    from bank_card
    where b_number=dest_card_id;

    if s_id != applicant_id or r_id != receiver_id or (s_type = '信用卡' and r_type = '储蓄卡') or (s_type = '储蓄卡' and s_balance < amount) then
        return_code := 0;
        return;
    end if;

    if s_type = '信用卡' then
        s_sym := -1;
    end if;
    if r_type = '信用卡' then
        r_sym := -1;
    end if;

    update bank_card
    set b_balance=b_balance-s_sym*amount
    where b_number=source_card_id;

    update bank_card
    set b_balance=b_balance+r_sym*amount
    where b_number=dest_card_id;

    return_code := 1;
end; 

/*  end  of  your code  */ 