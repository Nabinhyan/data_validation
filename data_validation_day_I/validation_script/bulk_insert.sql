-- inserting data to timesheet_raw table
COPY data_valid_day_1.timesheet_raw
FROM 'D:\leapfrog\Leapfrog_Database_note\data_validation\data_validation_day_I\dataset\timesheet_raw.csv'
CSV HEADER
;

-- inserting data to employee_raw table
COPY data_valid_day_1.employee_raw
FROM 'D:\leapfrog\Leapfrog_Database_note\data_validation\data_validation_day_I\dataset\employee_raw.csv'
DELIMITER ','
CSV HEADER;

COPY data_valid_day_1.timesheet
FROM 'D:\leapfrog\Leapfrog_Database_note\data_validation\data_validation_day_I\dataset\timesheet.csv'
DELIMITER ','
CSV HEADER;

-- inserting data to employee table
COPY data_valid_day_1.employee
FROM 'D:\leapfrog\Leapfrog_Database_note\data_validation\data_validation_day_I\dataset\employee.csv'
DELIMITER ','
CSV HEADER;

COPY data_valid_day_1.customer
FROM 'D:\leapfrog\Leapfrog_Database_note\data_validation\data_validation_day_I\dataset\customer.csv'
DELIMITER ','
CSV HEADER;

-- inserting data to product table
COPY data_valid_day_1.product
FROM 'D:\leapfrog\Leapfrog_Database_note\data_validation\data_validation_day_I\dataset\product.csv'
DELIMITER ','
CSV HEADER;

-- inserting data to sales table
COPY data_valid_day_1.sales
FROM 'D:\leapfrog\Leapfrog_Database_note\data_validation\data_validation_day_I\dataset\sales.csv'
DELIMITER ','
CSV HEADER;
