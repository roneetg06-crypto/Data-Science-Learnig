/*
Project : SQL Learning Datasets
Author  : Roneet Gupta
Database: PostgreSQL

Description:
This file creates two complete learning datasets:
1. Employee Management - Week 1
2. Amazon Sales Analytics - Week 2
*/

-- ============================================================
-- Project 1: Employee Management Dataset - Week 1
-- ============================================================

-- Drop Employee Management tables
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

-- Create departments table
CREATE TABLE departments (
    department_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(100) NOT NULL,
    budget NUMERIC(12, 2) NOT NULL CHECK (budget >= 0)
);

-- Create employees table
CREATE TABLE employees (
    employee_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    phone VARCHAR(20),
    hire_date DATE NOT NULL,
    job_title VARCHAR(100) NOT NULL,
    salary NUMERIC(10, 2) NOT NULL CHECK (salary > 0),
    department_id INTEGER NOT NULL,
    manager_id INTEGER,
    CONSTRAINT fk_employees_department
        FOREIGN KEY (department_id)
        REFERENCES departments (department_id),
    CONSTRAINT fk_employees_manager
        FOREIGN KEY (manager_id)
        REFERENCES employees (employee_id)
);

-- Insert departments data
INSERT INTO departments (department_name, location, budget) VALUES
('Human Resources', 'Bengaluru', 2500000.00),
('Finance', 'Mumbai', 4200000.00),
('Engineering', 'Hyderabad', 9800000.00),
('Sales', 'Delhi', 5600000.00),
('Marketing', 'Pune', 3100000.00),
('Customer Support', 'Chennai', 2800000.00);

-- Insert employees data
INSERT INTO employees (
    first_name,
    last_name,
    email,
    phone,
    hire_date,
    job_title,
    salary,
    department_id,
    manager_id
) VALUES
('Amit', 'Sharma', 'amit.sharma@example.com', '9876543210', '2018-04-10', 'HR Manager', 92000.00, 1, NULL),
('Priya', 'Nair', 'priya.nair@example.com', '9876543211', '2019-07-15', 'Finance Manager', 105000.00, 2, NULL),
('Rahul', 'Verma', 'rahul.verma@example.com', '9876543212', '2017-02-20', 'Engineering Manager', 145000.00, 3, NULL),
('Sneha', 'Iyer', 'sneha.iyer@example.com', '9876543213', '2020-01-12', 'Sales Manager', 98000.00, 4, NULL),
('Karan', 'Mehta', 'karan.mehta@example.com', '9876543214', '2021-03-18', 'Marketing Manager', 88000.00, 5, NULL),
('Ananya', 'Rao', 'ananya.rao@example.com', '9876543215', '2022-06-01', 'Support Manager', 76000.00, 6, NULL),
('Neha', 'Kapoor', 'neha.kapoor@example.com', '9876543216', '2021-08-09', 'HR Executive', 52000.00, 1, 1),
('Vikram', 'Singh', 'vikram.singh@example.com', '9876543217', '2020-11-23', 'Accountant', 61000.00, 2, 2),
('Ishaan', 'Das', 'ishaan.das@example.com', '9876543218', '2022-02-14', 'Software Engineer', 86000.00, 3, 3),
('Meera', 'Joshi', 'meera.joshi@example.com', '9876543219', '2023-05-08', 'Data Analyst', 78000.00, 3, 3),
('Arjun', 'Patel', 'arjun.patel@example.com', '9876543220', '2021-12-03', 'Sales Executive', 57000.00, 4, 4),
('Riya', 'Malhotra', 'riya.malhotra@example.com', '9876543221', '2023-01-16', 'Marketing Specialist', 59000.00, 5, 5),
('Dev', 'Bose', 'dev.bose@example.com', '9876543222', '2022-09-27', 'Customer Support Associate', 43000.00, 6, 6),
('Fatima', 'Khan', 'fatima.khan@example.com', '9876543223', '2020-04-06', 'Senior Software Engineer', 112000.00, 3, 3),
('Nikhil', 'Gupta', 'nikhil.gupta@example.com', '9876543224', '2024-02-19', 'Junior Accountant', 45000.00, 2, 2),
('Pooja', 'Agarwal', 'pooja.agarwal@example.com', '9876543225', '2023-10-02', 'Recruiter', 56000.00, 1, 1),
('Manav', 'Saxena', 'manav.saxena@example.com', '9876543226', '2021-06-21', 'Business Development Executive', 63000.00, 4, 4),
('Kavya', 'Menon', 'kavya.menon@example.com', '9876543227', '2022-12-12', 'Content Marketing Associate', 54000.00, 5, 5);

-- ============================================================
-- Project 2: Amazon Sales Analytics Dataset - Week 2
-- ============================================================

-- Drop Amazon Sales Analytics tables
DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS customers;

