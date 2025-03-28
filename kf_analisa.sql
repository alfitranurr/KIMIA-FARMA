CREATE TABLE `KimiaFarma.kf_analisa`
AS
SELECT
    -- Kolom Mandatory
    t.transaction_id,
    t.date,
    t.branch_id,
    k.branch_name,
    k.kota,
    k.provinsi,
    k.rating AS rating_cabang,
    t.customer_name,
    t.product_id,
    p.product_name,
    t.price AS actual_price,
    t.discount_percentage,
    CASE
        WHEN t.price <= 50000 THEN 0.10
        WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
        WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
        WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
        WHEN t.price > 500000 THEN 0.30
    END AS persentase_gross_laba,
    t.price * (1 - t.discount_percentage) AS nett_sales,
    (t.price * (1 - t.discount_percentage)) * 
    CASE
        WHEN t.price <= 50000 THEN 0.10
        WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
        WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
        WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
        WHEN t.price > 500000 THEN 0.30
    END AS nett_profit,
    t.rating AS rating_transaksi,
    i.opname_stock,
    
    -- Kolom Opsional sebagai tambahan
    k.branch_category,
    p.product_category,
    p.price AS product_price,  -- Harga dari tabel kf_product untuk perbandingan
    i.Inventory_ID,
    i.product_name AS inventory_product_name  -- Nama produk dari kf_inventory
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