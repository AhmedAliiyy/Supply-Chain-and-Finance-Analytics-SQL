# Supply-Chain-and-Finance-Analytics-SQL
## If you want the whole code please check the files attached
       
## User defined function to get Quarters fepends on Fiscal year function
        CREATE DEFINER=`root`@`localhost` FUNCTION `get_fiscal_quarters`(
        		calender_date date
        ) RETURNS varchar(2) CHARSET utf8mb4
            DETERMINISTIC
        BEGIN
        		    Declare m tinyint;
                Declare QTR varchar(2);
                set M =month(calender_date);
              Case
        				when M in (09,10,11) then
                        set QTR = "Q1";
                        when M in (12,01,02) then
                        set QTR = "Q2";
                        when M in (03,04,05) then
                        set QTR = "Q3";
                        else
                        set QTR = "Q4";
                
              End case;
        RETURN QTR;
        END
## Create View table to retrive preinvoice information using join on 3 different table

          CREATE 
          ALGORITHM = UNDEFINED 
          DEFINER = `root`@`localhost` 
          SQL SECURITY DEFINER
      VIEW `sales_preinvoice_table` AS
          SELECT 
              `s`.`date` AS `date`,
              `s`.`fiscal_year` AS `fiscal_year`,
              `s`.`product_code` AS `product_code`,
              `s`.`customer_code` AS `customer_code`,
              `c`.`market` AS `market`,
              `s`.`sold_quantity` AS `sold_quantity`,
              `p`.`product` AS `product`,
              `p`.`variant` AS `variant`,
              `g`.`gross_price` AS `gross_price`,
              ROUND((`s`.`sold_quantity` * `g`.`gross_price`),
                      2) AS `total_gross_price`,
              `pre`.`pre_invoice_discount_pct` AS `pre_invoice_discount_pct`
          FROM
              ((((`fact_sales_monthly` `s`
              JOIN `dim_product` `p` ON ((`s`.`product_code` = `p`.`product_code`)))
              JOIN `dim_customer` `c` ON ((`s`.`customer_code` = `c`.`customer_code`)))
              JOIN `fact_gross_price` `g` ON (((`s`.`product_code` = `g`.`product_code`)
                  AND (`g`.`fiscal_year` = `s`.`fiscal_year`))))
              JOIN `fact_pre_invoice_deductions` `pre` ON (((`s`.`customer_code` = `pre`.`customer_code`)
                  AND (`pre`.`fiscal_year` = `s`.`fiscal_year`))))

## Create stored procedures to get top/bottom products by sales ranked

              CREATE DEFINER=`root`@`localhost` PROCEDURE `get_top/bottom_products_ranked_per_division`(
              		in_fiscal_year int,
                      in_top_num int
              )
              BEGIN
              		with cte1 as	(SELECT 
              					p.division, p.product, sum(s.sold_quantity) as total_quantity
              				FROM
              					fact_sales_monthly s
              						JOIN
              					dim_product p ON s.product_code = p.product_code
              				WHERE
              					fiscal_year = in_fiscal_year
              				GROUP BY p.product),
              				
              		cte2 as	(select 
              		*, dense_rank() over(partition by division order by total_quantity desc) as drank
              		from cte1)
              
              		select * from cte2 where drank <= in_top_num;
              END

