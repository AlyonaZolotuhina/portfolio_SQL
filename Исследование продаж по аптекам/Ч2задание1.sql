WITH prep AS
  (SELECT pharmacy_name,
          city,
          DATE_TRUNC('month', report_date::DATE) AS MONTH,
          price * COUNT AS sales
   FROM pharma_orders),
     msc AS
  (SELECT pharmacy_name,
          MONTH,
          SUM(sales) AS sales_msc
   FROM prep
   WHERE city = 'Москва'
   GROUP BY pharmacy_name,
            MONTH),
     spb AS
  (SELECT pharmacy_name,
          MONTH,
          SUM(sales) AS sales_spb
   FROM prep
   WHERE city = 'Санкт-Петербург'
   GROUP BY pharmacy_name,
            MONTH)
SELECT msc.pharmacy_name,
       msc.month,
       msc.sales_msc,
       spb.sales_spb,
       ROUND((msc.sales_msc::NUMERIC * 100 / spb.sales_spb::NUMERIC) - 100, 1) AS diff_percent
FROM msc
INNER JOIN spb ON msc.pharmacy_name = spb.pharmacy_name
AND msc.month = spb.month
ORDER BY msc.pharmacy_name,
         msc.month;

/*
Выводы:
Показаны помесячные продажи по каждой аптеке для Москвы и Санкт-Петербурга.
В Москве самые высокие продажи были в мае, которые показала аптека "Доктор Айболит",
а самые низкие были в июне у аптеки "Здравсити".
В Санкт-Петербурге самые высокие продажи тоже были в мае, которые показала аптека "Аптека.ру",
а самые низкие были в июне у аптеки "Аптека №1".
*/