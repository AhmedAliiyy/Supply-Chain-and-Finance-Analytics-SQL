with cte1 as	(SELECT 
			p.division, p.product, sum(s.sold_quantity) as total_quantity
		FROM
			fact_sales_monthly s
				JOIN
			dim_product p ON s.product_code = p.product_code
		WHERE
			fiscal_year = 2021
		GROUP BY p.product),
        
cte2 as	(select 
*, dense_rank() over(partition by division order by total_quantity desc) as drank
from cte1)

select * from cte2 where drank <=3