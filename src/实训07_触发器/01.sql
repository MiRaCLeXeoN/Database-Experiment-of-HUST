--创建触发器函数TRI_INSERT_FUNC()
CREATE OR REPLACE FUNCTION TRI_INSERT_FUNC() RETURNS TRIGGER AS
$$
DECLARE
   --此处用declare语句声明你所需要的变量
   newTpye int := new.pro_type;
   pifId int := new.pro_pif_id;
   msg varchar(100);
BEGIN
   --此处插入触发器业务
   if newTpye = 1 then
      if pifId not in (select p_id from finances_product) then
         msg := concat('finances product #', pifId, ' not found!');
      end if;
   elseif newTpye = 2 then
      if pifId not in (select i_id from insurance) then
         msg := concat('insurance #', pifId, ' not found!');
      end if;
   elseif newTpye = 3 then
      if pifId not in (select f_id from fund) then
         msg := concat('fund #', pifId, ' not found!');
      end if;
   else
      msg := concat('type ', newTpye, ' is illegal!');
   end if;
   if msg is not null then
      raise exception '%',msg;
   end if;

   --触发器业务结束
   return new;--返回插入的新元组
END;
$$ LANGUAGE PLPGSQL;


-- 创建before_property_inserted触发器，使用函数TRI_INSERT_FUNC实现触发器逻辑：
CREATE  TRIGGER before_property_inserted BEFORE INSERT ON property
FOR EACH ROW 
EXECUTE PROCEDURE TRI_INSERT_FUNC();
