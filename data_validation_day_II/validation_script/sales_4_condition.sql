-- checking if the product selling date is before product record created date

WITH cte AS(
    SELECT
           CASE
               WHEN bill_date = '2017-02-30 11:00:00' THEN '2017-02-28 11:00:00'::TIMESTAMP::DATE
               ELSE bill_date::TIMESTAMP::DATE
               END As bill_date,
           CASE
               WHEN created_date = '2017-02-30 11:00:00' THEN '2017-02-28 11:00:00'::TIMESTAMP::DATE
               ELSE created_date::TIMESTAMP::DATE
               END As created_date
    FROM data_valid_day_2.sales
)
SELECT COUNT(*) AS impacted_record_count,
       CASE
           WHEN COUNT(*) > 0 THEN 'failed'
           ELSE 'passed'
       END  AS test_status
FROM (
         SELECT s.bill_date,
                s.created_date
         FROM cte s
         WHERE s.created_date > s.bill_date
     )result;

-- check if there exist multiple customer in a single bill
WITH cte AS(
    SELECT
           bill_no,
           COUNT(DISTINCT (customer_id)),
           CASE
               WHEN bill_date = '2017-02-30 11:00:00' THEN '2017-02-28 11:00:00'::TIMESTAMP::DATE
               ELSE bill_date::TIMESTAMP::DATE
               END As bill_date
    FROM data_valid_day_2.sales GROUP BY bill_no, bill_date HAVING COUNT(DISTINCT (customer_id))>1
)
SELECT COUNT(*) AS impacted_record_count,
       CASE
           WHEN COUNT(*) > 0 THEN 'failed'
           ELSE 'passed'
       END  AS test_status
FROM cte;

-- checking existing of such record where sum of price, tax, discount <> net amount
WITH cte AS (
    SELECT *
          FROM data_valid_day_2.sales s
          WHERE (
              ROUND(CAST(s.gross_price AS NUMERIC), 2) +
              ROUND(CAST(s.tax_amt AS NUMERIC), 2) -
              ROUND(CAST(s.discount_amt AS NUMERIC), 2)) <>
                ROUND(CAST(s.net_bill_amt AS NUMERIC), 2)
)
SELECT COUNT(*) AS impacted_record_count,
       CASE
           WHEN COUNT(*) > 0 THEN 'failed'
           ELSE 'passed'
       END  AS test_status
FROM cte;

-- checking for existing of such record where gross amt > net amt
WITH cte AS (
    SELECT *
          FROM data_valid_day_2.sales s
          WHERE
              ROUND(CAST(s.gross_price AS NUMERIC), 2) > ROUND(CAST(s.net_bill_amt AS NUMERIC), 2)
)
SELECT COUNT(*) AS impacted_record_count,
       CASE
           WHEN COUNT(*) > 0 THEN 'failed'
           ELSE 'passed'
       END  AS test_status
FROM cte;

