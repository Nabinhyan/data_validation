# Validation 
## 1. Check if a single employee is listed twice with multiple ids.
For checking the condition that there exist employee who are listed twice, first I have grouped the table by client_employee_id and check if there exist that count > 1. If it exists, it will return how many count gone fail, else if the count limit to 1, it will return 0 record impacted. This mean, there is employee listed more than once if the result is failed with no. of impacted count.
```
SELECT COUNT(*) AS impacted_record_count,
       CASE
           WHEN COUNT(*) > 0 THEN 'failed'
           ELSE 'passed'
       END  AS test_status
FROM (SELECT client_employee_id FROM data_valid_day_1.employee
GROUP BY client_employee_id HAVING COUNT(*) > 1) result ;
```
## 2. Check if part time employees are assigned other fte_status.
For checking that if the part time employee are assigned to another fte_status, I have made the self join and selected if there exists such employee id who are employed to part time has the another fte_status or not. If there exists the result will return with > 0 impact_record_count with failed test_status.
```
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
```
## 3. Check if termed employees are marked as active.
To check that if terminated employee are marked to active status, I have checked the situation that if the term date id not null and also active status is true.
```
SELECT COUNT(*) AS impacted_record_count,
       CASE
           WHEN COUNT(*) > 0 THEN 'failed'
           ELSE 'passed'
       END  AS test_status
FROM data_valid_day_1.employee e
WHERE e.term_date IS NOT NULL AND e.is_active = 'true';
```
## 4. Check if the same product is listed more than once in a single bill.
To check if a single bill consist same product is listed more than once, I have grouped the table according to bill_no. and product_id then count if the product_id is > 1. If the condition meets it will return the no. of impacted record along with the test_status of failed.
```
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
```
## 5. Check if the customer_id in the sales table does not exist in the customer table.
For checking if the customer_id in sales does not exist in the customer table, I have used except condition. This will select data which are in sales table but not in customer table. If there exist any such record, the query will return the value of  impacted_record_count > 0 with test_status failed. Else it wil return the value of impacted_recored_count = 0 with test_status passed.
```
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
```
## 6. Check if there are any records where updated_by is not empty but updated_date is empty.
For checking if there exists any such record which have updated date is empty and update_by field is not empty, firstly I have transormed the existance of '-' in updated_by field to null in cte. Then I have selected those data where updated_by is not null and update_date is null from cte. If the count is > 0 then it will return the value of  impacted_record_count > 0 with test_status failed. Else it wil return the value of impacted_recored_count = 0 with test_status passed.
```
WITH cte AS(
    SELECT
        CASE
            WHEN updated_by = '-' THEN NULL
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
```
## 7. Check if there are any hours worked that are greater than 24 hours.
For checking if there such record that have the work hours > 24 hours, I have simply used the where condition which will only select such record which have weekly_hours > 24 from employee table. If there exists such record then it will return the value of  impacted_record_count > 0 with test_status failed. Else it wil return the value of impacted_recored_count = 0 with test_status passed.
```
SELECT COUNT(*) AS impacted_record_count,
       CASE
           WHEN COUNT(*) > 0 THEN 'failed'
           ELSE 'passed'
       END  AS test_status
FROM data_valid_day_1.employee e
WHERE weekly_hours > 24;
```
## 8. Check if non on-call employees are set as on-call.
To check if the employee with non on-call status has been set to on-call status to true, I have selected such record which on_call_hour = 0 and wan_on_call = 'true'. If there exists such record then it will return the value of  impacted_record_count > 0 with test_status failed. Else it wil return the value of impacted_recored_count = 0 with test_status passed.
```
SELECT COUNT(*) AS impacted_record_count,
       CASE
           WHEN COUNT(*) > 0 THEN 'failed'
           ELSE 'passed'
       END  AS test_status
FROM data_valid_day_1.timesheet t
WHERE t.on_call_hour = 0 AND t.was_on_call = 'true';
```
## 9. Check if the break is true for employees who have not taken a break at all.
To check if the employee who have not taken break but break status has been set to true, so I have selected such record which break_hour = 0 and has_taken_break = 'true'. If there exists such record then it will return the value of  impacted_record_count > 0 with test_status failed. Else it wil return the value of impacted_recored_count = 0 with test_status passed.
```
SELECT COUNT(*) AS impacted_record_count,
       CASE
           WHEN COUNT(*) > 0 THEN 'failed'
           ELSE 'passed'
       END  AS test_status
FROM data_valid_day_1.timesheet t
WHERE t.break_hour = 0 AND t.has_taken_break = 'true';
```
## 10. Check if the night shift is not assigned to the employees working on the night shift.
For checking existance of such employee who are working in night shift who are not assigned to night shift, I have choosed the arbitary shift start time to 22:05:00 and shift end time to 4:55:00. If the employee with shift_type = 'Night' have the shift_end_time > '22:05:00' and shift_start_time < '4:55:00'. This mean if the employee continues his/her day duty even after '22:05:00' then it has been count to night shift however he/she has been assigned to evening shift. Also if the employee shift starting time is less than '4:55:00' he/she is counted in night shift however his/her shift is morning. If there exists such record then it will return the value of  impacted_record_count > 0 with test_status failed. Else it wil return the value of impacted_recored_count = 0 with test_status passed.
```
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
```