with cte1 as (SELECT 
    c.customer,
    ROUND(SUM(net_sales) / 1000000, 2) AS net_sales_mill
FROM
    gdb0041.net_sales ns
        JOIN
    dim_customer c ON ns.customer_code = c.customer_code
WHERE
    fiscal_year = 2021
GROUP BY c.customer)

select *, net_sales_mill*100/sum(net_sales_mill) over() as pct  from cte1
ORDER BY net_sales_mill DESC