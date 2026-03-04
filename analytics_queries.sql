CREATE TABLE categories (
  category_id SERIAL PRIMARY KEY,
  category_name VARCHAR (50)
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

INSERT INTO categories (category_name) VALUES ('Electronics'), ('Home & Kitchen'), ('Books');

INSERT INTO products (product_name, category_id, price) VALUES 
('Smartphone', 1, 800.00), ('Laptop', 1, 1200.00), 
('Coffee Maker', 2, 150.00), ('Air Fryer', 2, 200.00),
('SQL Guide', 3, 40.00), ('Data Science Handbook', 3, 60.00);

INSERT INTO customers (customer_name, registration_date) VALUES 
('Alice Smith', '2023-01-15'), ('Bob Johnson', '2023-03-10'), 
('Charlie Brown', '2023-05-20'), ('Diana Prince', '2023-08-01');

INSERT INTO orders (customer_id, product_id, order_date, quantity, total_amount) VALUES 
(1, 1, '2023-02-01', 1, 800.00), (1, 5, '2023-04-10', 2, 80.00), -- Alice (Loyal)
(2, 2, '2023-03-15', 1, 1200.00),                               -- Bob (One-timer)
(3, 3, '2023-06-01', 1, 150.00), (3, 4, '2023-07-20', 1, 200.00), -- Charlie (Returning)
(4, 6, '2023-08-10', 5, 300.00), (4, 1, '2023-09-05', 1, 800.00); -- Diana (High Spender)
