CREATE TABLE `KimiaFarma.kf_analisa`
AS
SELECT
    t.transaction_id,
    t.customer_name,
    t.branch_id,
    k.branch_category,
    k.branch_name,
    k.kota as city,
    k.provinsi as province,
    k.rating AS branch_rating,
    i.inventory_id,
    t.product_id,
    p.product_category,
    p.product_name,
    i.opname_stock,
    t.price as actual_price,
    t.discount_percentage,
    CASE
        WHEN t.price <= 50000 THEN 0.10
        WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
        WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
        WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
        WHEN t.price > 500000 THEN 0.30
    END AS gross_profit_percentage,
    t.price * (1 - t.discount_percentage) AS nett_sales,
    (t.price * (1 - t.discount_percentage)) * 
    CASE
        WHEN t.price <= 50000 THEN 0.10
        WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
        WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
        WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
        WHEN t.price > 500000 THEN 0.30
    END AS nett_profit,
    t.rating as transaction_rating,
    t.date
FROM
    `KimiaFarma.kf_final_transaction` AS t
LEFT JOIN
    `KimiaFarma.kf_kantor_cabang` AS k
ON
    t.branch_id = k.branch_id
LEFT JOIN
    `KimiaFarma.kf_product` AS p
ON
    t.product_id = p.product_id
LEFT JOIN
    `KimiaFarma.kf_inventory` AS i
ON
    t.branch_id = i.branch_id AND t.product_id = i.product_id