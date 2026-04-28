SELECT *
FROM
  (SELECT c.customer_id,
          c.first_name,
          c.last_name,
          SUM(po.price * po.count) AS total_orders,
          ROW_NUMBER() OVER (
                             ORDER BY SUM(po.price * po.count) DESC) AS rn
   FROM pharma_orders po
   JOIN customers c ON po.customer_id = c.customer_id
   GROUP BY c.customer_id,
            c.first_name,
            c.last_name) t
WHERE rn <= 10;