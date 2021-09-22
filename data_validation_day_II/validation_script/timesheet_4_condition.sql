-- checking if the employee is employed to multiple department in single shift_date
SELECT COUNT(*) AS impacted_record_count,
       CASE
           WHEN COUNT(*) > 0 THEN 'failed'
           ELSE 'passed'
       END  AS test_status
FROM(
    SELECT
           employee_id,
           shift_date,
           COUNT(department_id)
    FROM data_valid_day_2.timesheet
    GROUP BY employee_id, shift_date
    HAVING COUNT(department_id)>1
    )
result;

-- checking if the shift_end_time is less than shift_start_time
SELECT COUNT(*) AS impacted_record_count,
       CASE
           WHEN COUNT(*) > 0 THEN 'failed'
           ELSE 'passed'
       END  AS test_status
FROM data_valid_day_2.timesheet
WHERE shift_start_time > shift_end_time;

-- checking if there exists such record where attendance = true and shift_start_time and shift_end_time is null
SELECT COUNT(*) AS impacted_record_count,
       CASE
           WHEN COUNT(*) > 0 THEN 'failed'
           ELSE 'passed'
       END  AS test_status
FROM data_valid_day_2.timesheet
WHERE attendance = 'true'
  AND shift_start_time ISNULL;

-- checking if the break hour > 45 minute
SELECT COUNT(*) AS impacted_record_count,
       CASE
           WHEN COUNT(*) > 0 THEN 'failed'
           ELSE 'passed'
       END  AS test_status
FROM data_valid_day_2.timesheet
WHERE break_hour > 0.75

