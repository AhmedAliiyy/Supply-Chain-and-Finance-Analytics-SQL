SELECT 
    get_fiscal_year(s.date) as fiscal_year,
    round(sum(s.sold_quantity * g.gross_price), 2) AS total_gross_price
FROM
    gdb0041.fact_sales_monthly s
        JOIN
    fact_gross_price g ON s.product_code = g.product_code
        AND g.fiscal_year = GET_FISCAL_YEAR(s.date)
WHERE
    customer_code = 90002002
group by get_fiscal_year(s.date)
ORDER BY date ASC;