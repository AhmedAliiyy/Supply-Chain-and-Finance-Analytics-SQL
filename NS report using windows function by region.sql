with cte2 as (SELECT 
    c.customer, c.region,
    ROUND(SUM(net_sales) / 1000000, 2) AS net_sales_mill
FROM
    gdb0041.net_sales ns
        JOIN
    dim_customer c ON ns.customer_code = c.customer_code
WHERE
    fiscal_year = 2021
GROUP BY c.customer, c.region)

select *, net_sales_mill*100/sum(net_sales_mill) over(partition by region) as NS_PCT_byRegion from cte2 order by region, net_sales_mill desc;