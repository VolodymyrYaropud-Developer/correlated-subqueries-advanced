SELECT
    pt.id AS product_id,
    pt.title,
    pm.manufacturer_id,
    m.name AS manufacturer
FROM product_title pt
LEFT JOIN (
    SELECT
        p.product_title_id,
        MAX(p.manufacturer_id) AS manufacturer_id
    FROM product p
    LEFT JOIN order_details od ON p.id = od.product_id
    GROUP BY p.product_title_id
) AS pm ON pt.id = pm.product_title_id
LEFT JOIN manufacturer m ON pm.manufacturer_id = m.id
ORDER BY pt.id ASC;
