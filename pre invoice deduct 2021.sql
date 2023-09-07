SELECT 
    s.date,
    s.product_code,
    s.sold_quantity,
    p.product,
    p.variant,
    g.gross_price,
    ROUND(s.sold_quantity * g.gross_price, 2) AS total_gross_price,
    pre.pre_invoice_discount_pct
FROM
    gdb0041.fact_sales_monthly s
        JOIN
    dim_product p ON s.product_code = p.product_code
        JOIN
    fact_gross_price g ON s.product_code = g.product_code
        AND g.fiscal_year = GET_FISCAL_YEAR(s.date)
        JOIN
    fact_pre_invoice_deductions pre ON s.customer_code = pre.customer_code
        AND pre.fiscal_year = GET_FISCAL_YEAR(s.date)
WHERE
    GET_FISCAL_YEAR(s.date) = 2021
LIMIT 1000000;