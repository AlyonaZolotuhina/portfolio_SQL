SELECT pharmacy_name,
       report_date,
       SUM(price * COUNT) AS daily_sales,
       SUM(SUM(price * COUNT)) OVER (PARTITION BY pharmacy_name
                                     ORDER BY report_date) AS cumulative_sales
FROM pharma_orders
GROUP BY pharmacy_name,
         report_date
ORDER BY pharmacy_name,
         report_date;