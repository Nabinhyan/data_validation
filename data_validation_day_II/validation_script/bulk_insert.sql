COPY data_valid_day_2.timesheet
FROM 'D:\leapfrog\Leapfrog_Database_note\data_validation\data_validation_day_II\dataset\timesheet.csv'
DELIMITER ','
CSV HEADER;

-- inserting data to employee table
COPY data_valid_day_2.employee
FROM 'D:\leapfrog\Leapfrog_Database_note\data_validation\data_validation_day_II\dataset\employee.csv'
DELIMITER ','
CSV HEADER;

-- inserting data to product table
COPY data_valid_day_2.product
FROM 'D:\leapfrog\Leapfrog_Database_note\data_validation\data_validation_day_II\dataset\product.csv'
DELIMITER ','
CSV HEADER;

-- inserting data to sales table
COPY data_valid_day_2.sales
FROM 'D:\leapfrog\Leapfrog_Database_note\data_validation\data_validation_day_II\dataset\sales.csv'
DELIMITER ','
CSV HEADER;

