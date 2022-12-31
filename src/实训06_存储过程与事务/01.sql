-- 创建存储过程`sp_fibonacci(in m int)`，向表fibonacci插入斐波拉契数列的前m项，及其对应的斐波拉契数。fibonacci表初始值为一张空表。请保证你的存储过程可以多次运行而不出错。

create procedure sp_fibonacci(in m int)
as
declare 
    ttt integer := 0;
    tmp1 integer := 0;
    tmp2 integer := 1;
    cnt integer := 0;
begin
-- ######## 请补充代码完成存储过程体 ########
WHILE cnt<m LOOP
    insert into fibonacci (n,fibn) values (cnt,tmp1);
    ttt := tmp1+tmp2;
    tmp1 := tmp2;
    tmp2 := ttt;
    cnt := cnt +1;
END LOOP;
end;
/
 
