# Validation script for sales table
## 1. Checking if the product selling date is before product record created date
The product must be able to be sold only after the product is registered in product table else the product must not be able to be sold. For this firstly I have changed the existance of 2017:02:30 11:00:00 to 2017:02:30 11:00:00 using case. Then, if the product created date > bill_date. If there exists such record which have created date < bill_date then, it will return the no. of impacted record along with the test_status of failed else, it will return the no. of impacted record 0 and test_status of passed.
```
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
```
## 2. Check if there exist multiple customer in a single bill
Practically, in a single bill, it is not possible to include multiple customer_id on a single date. Thus to check if there exist the multiple customer_id on single bill in single_date, I have grouped the table by bill_no, bill date and count the distinct customer id. If the count is > 1 then, it will return the no. of impacted record along with the test_status of failed else, it will return the no. of impacted record 0 and test_status of passed.
```
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
```
## 3. Checking existing of such record where sum of price, tax, discount <> net amount
The net calculated amount and the gross amount + tax_amount - discount amount must be same in a bill. For this firstly, I have cast the floating point to numeric value with only 2 precision value. and calculated the above calculation. If the result is not same as the pre-calculated net amount then, it will return the no. of impacted record along with the test_status of failed else, it will return the no. of impacted record 0 and test_status of passed.
```
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
```
## 4. Checking for existing of such record where gross amt > net amt
The gross amount of the product must be less than the net amount. The net amount is the sum of tax amount, gross amount and deduction of discount amount. thus the net amount should not be less than the gross amount. For this I have simply used the relational operator to check whether the gross amount is > net amount or not. If the gross amount > net amount then, it will return the no. of impacted record along with the test_status of failed else, it will return the no. of impacted record 0 and test_status of passed.
```
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
```
