CREATE DATABASE Project_1;
USE Project_1;
DROP TABLE sales;
CREATE TABLE sales(
	sales_date TEXT(255),
    store INT(255),
    item INT(255),
    sales INT(255)
);

SELECT * FROM sales;

-- import data into the table then start the analysis

    
SELECT * FROM merge_with_sales_data;
SELECT COUNT(*) FROM merge_2_data;
-- merge all 3 tables into one table
 
 

SHOW COLUMNS FROM merge_2_data;
SHOW COLUMNS FROM merge_with_sales_data;
SHOW COLUMNS FROM sales_data;
SHOW COLUMNS FROM sales;

INSERT INTO sales
SELECT sales_date, store, item, sales
FROM ((SELECT sales_date, store, item, sales FROM sales_data) 
UNION ALL
(SELECT sales_date, store, item, sales FROM merge_2_data)
UNION ALL
(SELECT sales_date, store, item, sales FROM merge_with_sales_data)) AS data_1;

SELECT COUNT(*) FROM sales;
SELECT * FROM sales;

SELECT STR_TO_DATE(sales_date, '%d/%m/%Y') AS sales_3 FROM sales;
-- exported into Excel CSV then upload, merge with sales data

ALTER TABLE sales
ADD COLUMN new_dates DATE;

SET SQL_SAFE_UPDATES = 0;
UPDATE sales
SET new_dates = STR_TO_DATE(sales_date, '%d/%m/%Y');

SELECT * FROM sales;

ALTER TABLE sales
DROP COLUMN sales_date;
-- data is now ready for analysis

SELECT item, SUM(sales) AS total_quantity
FROM sales
GROUP BY item
ORDER BY total_quantity DESC
LIMIT 10;
-- top 10 products

SELECT YEAR(new_dates) AS year, MONTH(new_dates) AS month, COUNT(DISTINCT item) AS unique_product_sold
FROM sales
GROUP BY YEAR(new_dates), MONTH (new_dates);
-- number of unique products sold per month and year

SELECT COUNT(DISTINCT item) FROM sales; -- 50 unique products

SELECT
	item,
    SUM(CASE WHEN YEAR(new_dates) = 2013 THEN sales ELSE 0 END) AS total_quantity_2021,
    SUM(CASE WHEN YEAR(new_dates) = 2014 THEN sales ELSE 0 END) AS total_quantity_2022,
    SUM(CASE WHEN YEAR(new_dates) = 2015 THEN sales ELSE 0 END) AS total_quantity_2022,    
    SUM(CASE WHEN YEAR(new_dates) = 2016 THEN sales ELSE 0 END) AS total_quantity_2022,
    SUM(CASE WHEN YEAR(new_dates) = 2017 THEN sales ELSE 0 END) AS total_quantity_2022
FROM sales
GROUP BY item;
-- total products sold by quantity per year


-- move to Power BI part




