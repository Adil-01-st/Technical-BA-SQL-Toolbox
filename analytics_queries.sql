/* 
PROJECT: Technical-BA-SQL-Toolbox
STRATEGY: Revenue Growth & Customer Retention Analytics
AUTHOR: Adilbek Khiiasov
*/

-- PART 1: Database Schema & Performance Optimization

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

-- PERFORMANCE OPTIMIZATION (Indexing Strategy)
-- I would place indexes on the following columns for high-scale performance:
-- CREATE INDEX idx_orders_customer_id ON orders(customer_id); Speeds up customer history lookups
-- CREATE INDEX idx_orders_date ON orders(order_date); Optimizes time-series and seasonal reporting
-- CREATE INDEX idx_products_category ON products(category_id); Accelerates category-level breakdown

-- PART 2: Seed Data (Including Anomalies for Testing)

INSERT INTO categories (category_name) VALUES ('Electronics'), ('Home & Kitchen'), ('Books');
INSERT INTO products (product_name, category_id, price) VALUES ('Smartphone', 1, 800), ('Laptop', 1, 1200), ('Coffee Maker', 2, 150), ('SQL Guide', 3, 40);
INSERT INTO customers (customer_name, registration_date) VALUES ('Alice', '2023-01-15'), ('Bob', '2023-03-10'), ('Charlie', '2023-05-20');

-- Added valid transactions + 1 anomaly (negative amount) for filtering demonstration
INSERT INTO orders (customer_id, product_id, order_date, quantity, total_amount) VALUES  
(1, 1, '2023-02-01', 1, 800.00),
(2, 2, '2023-03-15', 1, 1200.00),
(3, 3, '2023-06-01', 1, 150.00),
(1, 4, '2023-07-20', 1, -50.00);

-- PART 3: High-Impact Business Queries

-- QUERY 1: Data Integrity & Anomaly Detection
-- Insight: Identifying and filtering out corrupted data (non-positive amounts) 
-- to ensure revenue reports represent actual cleared transactions.
SELECT *
FROM orders
WHERE total_amount <= 0 OR quantity IS NULL;

-- QUERY 2: Product Performance ("Cash Cows")
-- Insight: Ranking products within categories to identify inventory priorities 
-- and high-margin "hero" products.
SELECT 
    cat.category_name,
    p.product_name,
    SUM(o.total_amount) as revenue,
    RANK() OVER (PARTITION BY cat.category_name ORDER BY SUM(o.total_amount) DESC) as sales_rank
FROM products p
JOIN categories cat ON p.category_id = cat.category_id
JOIN orders o ON p.product_id = o.product_id
WHERE o.total_amount > 0 -- Filtering anomalies
GROUP BY 1, 2;

-- QUERY 3: Revenue Momentum & Seasonality
-- Insight: Calculating running totals to detect MoM (Month-over-Month) 
-- growth velocity and identify potential seasonal churn periods.
SELECT 
    order_date,
    SUM(total_amount) OVER (ORDER BY order_date) as cumulative_revenue
FROM orders
WHERE total_amount > 0;

-- QUERY 4: VIP Segment Identification
-- Insight: Isolating top 10% spenders to design exclusive loyalty campaigns 
-- and minimize High-Value Customer (HVC) churn.
WITH CustomerValue AS (
    SELECT customer_id, SUM(total_amount) as ltv
    FROM orders WHERE total_amount > 0
    GROUP BY 1
)
SELECT 
    cv.customer_id,
    cv.ltv,
    PERCENT_RANK() OVER (ORDER BY cv.ltv DESC) as spender_tier
FROM CustomerValue cv;
