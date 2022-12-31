   -- 21) 投资积极且偏好理财类产品的客户
--   请用一条SQL语句实现该查询：



select tmp_fund.pro_c_id
from (
   select pro_c_id,COUNT(distinct pro_pif_id) as product_count
   from property
   where property.pro_type = 1
   group by pro_c_id
   having product_count>3 
) as tmp_product,(
   select pro_c_id,COUNT(distinct pro_pif_id) as fund_count
   from property
   where pro_type = 3
   group by pro_c_id
) as tmp_fund
where tmp_fund.pro_c_id=tmp_product.pro_c_id and
   tmp_product.product_count>tmp_fund.fund_count
order by tmp_fund.pro_c_id;




--/*  end  of  your code  */