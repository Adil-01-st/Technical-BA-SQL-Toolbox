/* 
PROJECT: Technical-BA-SQL-Toolbox
AUTHOR: Adilbek Khiiasov
DESCRIPTION: E-commerce Data Analytics (Sales, Customers, Products)
             This script sets up a database and executes 
             advanced analytical queries.
*/

-- PART 1: Database Schema & Seed Data (Setup)


CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(50)
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    category_id INT REFERENCES categories(category_id),
    price DECIMAL(10, 2)
);

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100),
    registration_date DATE
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    product_id INT REFERENCES products(product_id),
    order_date DATE,
    quantity INT,
    total_amount DECIMAL(10, 2)
);

-- Seeding Categories
INSERT INTO categories (category_name) VALUES ('Electronics'), ('Home & Kitchen'), ('Books');

-- Seeding Products
INSERT INTO products (product_name, category_id, price) VALUES  
('Smartphone', 1, 800.00), ('Laptop', 1, 1200.00),  
('Coffee Maker', 2, 150.00), ('Air Fryer', 2, 200.00),
('SQL Guide', 3, 40.00), ('Data Science Handbook', 3, 60.00);

-- Seeding Customers
INSERT INTO customers (customer_name, registration_date) VALUES  
('Alice Smith', '2023-01-15'), ('Bob Johnson', '2023-03-10'),  
('Charlie Brown', '2023-05-20'), ('Diana Prince', '2023-08-01');

-- Seeding Orders (Transactions)
INSERT INTO orders (customer_id, product_id, order_date, quantity, total_amount) VALUES  
(1, 1, '2023-02-01', 1, 800.00), (1, 5, '2023-04-10', 2, 80.00),
(2, 2, '2023-03-15', 1, 1200.00),                                
(3, 3, '2023-06-01', 1, 150.00), (3, 4, '2023-07-20', 1, 200.00),
(4, 6, '2023-08-10', 5, 300.00), (4, 1, '2023-09-05', 1, 800.00);


-- PART 2: Advanced Analytical Queries


-- QUERY 1: Detailed Sales Report (JOINs)
-- Goal: Human-readable view of who bought what and in which category.
SELECT 
    c.customer_name,
    o.order_date,
    p.product_name,
    cat.category_name,
    o.total_amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id
JOIN categories cat ON p.category_id = cat.category_id
ORDER BY o.order_date;

-- QUERY 2: Product Popularity Ranking (Window Function: RANK)
-- Goal: Identify the top-performing product in each category by revenue.
SELECT 
    cat.category_name,
    p.product_name,
    SUM(o.total_amount) as total_revenue,
    RANK() OVER (PARTITION BY cat.category_name ORDER BY SUM(o.total_amount) DESC) as sales_rank
FROM products p
JOIN categories cat ON p.category_id = cat.category_id
JOIN orders o ON p.product_id = o.product_id
GROUP BY cat.category_name, p.product_name;

-- QUERY 3: Running Total Revenue Analysis (Window Function: SUM OVER)
-- Goal: Track financial growth day-by-day.
SELECT 
    order_date,
    total_amount,
    SUM(total_amount) OVER (ORDER BY order_date) as running_total_revenue
FROM orders;

-- QUERY 4: Identifying High-Value Customers (CTE + Aggregation)
-- Goal: Find customers who spent more than the average order value.
WITH AvgOrderValue AS (
    SELECT AVG(total_amount) as global_avg FROM orders
)
SELECT 
    c.customer_name,
    SUM(o.total_amount) as total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING SUM(o.total_amount) > (SELECT global_avg FROM AvgOrderValue);

-- QUERY 5: Customer Retention - Days Between Orders (LAG Function)
-- Goal: Analyze customer behavior by measuring the gap between purchases.
SELECT 
    customer_id,
    order_date,
    LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) as previous_order,
    order_date - LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) as days_diff
FROM orders;
