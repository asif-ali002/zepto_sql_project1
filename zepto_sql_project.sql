drop table if exists zepto;

-- Create the zepto table
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

SELECT COUNT(*) FROM zepto;

SELECT * FROM zepto LIMIT 10;

-- Check for null values across all columns:

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

-- Identify distinct product categories:

SELECT DISTINCT category FROM zepto;

-- Compare in-stock vs out-of-stock product counts:

SELECT
  outOfStock,
  COUNT(*) AS product_count
FROM zepto
GROUP BY outOfStock;


-- Detect duplicate product entries:

SELECT name, COUNT(*) AS count
FROM zepto
GROUP BY name
HAVING COUNT(*) > 1;


-- Data Cleaning

--Remove rows where MRP or discounted selling price is zero:

DELETE FROM zepto
WHERE mrp = 0 OR discountedSellingPrice = 0;



-- Convert MRP and discounted selling price from paise to rupees:

UPDATE zepto
SET
  mrp = mrp / 100,
  discountedSellingPrice = discountedSellingPrice / 100;


 --  Ensure no NULLs in primary analytical columns:

UPDATE zepto
SET
  mrp = 0,
  discountedSellingPrice = 0
WHERE mrp IS NULL OR discountedSellingPrice IS NULL;



-- Business Insights Using SQL Queries

-- Top 10 best-value products by discount percentage:

SELECT name, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;


-- High-MRP products that are out of stock:

SELECT name, mrp
FROM zepto
WHERE mrp > 500 AND outOfStock = true;


-- Estimated total revenue by product category:

SELECT category, SUM(discountedSellingPrice * availableQuantity) AS estimated_revenue
FROM zepto
GROUP BY category;


-- Expensive products (MRP > ₹500) with low discount (<10%):

SELECT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10;


-- Top 5 categories by average discount percentage:

SELECT category, AVG(discountPercent) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;


-- Price per gram to identify most cost-effective products:

SELECT name, discountedSellingPrice / weightInGms AS price_per_gram
FROM zepto
ORDER BY price_per_gram;


-- Group items by weight range (Low <1kg, Medium <5kg, Bulk ≥5kg):

SELECT
  name,
  CASE
    WHEN weightInGms < 1000 THEN 'Low'
    WHEN weightInGms < 5000 THEN 'Medium'
    ELSE 'Bulk'
  END AS weight_category
FROM zepto;


-- Total inventory weight per product category:

SELECT category, SUM(weightInGms * availableQuantity) AS total_inventory_weight
FROM zepto
GROUP BY category;


