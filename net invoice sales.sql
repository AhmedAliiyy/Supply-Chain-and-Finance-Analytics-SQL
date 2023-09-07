SELECT 
    s.date,
    s.customer_code,
    s.market,
    s.product_code,
    s.product,
    s.variant,
    s.sold_quantity,
    s.total_gross_price,
    s.pre_invoice_discount_pct,
    (1 - pre_invoice_discount_pct) * total_gross_price AS net_invoice_sales,
    (po.discounts_pct + po.other_deductions_pct) AS post_invoice_deductions
FROM
    gdb0041.sales_preinvoice_table s
        JOIN
    fact_post_invoice_deductions po ON s.date = po.date
        AND s.product_code = po.product_code
        AND s.customer_code = po.customer_code