-- Create customers table
CREATE TABLE customers (
    customer_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    phone VARCHAR(20),
    city VARCHAR(80) NOT NULL,
    state VARCHAR(80) NOT NULL,
    country VARCHAR(80) NOT NULL DEFAULT 'India',
    signup_date DATE NOT NULL
);

-- Create categories table
CREATE TABLE categories (
    category_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- Create products table
CREATE TABLE products (
    product_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category_id INTEGER NOT NULL,
    brand VARCHAR(100) NOT NULL,
    price NUMERIC(10, 2) NOT NULL CHECK (price >= 0),
    stock_quantity INTEGER NOT NULL CHECK (stock_quantity >= 0),
    rating NUMERIC(3, 2) CHECK (rating >= 0 AND rating <= 5),
    CONSTRAINT fk_products_category
        FOREIGN KEY (category_id)
        REFERENCES categories (category_id)
);

-- Create orders table
CREATE TABLE orders (
    order_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date DATE NOT NULL,
    order_status VARCHAR(30) NOT NULL CHECK (
        order_status IN ('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled', 'Returned')
    ),
    payment_method VARCHAR(30) NOT NULL CHECK (
        payment_method IN ('Credit Card', 'Debit Card', 'UPI', 'Net Banking', 'Cash on Delivery', 'Wallet')
    ),
    shipping_city VARCHAR(80) NOT NULL,
    shipping_state VARCHAR(80) NOT NULL,
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers (customer_id)
);

-- Create order_details table
CREATE TABLE order_details (
    order_detail_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10, 2) NOT NULL CHECK (unit_price >= 0),
    discount_percent NUMERIC(5, 2) NOT NULL DEFAULT 0 CHECK (
        discount_percent >= 0 AND discount_percent <= 100
    ),
    CONSTRAINT fk_order_details_order
        FOREIGN KEY (order_id)
        REFERENCES orders (order_id),
    CONSTRAINT fk_order_details_product
        FOREIGN KEY (product_id)
        REFERENCES products (product_id)
);

-- Insert customers data
INSERT INTO customers (
    first_name,
    last_name,
    email,
    phone,
    city,
    state,
    country,
    signup_date
) VALUES
('Aarav', 'Menon', 'aarav.menon@example.com', '9000010001', 'Bengaluru', 'Karnataka', 'India', '2023-01-15'),
('Diya', 'Shah', 'diya.shah@example.com', '9000010002', 'Mumbai', 'Maharashtra', 'India', '2023-02-20'),
('Kabir', 'Sinha', 'kabir.sinha@example.com', '9000010003', 'Delhi', 'Delhi', 'India', '2023-03-12'),
('Ira', 'Chopra', 'ira.chopra@example.com', '9000010004', 'Pune', 'Maharashtra', 'India', '2023-04-05'),
('Vivaan', 'Reddy', 'vivaan.reddy@example.com', '9000010005', 'Hyderabad', 'Telangana', 'India', '2023-05-18'),
('Tara', 'Bajaj', 'tara.bajaj@example.com', '9000010006', 'Chennai', 'Tamil Nadu', 'India', '2023-06-09'),
('Reyansh', 'Kulkarni', 'reyansh.kulkarni@example.com', '9000010007', 'Ahmedabad', 'Gujarat', 'India', '2023-07-25'),
('Mira', 'Pillai', 'mira.pillai@example.com', '9000010008', 'Kochi', 'Kerala', 'India', '2023-08-14'),
('Advik', 'Bhatia', 'advik.bhatia@example.com', '9000010009', 'Jaipur', 'Rajasthan', 'India', '2023-09-02'),
('Sara', 'Thomas', 'sara.thomas@example.com', '9000010010', 'Kolkata', 'West Bengal', 'India', '2023-10-11'),
('Rohan', 'Mathur', 'rohan.mathur@example.com', '9000010011', 'Lucknow', 'Uttar Pradesh', 'India', '2023-11-03'),
('Nisha', 'Ghosh', 'nisha.ghosh@example.com', '9000010012', 'Guwahati', 'Assam', 'India', '2023-12-19');

-- Insert categories data
INSERT INTO categories (category_name, description) VALUES
('Electronics', 'Smartphones, laptops, audio devices, and digital accessories'),
('Home & Kitchen', 'Kitchen appliances, cookware, storage, and home improvement items'),
('Fashion', 'Clothing, footwear, watches, and personal accessories'),
('Books', 'Fiction, non-fiction, academic, and professional books'),
('Beauty & Personal Care', 'Skincare, grooming, wellness, and personal care products'),
('Sports & Outdoors', 'Fitness equipment, outdoor gear, and sports accessories');

