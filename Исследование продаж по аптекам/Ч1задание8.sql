WITH gorzdrav AS
  (SELECT *
   FROM
     (SELECT po.customer_id,
             pharmacy_name,
             CONCAT(c.last_name, ' ', c.first_name, ' ', c.second_name) AS full_name,
             COUNT(po.order_id) AS orders_count,
             ROW_NUMBER() OVER (
                                ORDER BY COUNT(po.order_id) DESC) AS rn
      FROM pharma_orders po
      JOIN customers c ON po.customer_id = c.customer_id
      WHERE po.pharmacy_name = 'Горздрав'
      GROUP BY po.customer_id,
               full_name) t
   WHERE rn <= 10),
     zdravcity AS
  (SELECT *
   FROM
     (SELECT po.customer_id,
             pharmacy_name,
             CONCAT(c.last_name, ' ', c.first_name, ' ', c.second_name) AS full_name,
             COUNT(po.order_id) AS orders_count,
             ROW_NUMBER() OVER (
                                ORDER BY COUNT(po.order_id) DESC) AS rn
      FROM pharma_orders po
      JOIN customers c ON po.customer_id = c.customer_id
      WHERE po.pharmacy_name = 'Здравсити'
      GROUP BY po.customer_id,
               full_name) t
   WHERE rn <= 10)
SELECT *
FROM gorzdrav
UNION
SELECT *
FROM zdravcity
ORDER BY pharmacy_name,
         rn