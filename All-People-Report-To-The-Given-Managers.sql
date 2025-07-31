/*

Table: Employees

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| employee_id   | int     |
| employee_name | varchar |
| manager_id    | int     |
+---------------+---------+
employee_id is the primary key for this table.
Each row of this table indicates that the employee with ID employee_id 
and name employee_name reports his work to his/her direct manager with manager_id
The head of the company is the employee with employee_id = 1.
Write an SQL query to find employee_id of all employees that directly or 
indirectly report their work to the head of the company.

The indirect relation between managers will not exceed 3 managers as the company is small.

Return result table in any order without duplicates.

The query result format is in the following example:

Employees table:
+-------------+---------------+------------+
| employee_id | employee_name | manager_id |
+-------------+---------------+------------+
| 1           | Boss          | 1          |
| 3           | Alice         | 3          |
| 2           | Bob           | 1          |
| 4           | Daniel        | 2          |
| 7           | Luis          | 4          |
| 8           | Jhon          | 3          |
| 9           | Angela        | 8          |
| 77          | Robert        | 1          |
+-------------+---------------+------------+

Result table:
+-------------+
| employee_id |
+-------------+
| 2           |
| 77          |
| 4           |
| 7           |
+-------------+

The head of the company is the employee with employee_id 1.
The employees with employee_id 2 and 77 report their work directly 
to the head of the company.
The employee with employee_id 4 report his work indirectly
to the head of the company 4 --> 2 --> 1. 
The employee with employee_id 7 report his work indirectly 
to the head of the company 7 --> 4 --> 2 --> 1.
The employees with employee_id 3, 8 and 9 don't report their work to head

*/

-- Schema for All People Report To The Given Managers:

-- Create the Employees table
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    manager_id INT
);

-- Insert Sample Data
INSERT INTO Employees (employee_id, employee_name, manager_id) VALUES
(1, 'Boss', 1),
(3, 'Alice', 3),
(2, 'Bob', 1),
(4, 'Daniel', 2),
(7, 'Luis', 4),
(8, 'Jhon', 3),
(9, 'Angela', 8),
(77, 'Robert', 1);

-- Solution to All People Report To The Given Managers
-- Using cte
WITH RECURSIVE ReportChain AS (
    SELECT employee_id, manager_id
    FROM Employees
    WHERE manager_id = 1 AND employee_id != 1

    UNION ALL

    SELECT e.employee_id, e.manager_id
    FROM Employees e
    INNER JOIN ReportChain rc ON e.manager_id = rc.employee_id
)
SELECT DISTINCT employee_id
FROM ReportChain;

-- Using Joins
SELECT DISTINCT e.employee_id
FROM Employees e
LEFT JOIN Employees m1 ON e.manager_id = m1.employee_id
LEFT JOIN Employees m2 ON m1.manager_id = m2.employee_id
LEFT JOIN Employees m3 ON m2.manager_id = m3.employee_id
WHERE 1 IN (
    e.manager_id,
    m1.manager_id,
    m2.manager_id
)
AND e.employee_id != 1;
