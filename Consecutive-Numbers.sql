/*

Write a SQL query to find all numbers that appear at least three times consecutively.

+----+-----+
| Id | Num |
+----+-----+
| 1  |  1  |
| 2  |  1  |
| 3  |  1  |
| 4  |  2  |
| 5  |  1  |
| 6  |  2  |
| 7  |  2  |
+----+-----+
For example, given the above Logs table, 1 is the only number that appears 
consecutively for at least three times.

+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+

*/

-- Schema for Consecutive Numbers:

-- Create the Logs table
CREATE TABLE Logs (
    Id INT PRIMARY KEY,
    Num INT
);

-- Insert sample data into Logs table
INSERT INTO Logs (Id, Num) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 2),
(5, 1),
(6, 2),
(7, 2);

-- Solution to Consecutive Numbers
SELECT DISTINCT
    a.Num AS ConsecutiveNums
FROM
    Logs a
        JOIN
    Logs b ON a.Id = b.Id - 1
        JOIN
    Logs c ON b.Id = c.Id - 1
WHERE
    a.Num = b.Num AND b.Num = c.Num;

-- Another way
SELECT DISTINCT
    a.Num AS ConsecutiveNums
FROM
    Logs a
        INNER JOIN
    Logs b ON a.Id - 1 = b.Id AND a.Num = b.Num
        INNER JOIN
    Logs c ON a.Id + 1 = c.Id AND a.Num = c.Num;

-- Using cte
WITH Number_Groups AS (
  SELECT
    Num,
    Id,
    Id - ROW_NUMBER() OVER (PARTITION BY Num ORDER BY Id) AS grp
  FROM Logs
),
Grouped_Counts AS (
  SELECT
    Num,
    COUNT(*) AS cnt
  FROM Number_Groups
  GROUP BY Num, grp
  HAVING COUNT(*) >= 3
)
SELECT DISTINCT Num AS ConsecutiveNums
FROM Grouped_Counts;