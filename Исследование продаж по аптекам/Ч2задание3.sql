WITH customer_ages AS
  (SELECT customer_id,
          gender,
          EXTRACT(YEAR
                  FROM AGE (CAST (date_of_birth AS DATE))) AS customer_age,
          CASE
              WHEN gender = 'муж'
                   AND EXTRACT(YEAR
                               FROM AGE (CAST (date_of_birth AS DATE))) < 30 THEN 'Мужчины младше 30'
              WHEN gender = 'муж'
                   AND EXTRACT(YEAR
                               FROM AGE (CAST (date_of_birth AS DATE))) BETWEEN 30 AND 45 THEN 'Мужчины 30-45'
              WHEN gender = 'муж'
                   AND EXTRACT(YEAR
                               FROM AGE (CAST (date_of_birth AS DATE))) > 45 THEN 'Мужчины 45+'
              WHEN gender = 'жен'
                   AND EXTRACT(YEAR
                               FROM AGE (CAST (date_of_birth AS DATE))) < 30 THEN 'Женщины младше 30'
              WHEN gender = 'жен'
                   AND EXTRACT(YEAR
                               FROM AGE (CAST (date_of_birth AS DATE))) BETWEEN 30 AND 45 THEN 'Женщины 30-45'
              WHEN gender = 'жен'
                   AND EXTRACT(YEAR
                               FROM AGE (CAST (date_of_birth AS DATE))) > 45 THEN 'Женщины 45+'
              ELSE 'Другая группа'
          END AS customer_group
   FROM customers),
     customer_groups AS
  (SELECT customer_group,
          COUNT(DISTINCT c_a.customer_id) AS cust_in_group_cnt,
          SUM(price*COUNT) AS cust_group_amnt
   FROM customer_ages AS c_a
   INNER JOIN pharma_orders AS p_o USING(customer_id)
   GROUP BY customer_group),
     total_sales AS
  (SELECT SUM (price*COUNT) AS total_sales
   FROM pharma_orders)
SELECT customer_group,
       cust_in_group_cnt,
       cust_group_amnt,
       total_sales,
       ROUND((cust_group_amnt::NUMERIC*100/total_sales::NUMERIC),1) AS cust_group_share_perc
FROM customer_groups
CROSS JOIN total_sales