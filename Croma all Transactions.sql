SELECT 
    s.date,
    s.product_code,
    s.sold_quantity,
    p.product,
    p.variant,
    g.gross_price,
    round(s.sold_quantity * g.gross_price, 2) AS total_gross_price
FROM
    gdb0041.fact_sales_monthly s
        JOIN
    dim_product p ON s.product_code = p.product_code
        JOIN
    fact_gross_price g ON s.product_code = g.product_code
        AND g.fiscal_year = GET_FISCAL_YEAR(s.date)
WHERE
    customer_code = 90002002
        AND GET_FISCAL_YEAR(date) = 2021
ORDER BY date ASC;

