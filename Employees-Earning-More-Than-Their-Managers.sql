/*

The Employee table holds all employees including their managers. 
Every employee has an Id, and there is also a column for the manager Id.

+----+-------+--------+-----------+
| Id | Name  | Salary | ManagerId |
+----+-------+--------+-----------+
| 1  | Joe   | 70000  | 3         |
| 2  | Henry | 80000  | 4         |
| 3  | Sam   | 60000  | NULL      |
| 4  | Max   | 90000  | NULL      |
+----+-------+--------+-----------+
Given the Employee table, write a SQL query that 
finds out employees who earn more than their managers. 
For the above table, Joe is the only employee who earns more than his manager.

+----------+
| Employee |
+----------+
| Joe      |
+----------+

*/ 

-- Schema for Employees Earning More Than Their Managers
-- Create the Employee table
CREATE TABLE Employee (
    Id INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Salary INT NOT NULL,
    ManagerId INT,
    FOREIGN KEY (ManagerId) REFERENCES Employee(Id)
);

-- Insert Sample Data
INSERT INTO Employee (Id, Name, Salary, ManagerId) VALUES
(1, 'Joe', 70000, 3),
(2, 'Henry', 80000, 4),
(3, 'Sam', 60000, NULL),
(4, 'Max', 90000, NULL);

-- Solution to Employees earning more than their managers
SELECT 
    e.Name AS Employee
FROM 
    Employee e
JOIN 
    Employee m ON e.ManagerId = m.Id
WHERE 
    e.Salary > m.Salary;
