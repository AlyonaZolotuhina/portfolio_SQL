WITH pharmacy_drug AS
  (SELECT pharmacy_name,
          drug,
          SUM(price*COUNT) AS order_amnt
   FROM pharma_orders
   WHERE LOWER(drug) LIKE '%аква%'
   GROUP BY drug,
            pharmacy_name),
     pharmacy_total_sales AS
  (SELECT pharmacy_name,
          SUM(price*COUNT) AS total_pharmacy_sales
   FROM pharma_orders
   GROUP BY pharmacy_name)
SELECT pharmacy_name,
       drug,
       ROW_NUMBER() OVER(PARTITION BY pharmacy_name
                         ORDER BY order_amnt DESC) AS drug_rank,
       order_amnt,
       total_pharmacy_sales,
       ROUND((order_amnt::NUMERIC*100/total_pharmacy_sales::NUMERIC),1) AS drug_in_pharmacy_share
FROM pharmacy_drug
INNER JOIN pharmacy_total_sales USING(pharmacy_name)
ORDER BY pharmacy_name,
         order_amnt DESC