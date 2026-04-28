SELECT po.customer_id,
       CONCAT(c.last_name, ' ', c.first_name, ' ', c.second_name) AS full_name,
       po.report_date,
       SUM(po.price * po.count) AS daily_amount,
       SUM(SUM(po.price * po.count)) OVER (PARTITION BY po.customer_id
                                           ORDER BY po.report_date) AS cumulative_amount
FROM pharma_orders po
JOIN customers c ON po.customer_id = c.customer_id
GROUP BY po.customer_id,
         full_name,
         po.report_date
ORDER BY po.customer_id,
         po.report_date;

