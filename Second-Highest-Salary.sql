/*

Write a SQL query to get the second highest salary from the Employee table.

+----+--------+
| Id | Salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
For example, given the above Employee table, the query should return 200 as 
the second highest salary. If there is no second highest salary, 
then the query should return null.

+---------------------+
| SecondHighestSalary |
+---------------------+
| 200                 |
+---------------------+

*/

-- Schema for Second Highest Salary:

-- Create the Employee table
CREATE TABLE Employee (
    Id INT PRIMARY KEY,
    Salary INT
);


-- Insert sample data
INSERT INTO Employee (Id, Salary) VALUES
(1, 100),
(2, 200),
(3, 300);

-- Solution to Second Highest Salary:
SELECT 
    MAX(Salary) AS Second_Highest_Salary
FROM
    Employee
WHERE
    Salary < (SELECT 
            MAX(Salary)
        FROM
            Employee);

-- Using Limit
SELECT DISTINCT
    Salary AS Second_Highest_Salary
FROM
    Employee
ORDER BY Salary DESC
LIMIT 1 OFFSET 1;

-- Another Solution
SELECT 
    MAX(Salary) AS Second_Highest_Salary
FROM
    Employee
WHERE
    Salary NOT IN (SELECT 
            MAX(Salary)
        FROM
            Employee);

-- Another Solution
SELECT 
    (SELECT 
            Salary
        FROM
            Employee
        GROUP BY Salary
        ORDER BY Salary DESC
        LIMIT 1 , 1) Second_Highest_Salary;