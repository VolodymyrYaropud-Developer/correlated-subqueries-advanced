SELECT
    p.id,
    p.comment AS title,
    count_with_discount_5,
    count_without_discount_5,
    IFNULL(
    ROUND(
        (
            (count_with_discount_5 - count_without_discount_5) * 100.0
        ) / NULLIF((count_with_discount_5 + count_without_discount_5), 0),
        2
    ),0.0) AS difference
FROM product p
LEFT JOIN (
    SELECT
        p.id AS product_id,
        COALESCE(SUM(CASE WHEN c.discount > 0.05 THEN od.product_amount ELSE 0 END), 0) AS count_with_discount_5,
        COALESCE(SUM(CASE WHEN c.discount <= 0.05 OR c.discount IS NULL THEN od.product_amount ELSE 0 END), 0) AS count_without_discount_5
    FROM product p
    LEFT JOIN order_details od ON p.id = od.product_id
    LEFT JOIN customer_order co ON od.customer_order_id = co.id
    LEFT JOIN customer c ON co.customer_id = c.person_id
    WHERE p.comment IS NOT NULL
    GROUP BY p.id
) AS counts ON p.id = counts.product_id
ORDER BY p.id ASC;
