/*
# 
# The Employee table holds all employees. Every employee has an Id, 
# and there is also a column for the department Id.
# 
# +----+-------+--------+--------------+
# | Id | Name  | Salary | DepartmentId |
# +----+-------+--------+--------------+
# | 1  | Joe   | 70000  | 1            |
# | 2  | Henry | 80000  | 2            |
# | 3  | Sam   | 60000  | 2            |
# | 4  | Max   | 90000  | 1            |
# | 5  | Janet | 69000  | 1            |
# | 6  | Randy | 85000  | 1            |
# +----+-------+--------+--------------+
# The Department table holds all departments of the company.
# 
# +----+----------+
# | Id | Name     |
# +----+----------+
# | 1  | IT       |
# | 2  | Sales    |
# +----+----------+
# Write a SQL query to find employees who earn the top three salaries 
# in each of the department. For the above tables, 
# your SQL query should return the following rows.
# 
# +------------+----------+--------+
# | Department | Employee | Salary |
# +------------+----------+--------+
# | IT         | Max      | 90000  |
# | IT         | Randy    | 85000  |
# | IT         | Joe      | 70000  |
# | Sales      | Henry    | 80000  |
# | Sales      | Sam      | 60000  |
# +------------+----------+--------+

*/

-- Schema for Department Top Three Salaries:

-- Create Department table
CREATE TABLE Department (
    Id INT PRIMARY KEY,
    Name VARCHAR(50)
);

-- Create Employee table
CREATE TABLE Employee (
    Id INT PRIMARY KEY,
    Name VARCHAR(50),
    Salary INT,
    DepartmentId INT,
    FOREIGN KEY (DepartmentId) REFERENCES Department(Id)
);

-- Insert data into Department table
INSERT INTO Department (Id, Name) VALUES
(1, 'IT'),
(2, 'Sales');

-- Insert data into Employee table
INSERT INTO Employee (Id, Name, Salary, DepartmentId) VALUES
(1, 'Joe', 70000, 1),
(2, 'Henry', 80000, 2),
(3, 'Sam', 60000, 2),
(4, 'Max', 90000, 1),
(5, 'Janet', 69000, 1),
(6, 'Randy', 85000, 1);

-- Solution to Department Top Three Salaries
-- Using Dense Rank
SELECT 
    d.Name AS Department,
    e.Name AS Employee,
    e.Salary
FROM (
    SELECT *,
           DENSE_RANK() OVER (PARTITION BY DepartmentId 
           ORDER BY Salary DESC) AS salary_rank
    FROM Employee
) e
JOIN Department d ON e.DepartmentId = d.Id
WHERE e.salary_rank <= 3;

-- Using Joins
SELECT 
    D.Name AS Department, E.Name AS Employee, E.Salary AS Salary
FROM
    Employee E
        INNER JOIN
    Department D ON E.DepartmentId = D.Id
WHERE
    (SELECT 
            COUNT(DISTINCT (Salary))
        FROM
            Employee
        WHERE
            DepartmentId = E.DepartmentId
                AND Salary > E.Salary) < 3
ORDER BY E.DepartmentId , E.Salary DESC;
