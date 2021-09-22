-- 1 Check if a single employee is listed twice with multiple ids.
SELECT COUNT(*) AS impacted_record_count,
       CASE
           WHEN COUNT(*) > 0 THEN 'failed'
           ELSE 'passed'
       END  AS test_status
FROM (SELECT client_employee_id FROM data_valid_day_1.employee
GROUP BY client_employee_id HAVING COUNT(*) > 1) result ;

--2 Check if part time employees are assigned other fte_status.
SELECT COUNT(*) AS impacted_record_count,
       CASE
           WHEN COUNT(*) > 0 THEN 'failed'
           ELSE 'passed'
   END  AS test_status
FROM
(SELECT e1.client_employee_id
FROM data_valid_day_1.employee e1
    INNER JOIN data_valid_day_1.employee e2
        ON e1.client_employee_id=e2.client_employee_id
WHERE e1.fte_status = 'Part Time' AND e1.fte_status <> e2.fte_status) result;

--3 Check if termed employees are marked as active.
SELECT COUNT(*) AS impacted_record_count,
       CASE
           WHEN COUNT(*) > 0 THEN 'failed'
           ELSE 'passed'
       END  AS test_status
FROM data_valid_day_1.employee e
WHERE e.term_date IS NOT NULL AND e.is_active = 'true';

--4 Check if the same product is listed more than once in a single bill.
SELECT
    COUNT(*) AS impacted_record_count,
    CASE
        WHEN COUNT(*) > 0 THEN 'failed'
        ELSE 'passed'
    END AS test_status
FROM (
	SELECT COUNT(product_id)
	FROM data_valid_day_1.sales
    GROUP BY bill_no, product_id
    HAVING COUNT(product_id)>1
    )result;

--5 Check if the customer_id in the sales table does not exist in the customer table.
SELECT COUNT(*) AS impacted_record_count,
       CASE
           WHEN COUNT(*) > 0 THEN 'failed'
           ELSE 'passed'
       END  AS test_status
FROM (
     SELECT customer_id FROM data_valid_day_1.sales
     EXCEPT
     SELECT customer_id FROM data_valid_day_1.customer
)
result;

--6 Check if there are any records where updated_by is not empty but updated_date is empty.
WITH cte AS(
    SELECT
        CASE
            WHEN updated_by = '-' THEN NULL --transformation of - to null
            ELSE  updated_by
        END  AS updated_by,
        updated_date

    FROM data_valid_day_1.sales
)
SELECT COUNT(*) AS impacted_record_count,
       CASE
           WHEN COUNT(*) > 0 THEN 'failed'
           ELSE 'passed'
       END  AS test_status
FROM (
        SELECT updated_by, updated_date
        FROM cte s
        WHERE s.updated_by IS NOT NULL AND s.updated_date IS NULL
)
result;

--7 Check if there are any hours worked that are greater than 24 hours.
SELECT COUNT(*) AS impacted_record_count,
       CASE
           WHEN COUNT(*) > 0 THEN 'failed'
           ELSE 'passed'
       END  AS test_status
FROM data_valid_day_1.employee e
WHERE weekly_hours > 24;

--8 Check if non on-call employees are set as on-call.
SELECT COUNT(*) AS impacted_record_count,
       CASE
           WHEN COUNT(*) > 0 THEN 'failed'
           ELSE 'passed'
       END  AS test_status
FROM data_valid_day_1.timesheet t
WHERE t.on_call_hour = 0 AND t.was_on_call = 'true';

--9 Check if the break is true for employees who have not taken a break at all.
SELECT COUNT(*) AS impacted_record_count,
       CASE
           WHEN COUNT(*) > 0 THEN 'failed'
           ELSE 'passed'
       END  AS test_status
FROM data_valid_day_1.timesheet t
WHERE t.break_hour = 0 AND t.has_taken_break = 'true';

--10 Check if the break is true for employees who have not taken a break at all.
SELECT COUNT(*) AS impacted_record_count,
       CASE
           WHEN COUNT(*) > 0 THEN 'failed'
           ELSE 'passed'
       END  AS test_status
FROM (
    SELECT *
    FROM data_valid_day_1.timesheet
    WHERE shift_type = 'Night'
      AND (shift_end_time > '22:05:00' OR shift_start_time < '4:55:00')
    ) result;
    