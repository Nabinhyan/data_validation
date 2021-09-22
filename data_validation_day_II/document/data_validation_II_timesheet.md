# Validation script for timesheet table
## 1. Checking if the employee is employed to multiple department in single shift_date
For checking the condition that if there exists such employee who are employeed to multiple department in single shift_date, I have grouped the table using employee_id and shift_date then count the department_id. If the count returns value > 1 then, it will return the no. of impacted record along with the test_status of failed else, it will return the no. of impacted record 0 and test_status of passed.
```
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
```
## 2. Checking if the shift_end_time is less than shift_start_time
To check the condition that if the shift_start time is greater than shift_end_time, I have simply used relational operator. if shift_start_time > shift_end_time then, it will return the no. of impacted record along with the test_status of failed else, it will return the no. of impacted record 0 and test_status of passed.
```
SELECT COUNT(*) AS impacted_record_count,
       CASE
           WHEN COUNT(*) > 0 THEN 'failed'
           ELSE 'passed'
       END  AS test_status
FROM data_valid_day_2.timesheet
WHERE shift_start_time > shift_end_time;
```
## 3. Checking if there exists such record where attendance = true and shift_start_time and shift_end_time is null
Actually, I have considered that to be present in attendance, there must exists the not null punch_in_time. Thus I checked the record with attendance = 'true' and punch_in_time is null as pesstimetic validation. If such data is recorede then, it will return the no. of impacted record along with the test_status of failed else, it will return the no. of impacted record 0 and test_status of passed.
```
SELECT COUNT(*) AS impacted_record_count,
       CASE
           WHEN COUNT(*) > 0 THEN 'failed'
           ELSE 'passed'
       END  AS test_status
FROM data_valid_day_2.timesheet
WHERE attendance = 'true'
  AND shift_start_time ISNULL;
```
## 4. Checking if the break hour > 45 minute
Considering that the maximum break time that an employee can take in a day is atmost 45 minute, I have checked that if the break_hour > 0.75 or not. If the record valids the condition check then, it will return the no. of impacted record along with the test_status of failed else, it will return the no. of impacted record 0 and test_status of passed.
```
SELECT COUNT(*) AS impacted_record_count,
       CASE
           WHEN COUNT(*) > 0 THEN 'failed'
           ELSE 'passed'
       END  AS test_status
FROM data_valid_day_2.timesheet
WHERE break_hour > 0.75
```