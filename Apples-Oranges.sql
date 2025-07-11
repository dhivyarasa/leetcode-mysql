/*

Table: Sales

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| sale_date     | date    |
| fruit         | enum    | 
| sold_num      | int     | 
+---------------+---------+
(sale_date,fruit) is the primary key for this table.
This table contains the sales of "apples" and "oranges" sold each day.
Write an SQL query to report the difference between number of apples and oranges sold each day.

Return the result table ordered by sale_date in format (‘YYYY-MM-DD’).

The query result format is in the following example:

Sales table:
+------------+------------+-------------+
| sale_date  | fruit      | sold_num    |
+------------+------------+-------------+
| 2020-05-01 | apples     | 10          |
| 2020-05-01 | oranges    | 8           |
| 2020-05-02 | apples     | 15          |
| 2020-05-02 | oranges    | 15          |
| 2020-05-03 | apples     | 20          |
| 2020-05-03 | oranges    | 0           |
| 2020-05-04 | apples     | 15          |
| 2020-05-04 | oranges    | 16          |
+------------+------------+-------------+

Result table:
+------------+--------------+
| sale_date  | diff         |
+------------+--------------+
| 2020-05-01 | 2            |
| 2020-05-02 | 0            |
| 2020-05-03 | 20           |
| 2020-05-04 | -1           |
+------------+--------------+

Day 2020-05-01, 10 apples and 8 oranges were sold (Difference  10 - 8 = 2).
Day 2020-05-02, 15 apples and 15 oranges were sold (Difference 15 - 15 = 0).
Day 2020-05-03, 20 apples and 0 oranges were sold (Difference 20 - 0 = 20).
Day 2020-05-04, 15 apples and 16 oranges were sold (Difference 15 - 16 = -1).

*/

-- Schema for Apple-Oranges:

-- Create the Sales table
CREATE TABLE Sales (
    sale_date DATE,
    fruit ENUM('apples', 'oranges'),
    sold_num INT,
    PRIMARY KEY (sale_date, fruit)
);


-- Insert sample data
INSERT INTO Sales (sale_date, fruit, sold_num) VALUES
('2020-05-01', 'apples', 10),
('2020-05-01', 'oranges', 8),
('2020-05-02', 'apples', 15),
('2020-05-02', 'oranges', 15),
('2020-05-03', 'apples', 20),
('2020-05-03', 'oranges', 0),
('2020-05-04', 'apples', 15),
('2020-05-04', 'oranges', 16);

-- Solution to Apples-Oranges:
-- Without cte
SELECT 
    sale_date,
    SUM(CASE
        WHEN fruit = 'apples' THEN sold_num
        ELSE 0
    END) - SUM(CASE
        WHEN fruit = 'oranges' THEN sold_num
        ELSE 0
    END) AS diff
FROM
    Sales
GROUP BY sale_date
ORDER BY sale_date;

-- using cte
WITH cte1 AS (
SELECT sale_date, fruit, sold_num
FROM Sales
),
cte2 AS (
SELECT sale_date, 
SUM(CASE WHEN fruit = 'apples' THEN sold_num ELSE 0 END) AS apples_sold,
SUM(CASE WHEN fruit = 'oranges' THEN sold_num ELSE 0 END) AS oranges_sold
FROM cte1
GROUP BY sale_date
)
SELECT sale_date, (apples_sold - oranges_sold) AS diff
FROM cte2
ORDER BY sale_date;

-- using joins
SELECT 
    a.sale_date, (a.sold_num - o.sold_num) AS diff
FROM
    (SELECT 
        sale_date, sold_num, fruit
    FROM
        Sales
    WHERE
        fruit = 'apples') a
        JOIN
    (SELECT 
        sale_date, sold_num, fruit
    FROM
        Sales
    WHERE
        fruit = 'oranges') o ON a.sale_date = o.sale_date
ORDER BY a.sale_date;
