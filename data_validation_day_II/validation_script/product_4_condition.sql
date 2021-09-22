-- checking if there exists a product with no category
SELECT COUNT(*) AS impacted_record_count,
       CASE
           WHEN COUNT(*) > 0 THEN 'failed'
           ELSE 'passed'
       END  AS test_status
FROM data_valid_day_2.product WHERE product_name IS NOT NULL AND (category='' OR category = 'NULL');

-- checking if there exists such product which has no price rate
SELECT COUNT(*) AS impacted_record_count,
       CASE
           WHEN COUNT(*) > 0 THEN 'failed'
           ELSE 'passed'
       END  AS test_status
FROM data_valid_day_2.product WHERE product_name IS NOT NULL AND price ISNULL;

-- checking if there exists such record whose mrp < price
SELECT COUNT(*) AS impacted_record_count,
       CASE
           WHEN COUNT(*) > 0 THEN 'failed'
           ELSE 'passed'
       END  AS test_status
FROM data_valid_day_2.product WHERE mrp < price;

-- checking existing of product with different price
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





