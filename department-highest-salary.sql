/* 

# Time:  O(n^2)
# Space: O(n)
# 
# The Employees table holds all employees. 
Every employee has an Id, a salary, and there is also a column for the department Id.
# 
# +----+-------+--------+--------------+
# | Id | Name  | Salary | DepartmentId |
# +----+-------+--------+--------------+
# | 1  | Joe   | 70000  | 1            |
# | 2  | Henry | 80000  | 2            |
# | 3  | Sam   | 60000  | 2            |
# | 4  | Max   | 90000  | 1            |
# +----+-------+--------+--------------+
# The Department table holds all departments of the company.
# 
# +----+----------+
# | Id | Name     |
# +----+----------+
# | 1  | IT       |
# | 2  | Sales    |
# +----+----------+
# Write a SQL query to find employees who have the highest salary 
in each of the departments. For the above tables, Max has the highest salary
in the IT department and Henry has the highest salary in the Sales department.
# 
# +------------+----------+--------+
# | Department | Employee | Salary |
# +------------+----------+--------+
# | IT         | Max      | 90000  |
# | Sales      | Henry    | 80000  |
# +------------+----------+--------+
# 
*/

-- Schema for Department Highest Salary:

-- Create the Department table
CREATE TABLE Department (
    Id INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL
);

-- Create the Employees table
CREATE TABLE Employees (
    Id INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Salary INT NOT NULL,
    DepartmentId INT,
    FOREIGN KEY (DepartmentId) REFERENCES Department(Id)
);

-- Insert Sample Data
-- Insert into Department

INSERT INTO Department (Id, Name) VALUES
(1, 'IT'),
(2, 'Sales');

-- Insert into Employee

INSERT INTO Employees (Id, Name, Salary, DepartmentId) VALUES
(1, 'Joe', 70000, 1),
(2, 'Henry', 80000, 2),
(3, 'Sam', 60000, 2),
(4, 'Max', 90000, 1);

-- Using Joins
SELECT 
    d.Name AS Department,
    e.Name AS Employees,
    e.Salary
FROM 
    Employees e
JOIN 
    Department d ON e.DepartmentId = d.Id
WHERE 
    e.Salary = (
        SELECT MAX(Salary)
        FROM Employees
        WHERE DepartmentId = e.DepartmentId
    );
    
-- Using cte
WITH DepartmentMaxSalary AS (
    SELECT 
        DepartmentId,
        MAX(Salary) AS MaxSalary
    FROM 
        Employees
    GROUP BY 
        DepartmentId
)

SELECT 
    d.Name AS Department,
    e.Name AS Employees,
    e.Salary
FROM 
    Employees e
JOIN 
    Department d ON e.DepartmentId = d.Id
JOIN 
    DepartmentMaxSalary dm ON e.DepartmentId = dm.DepartmentId AND e.Salary = dm.MaxSalary;
    