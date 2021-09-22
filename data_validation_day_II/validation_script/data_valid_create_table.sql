CREATE DATABASE data_validation;

CREATE SCHEMA IF NOT EXISTS data_valid_day_2;

-- create employee table
CREATE TABLE IF NOT EXISTS data_valid_day_2.employee(
    client_employee_id VARCHAR(255),
    department_id VARCHAR(255),
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    manager_employee_id VARCHAR(255),
    salary FLOAT,
    hire_date DATE,
    term_date DATE,
    term_reason VARCHAR(255),
    dob DATE,
    fte FLOAT,
    fte_status VARCHAR(255),
    weekly_hours FLOAT,
    role VARCHAR(255),
    is_active BOOLEAN
);

-- create timesheet table
CREATE TABLE IF NOT EXISTS data_valid_day_2.timesheet(
    employee_id VARCHAR(255),
    department_id VARCHAR(255),
    shift_start_time TIME,
    shift_end_time TIME,
    shift_date DATE,
    shift_type VARCHAR(255),
    hours_worked FLOAT,
    attendance BOOLEAN,
    has_taken_break BOOLEAN,
    break_hour FLOAT,
    was_charge BOOLEAN,
    charge_hour FLOAT,
    was_on_call BOOLEAN,
    on_call_hour FLOAT,
    num_teammates_absent INT
);

-- create customer table
CREATE TABLE IF NOT EXISTS data_valid_day_2.customer(
    customer_id INT,
    username VARCHAR(255),
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    country VARCHAR(255),
    town VARCHAR(255),
    is_active BOOLEAN
);

-- create product table
CREATE TABLE IF NOT EXISTS data_valid_day_2.product(
    product_id INT,
    product_name VARCHAR(255),
    description VARCHAR(255),
    price FLOAT,
    mrp FLOAT,
    pieces_per_case INT,
    weight_per_piece FLOAT,
    uom VARCHAR(255),
    brand VARCHAR(255),
    category VARCHAR(255),
    tax_percent FLOAT,
    active BOOLEAN,
    created_by VARCHAR(255),
    created_date TIMESTAMP,
    updated_by VARCHAR(255),
    updated_date TIMESTAMP
);

-- create sales table
CREATE TABLE IF NOT EXISTS data_valid_day_2.sales(
    id INT,
    transaction_id INT,
    bill_no INT,
    bill_date VARCHAR(255),
    bill_location VARCHAR(255),
    customer_id INT,
    product_id INT,
    qty INT,
    uom VARCHAR(255),
    price FLOAT,
    gross_price FLOAT,
    tax_pc FLOAT,
    tax_amt FLOAT,
    discount_pc FLOAT,
    discount_amt FLOAT,
    net_bill_amt FLOAT,
    created_by VARCHAR(255),
    updated_by VARCHAR(255),
    created_date VARCHAR(255),
    updated_date VARCHAR(255)
);

