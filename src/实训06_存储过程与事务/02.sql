
-- 编写一存储过程，自动安排某个连续期间的大夜班的值班表:

create procedure sp_night_shift_arrange(in start_date date, in end_date date)
AS
declare 
    doc employee.e_name%TYPE;
    nur1 employee.e_name%TYPE;
    nur2 employee.e_name%TYPE;
    head employee.e_name%TYPE;
    docType integer;
    dayTH integer;
    flag1 boolean;
    cursor cur_nurse for select e_name from employee where e_type = 3;
    cursor cur_doc for select e_name,e_type from employee where e_type!=3;
begin
    open cur_nurse;
    open cur_doc;
    head := (select e_name from employee where e_type=1);
    while start_date<=end_date loop
        fetch cur_nurse into nur1;
        if cur_nurse%NOTFOUND then
            close cur_nurse;
            open cur_nurse;
            fetch cur_nurse into nur1;
        end if;

        fetch cur_nurse into nur2;
        if cur_nurse%NOTFOUND then
            close cur_nurse;
            open cur_nurse;
            fetch cur_nurse into nur2;
        end if;

        dayTH := extract(DOW from start_date);
        if dayTH=0 or dayTH=6 then
            fetch cur_doc into doc,docType;
            if cur_doc%NOTFOUND then
                close cur_doc;
                open cur_doc;
                fetch cur_doc into doc,docType;
            end if;
            if docType = 1 then -- 取出来的是主任,跳过他取新的,flag置1
                flag1 := true;
                fetch cur_doc into doc,docType;
                if cur_doc%NOTFOUND then
                    close cur_doc;
                    open cur_doc;
                    fetch cur_doc into doc,docType;
                end if;
            end if;
        elseif dayTH=1 then
            if flag1 then -- 需要把主任放进去
                doc := head;
                flag1 := false;
            else -- 不需要放主任,直接取新的
                fetch cur_doc into doc,docType;
                if cur_doc%NOTFOUND then
                    close cur_doc;
                    open cur_doc;
                    fetch cur_doc into doc,docType;
                end if;
            end if;
        else
            fetch cur_doc into doc,docType;
            if cur_doc%NOTFOUND then
                close cur_doc;
                open cur_doc;
                fetch cur_doc into doc,docType;
            end if;
        end if;

        insert into night_shift_schedule values(start_date,doc,nur1,nur2);
        start_date := start_date + integer'1';
    end loop;
end;

/*  end  of  your code  */ 
