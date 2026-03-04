
# Technical-BA-SQL-Toolbox 📊
**Converting Raw Data into Strategic Business Decisions**

## 🎯 Project Overview
This repository isn't just a collection of scripts; it's a simulated analytical engine for an E-commerce business. As a Technical BA, I've designed this to solve real-world problems: data integrity, revenue scaling, and customer segmentation.

## 🏗️ Data Architecture (ER Diagram)
The database follows a normalized relational structure:
- **Customers (1:N) Orders**: Tracks individual lifecycle and lifetime value (LTV).
- **Categories (1:N) Products**: Groups inventory for market-basket analysis.
- **Products (1:N) Orders**: Logs transaction-level performance.



## 💡 Key Business Questions Answered
| Business Goal | SQL Technique | Business Insight |
| :--- | :--- | :--- |
| **Identify Cash Cows** | `RANK()` Window Function | Pinpointing products that drive 80% of category revenue. |
| **Spot Golden Hours** | `SUM() OVER` (Running Total) | Monitoring real-time revenue velocity to detect seasonal dips. |
| **VIP Retention** | `CTEs` & `PERCENT_RANK` | Segmenting the top 10% of customers for targeted loyalty offers. |
| **Data Cleaning** | Filtering & Anomaly Logic | Excluding negative transactions/refunds for accurate financial reporting. |

## 🚀 Performance & Scalability
In a production environment with millions of rows, I would implement **B-Tree Indexing** on:
- `orders(order_date)`: To accelerate time-series reporting.
- `orders(customer_id)`: To optimize customer profile aggregation.

## 🛠️ How to Use
1. Clone this repository.
2. Run `analytics_queries.sql` in any PostgreSQL environment.
3. Review Part 3 for insights ready for a Stakeholder Presentation.
