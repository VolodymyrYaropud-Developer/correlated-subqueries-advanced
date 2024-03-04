SELECT 
p.name, 
p.surname, 
ROUND(AVG(od.price_with_discount * od.product_amount),2) AS avg_purchase, 
ROUND(SUM(od.price_with_discount * od.product_amount),2) AS sum_purchase
FROM order_details od 
JOIN customer_order co ON co.id = od.customer_order_id
LEFT JOIN customer c ON c.person_id = co.customer_id
LEFT JOIN person p ON p.id = c.person_id

GROUP BY p.name, p.surname
HAVING (co.customer_id IN (
  SELECT co.customer_id
  FROM order_details od
  INNER JOIN customer_order co ON co.id = od.customer_order_id
  WHERE co.id = od.customer_order_id
  GROUP BY co.customer_id
  HAVING AVG(od.price * od.product_amount) > 70
) OR co.customer_id IS NULL)
ORDER BY SUM(od.price * od.product_amount), p.surname;