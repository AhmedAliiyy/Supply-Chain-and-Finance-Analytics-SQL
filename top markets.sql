SELECT 
    market, ROUND(SUM(net_sales) / 1000000, 2) AS Net_sales_mill
FROM
    gdb0041.net_sales
WHERE
    fiscal_year = 2021
GROUP BY market
ORDER BY net_sales DESC
LIMIT 5;