-- Insert products data
INSERT INTO products (
    product_name,
    category_id,
    brand,
    price,
    stock_quantity,
    rating
) VALUES
('Noise Cancelling Bluetooth Headphones', 1, 'Sony', 12999.00, 45, 4.60),
('Smartphone 128GB Midnight Black', 1, 'Samsung', 38999.00, 30, 4.50),
('Laptop 14 Inch i5 16GB RAM', 1, 'HP', 64999.00, 18, 4.40),
('Wireless Mouse', 1, 'Logitech', 1199.00, 100, 4.50),
('Air Fryer 4.5L', 2, 'Philips', 8999.00, 35, 4.30),
('Stainless Steel Cookware Set', 2, 'Prestige', 4499.00, 60, 4.20),
('Mixer Grinder 750W', 2, 'Bajaj', 3299.00, 40, 4.00),
('Men Running Shoes', 3, 'Nike', 5999.00, 80, 4.10),
('Women Denim Jacket', 3, 'Levis', 3499.00, 55, 4.00),
('Atomic Habits Paperback', 4, 'Penguin Random House', 499.00, 120, 4.80),
('Data Analytics with SQL', 4, 'TechPress', 799.00, 70, 4.50),
('Vitamin C Face Serum', 5, 'Minimalist', 699.00, 90, 4.30),
('Electric Toothbrush', 5, 'Oral-B', 2499.00, 50, 4.20),
('Yoga Mat 6mm', 6, 'Boldfit', 999.00, 110, 4.40),
('Adjustable Dumbbell Pair', 6, 'Lifelong', 3999.00, 25, 4.10),
('Smartwatch AMOLED Display', 1, 'Amazfit', 7999.00, 65, 4.20),
('Cotton Bedsheet Queen Size', 2, 'Wakefit', 1499.00, 95, 4.10),
('Backpack 32L Waterproof', 3, 'Wildcraft', 2199.00, 75, 4.30);

-- Insert orders data
INSERT INTO orders (
    customer_id,
    order_date,
    order_status,
    payment_method,
    shipping_city,
    shipping_state
) VALUES
(1, '2024-01-05', 'Delivered', 'UPI', 'Bengaluru', 'Karnataka'),
(2, '2024-01-08', 'Delivered', 'Credit Card', 'Mumbai', 'Maharashtra'),
(3, '2024-01-11', 'Shipped', 'Debit Card', 'Delhi', 'Delhi'),
(4, '2024-01-15', 'Delivered', 'Net Banking', 'Pune', 'Maharashtra'),
(5, '2024-01-18', 'Processing', 'UPI', 'Hyderabad', 'Telangana'),
(6, '2024-01-22', 'Delivered', 'Cash on Delivery', 'Chennai', 'Tamil Nadu'),
(7, '2024-01-26', 'Cancelled', 'Wallet', 'Ahmedabad', 'Gujarat'),
(8, '2024-02-02', 'Delivered', 'Credit Card', 'Kochi', 'Kerala'),
(9, '2024-02-06', 'Returned', 'UPI', 'Jaipur', 'Rajasthan'),
(10, '2024-02-10', 'Delivered', 'Debit Card', 'Kolkata', 'West Bengal'),
(1, '2024-02-14', 'Delivered', 'Credit Card', 'Bengaluru', 'Karnataka'),
(3, '2024-02-18', 'Pending', 'UPI', 'Delhi', 'Delhi'),
(11, '2024-02-22', 'Delivered', 'Net Banking', 'Lucknow', 'Uttar Pradesh'),
(12, '2024-02-26', 'Shipped', 'Wallet', 'Guwahati', 'Assam'),
(5, '2024-03-02', 'Delivered', 'Credit Card', 'Hyderabad', 'Telangana');

-- Insert order details data
INSERT INTO order_details (
    order_id,
    product_id,
    quantity,
    unit_price,
    discount_percent
) VALUES
(1, 1, 1, 12999.00, 10.00),
(1, 4, 1, 1199.00, 0.00),
(2, 2, 1, 38999.00, 5.00),
(2, 12, 2, 699.00, 0.00),
(3, 8, 1, 5999.00, 15.00),
(3, 14, 1, 999.00, 0.00),
(4, 5, 1, 8999.00, 8.00),
(4, 6, 1, 4499.00, 12.00),
(5, 3, 1, 64999.00, 7.50),
(6, 13, 1, 2499.00, 5.00),
(6, 10, 3, 499.00, 0.00),
(7, 15, 1, 3999.00, 10.00),
(8, 7, 1, 3299.00, 6.00),
(8, 11, 1, 799.00, 0.00),
(9, 9, 1, 3499.00, 20.00),
(10, 14, 2, 999.00, 5.00),
(10, 12, 1, 699.00, 0.00),
(11, 2, 1, 38999.00, 4.00),
(11, 1, 1, 12999.00, 10.00),
(12, 6, 2, 4499.00, 8.00),
(13, 16, 1, 7999.00, 12.00),
(13, 18, 1, 2199.00, 5.00),
(14, 17, 2, 1499.00, 0.00),
(14, 10, 2, 499.00, 0.00),
(15, 3, 1, 64999.00, 6.00),
(15, 4, 2, 1199.00, 0.00);
