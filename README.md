🛒 Zepto SQL Data Analysis Project
📖 Overview

This project analyzes Zepto product data using PostgreSQL.
It focuses on:

Cleaning and preparing raw product data

Exploring product categories, discounts, and stock levels

Generating insights such as best-value items, revenue by category, and pricing efficiency

The dataset includes details like product name, MRP, discount percentage, availability, and weight.

🧱 Table Schema
CREATE TABLE zepto (
  sku_id SERIAL PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  category VARCHAR(120),
  mrp NUMERIC(8,2),
  discountPercent NUMERIC(5,2),
  discountedSellingPrice NUMERIC(8,2),
  availableQuantity INTEGER,
  weightInGms INTEGER,
  outOfStock BOOLEAN,
  quantity INTEGER
);

⚙️ Setup Instructions

Drop and recreate the table (if already exists):

DROP TABLE IF EXISTS zepto;
CREATE TABLE zepto (...);


Import your dataset:

\copy zepto FROM 'C:\path\to\zepto.csv' DELIMITER ',' CSV HEADER;


Verify data import:

SELECT COUNT(*) FROM zepto;
SELECT * FROM zepto LIMIT 10;

🧹 Data Cleaning Steps
1. Check for null values:
SELECT
  COUNT(*) FILTER (WHERE name IS NULL) AS name_nulls,
  COUNT(*) FILTER (WHERE category IS NULL) AS category_nulls,
  COUNT(*) FILTER (WHERE mrp IS NULL) AS mrp_nulls,
  COUNT(*) FILTER (WHERE discountPercent IS NULL) AS discountPercent_nulls,
  COUNT(*) FILTER (WHERE discountedSellingPrice IS NULL) AS discountedSellingPrice_nulls,
  COUNT(*) FILTER (WHERE availableQuantity IS NULL) AS availableQuantity_nulls,
  COUNT(*) FILTER (WHERE weightInGms IS NULL) AS weightInGms_nulls,
  COUNT(*) FILTER (WHERE outOfStock IS NULL) AS outOfStock_nulls,
  COUNT(*) FILTER (WHERE quantity IS NULL) AS quantity_nulls
FROM zepto;

2. Remove invalid rows:
DELETE FROM zepto
WHERE mrp = 0 OR discountedSellingPrice = 0;

3. Convert prices from paise to rupees:
UPDATE zepto
SET
  mrp = mrp / 100,
  discountedSellingPrice = discountedSellingPrice / 100;

4. Replace NULLs with default values:
UPDATE zepto
SET
  mrp = 0,
  discountedSellingPrice = 0
WHERE mrp IS NULL OR discountedSellingPrice IS NULL;

📊 Data Exploration Queries
🔹 Product Categories
SELECT DISTINCT category FROM zepto;

🔹 Stock Status
SELECT outOfStock, COUNT(*) AS product_count
FROM zepto
GROUP BY outOfStock;

🔹 Duplicates
SELECT name, COUNT(*) AS count
FROM zepto
GROUP BY name
HAVING COUNT(*) > 1;

💡 Business Insights
1️⃣ Top 10 Best-Value Products
SELECT name, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

2️⃣ High-MRP Products That Are Out of Stock
SELECT name, mrp
FROM zepto
WHERE mrp > 500 AND outOfStock = true;

3️⃣ Estimated Total Revenue by Category
SELECT category, SUM(discountedSellingPrice * availableQuantity) AS estimated_revenue
FROM zepto
GROUP BY category;

4️⃣ Expensive, Low-Discount Products
SELECT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10;

5️⃣ Top 5 Categories by Average Discount
SELECT category, AVG(discountPercent) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

6️⃣ Cost-Effectiveness (Price per Gram)
SELECT name, discountedSellingPrice / weightInGms AS price_per_gram
FROM zepto
ORDER BY price_per_gram;

7️⃣ Product Weight Categories
SELECT
  name,
  CASE
    WHEN weightInGms < 1000 THEN 'Low'
    WHEN weightInGms < 5000 THEN 'Medium'
    ELSE 'Bulk'
  END AS weight_category
FROM zepto;

8️⃣ Total Inventory Weight per Category
SELECT category, SUM(weightInGms * availableQuantity) AS total_inventory_weight
FROM zepto
GROUP BY category;

🧩 Insights Summary
Insight	Description
Discount Analysis	Find best-value deals and average discount by category.
Revenue Estimation	Estimate total potential revenue per category.
Stock Status	Identify out-of-stock high-value products.
Price Efficiency	Analyze price-per-gram to find cost-effective items.
Weight Distribution	Classify inventory into light, medium, and bulk.
