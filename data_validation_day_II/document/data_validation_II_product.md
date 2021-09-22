# Validation script for product table
## 1. Checking if there exists a product with no category
For any product, there must be category though it may not have brand. Thus I have checked if there exists such record that the product have no any category. If such record exists, then, it will return the no. of impacted record along with the test_status of failed else, it will return the no. of impacted record 0 and test_status of passed.
```
SELECT COUNT(*) AS impacted_record_count,
       CASE
           WHEN COUNT(*) > 0 THEN 'failed'
           ELSE 'passed'
       END  AS test_status
FROM data_valid_day_2.product WHERE product_name IS NOT NULL AND (category='' OR category = 'NULL');
```
## 2. Checking if there exists such product which has no price rate
For any product, there must be price though it may not have mrp. Thus I have checked if there exists such record that the product have no price. If such record exists, then, it will return the no. of impacted record along with the test_status of failed else, it will return the no. of impacted record 0 and test_status of passed.
```
SELECT COUNT(*) AS impacted_record_count,
       CASE
           WHEN COUNT(*) > 0 THEN 'failed'
           ELSE 'passed'
       END  AS test_status
FROM data_valid_day_2.product WHERE product_name IS NOT NULL AND price ISNULL;
```
## 3. Checking if there exists such record whose mrp < price
For any product, if there exists the mrp, then it must be greater than or equal to selling price but it cannot be less than selling price. Thus I have checked if such data which have mrp < selling price is recorded then, it will return the no. of impacted record along with the test_status of failed else, it will return the no. of impacted record 0 and test_status of passed.
```
SELECT COUNT(*) AS impacted_record_count,
       CASE
           WHEN COUNT(*) > 0 THEN 'failed'
           ELSE 'passed'
       END  AS test_status
FROM data_valid_day_2.product WHERE mrp < price;
```
## 4. Checking existing of product with different price
There must not be different price to a same product on same date. Thus I have checked if there exists such a record with same product name and different price created on same date by grouping the table by product_name and created_date and counding the occurance of price. If count of such record is greater than 1, it will return the no. of impacted record along with the test_status of failed else, it will return the no. of impacted record 0 and test_status of passed.
```
SELECT COUNT(*) AS impacted_record_count,
       CASE
           WHEN COUNT(*) > 0 THEN 'failed'
           ELSE 'passed'
       END  AS test_status
FROM(
    SELECT
       product_name,
       created_date::TIMESTAMP::DATE,
       COUNT(price)
    FROM data_valid_day_2.product
    GROUP BY product_name, created_date HAVING COUNT(DISTINCT(price))>1
    )result;
```