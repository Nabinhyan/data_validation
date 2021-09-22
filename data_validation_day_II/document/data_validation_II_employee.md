# Validation script for employee table
## 1. Checking if the employee is greater than 18 yr when he/she got hired
For checking the condition that there exist employee who are hired before the age of 18 on the date of hire, first I have get the age of the employee on the date of hire in year using age and date_part function. If the age is < 18 then, it will return the no. of impacted record along with the test_status of failed else, it will return the no. of impacted record 0 and test_status of passed.
```
SELECT COUNT(*) AS impacted_record_count,
       CASE
           WHEN COUNT(*) > 0 THEN 'failed'
           ELSE 'passed'
       END  AS test_status
FROM data_valid_day_2.employee
WHERE date_part('year',age(hire_date, dob)) < 18;
```
## 2. Checking if a single employee is hired to multiple department in a single day
To check the condition that if the employee is hired to multiple department on a single date or not, I have first group the table using client_employee_id and hire_date and count the department. For this, I have used the cte. If the count is greater than 1, then, it will return the no. of impacted record along with the test_status of failed else, it will return the no. of impacted record 0 and test_status of passed.
```
WITH chk_multiple_department_one_employee_same_hire_date AS (
    SELECT
           client_employee_id,
           hire_date::timestamp::date,
           COUNT(department_id)
    FROM data_valid_day_2.employee
    GROUP BY client_employee_id, hire_date::timestamp::date
    HAVING COUNT(department_id)>1
)
SELECT COUNT(*) AS impacted_record_count,
       CASE
           WHEN COUNT(*) > 0 THEN 'failed'
           ELSE 'passed'
       END  AS test_status
FROM chk_multiple_department_one_employee_same_hire_date;
```
## 3. Checking if the manager is a employee
According to my understanding, to be a manager he/she must be employee to the company. Thus I have first check if there exists manager_employee_id is also client_employee_id. If the manager is not employee, it will return the no. of impacted record along with the test_status of failed else, it will return the no. of impacted record 0 and test_status of passed.
```
SELECT COUNT(*) AS impacted_record_count,
       CASE
           WHEN COUNT(*) > 0 THEN 'failed'
           ELSE 'passed'
       END  AS test_status
FROM (
         SELECT manager_employee_id
         FROM data_valid_day_2.employee
         WHERE manager_employee_id IS NOT NULL
             EXCEPT
         SELECT client_employee_id
         FROM data_valid_day_2.employee
     )result;
```
## 4. Checks if the manager is full timer or not
To be a manager the employee also should be full timer. Thus I have firstly checked if the manager_employee_id has fte_status to 'Full Time' or not. If the fte_status is not 'Full Time' then, it will return the no. of impacted record along with the test_status of failed else, it will return the no. of impacted record 0 and test_status of passed.
```
SELECT COUNT(*) AS impacted_record_count,
       CASE
           WHEN COUNT(*) > 0 THEN 'failed'
           ELSE 'passed'
       END  AS test_status
FROM data_valid_day_2.employee
WHERE manager_employee_id is NOT NULL AND fte_status <> 'Full Time'
```