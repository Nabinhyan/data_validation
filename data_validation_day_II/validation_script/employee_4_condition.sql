--checking if the employee is greater than 18 yr when he/she got hired
SELECT COUNT(*) AS impacted_record_count,
       CASE
           WHEN COUNT(*) > 0 THEN 'failed'
           ELSE 'passed'
       END  AS test_status
FROM data_valid_day_2.employee
WHERE DATE_PART('year',age(hire_date, dob)) < 18;

-- checking if a single employee is hired to multiple department in a single day
WITH chk_multiple_department_one_employee_same_hire_date AS (
    SELECT
           client_employee_id,
           hire_date::TIMESTAMP::DATE,
           COUNT(department_id)
    FROM data_valid_day_2.employee
    GROUP BY client_employee_id, hire_date::TIMESTAMP::DATE
    HAVING COUNT(department_id)>1
)
SELECT COUNT(*) AS impacted_record_count,
       CASE
           WHEN COUNT(*) > 0 THEN 'failed'
           ELSE 'passed'
       END  AS test_status
FROM chk_multiple_department_one_employee_same_hire_date;

--checking if the manager is a employee
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

--checks if the manager is full timer or not
SELECT COUNT(*) AS impacted_record_count,
       CASE
           WHEN COUNT(*) > 0 THEN 'failed'
           ELSE 'passed'
       END  AS test_status
FROM data_valid_day_2.employee
WHERE manager_employee_id is NOT NULL AND fte_status <> 'Full Time'

