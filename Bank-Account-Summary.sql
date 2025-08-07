/*

1555. Bank Account Summary
Table: Users
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| user_id      | int     |
| user_name    | varchar |
| credit       | int     |
+--------------+---------+
user_id is the primary key for this table.
Each row of this table contains the current credit information for each user.
Table: Transactions
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| trans_id      | int     |
| paid_by       | int     |
| paid_to       | int     |
| amount        | int     |
| transacted_on | date    |
+---------------+---------+
trans_id is the primary key for this table.
Each row of this table contains the information about the transaction in the bank.
User with id (paid_by) transfer money to user with id (paid_to).
Leetcode Bank (LCB) helps its coders in making virtual payments. Our bank records all transactions in the table Transaction, we want to find out the current balance of all users and check wheter they have breached their credit limit (If their current credit is less than 0).
Write an SQL query to report.
user_id
user_name
credit, current balance after performing transactions.
credit_limit_breached, check credit_limit ("Yes" or "No")
Return the result table in any order.
The query result format is in the following example.
Users table:
+------------+--------------+-------------+
| user_id    | user_name    | credit      |
+------------+--------------+-------------+
| 1          | Moustafa     | 100         |
| 2          | Jonathan     | 200         |
| 3          | Winston      | 10000       |
| 4          | Luis         | 800         | 
+------------+--------------+-------------+
Transactions table:
+------------+------------+------------+----------+---------------+
| trans_id   | paid_by    | paid_to    | amount   | transacted_on |
+------------+------------+------------+----------+---------------+
| 1          | 1          | 3          | 400      | 2020-08-01    |
| 2          | 3          | 2          | 500      | 2020-08-02    |
| 3          | 2          | 1          | 200      | 2020-08-03    |
+------------+------------+------------+----------+---------------+
Result table:
+------------+------------+------------+-----------------------+
| user_id    | user_name  | credit     | credit_limit_breached |
+------------+------------+------------+-----------------------+
| 1          | Moustafa   | -100       | Yes                   | 
| 2          | Jonathan   | 500        | No                    |
| 3          | Winston    | 9900       | No                    |
| 4          | Luis       | 800        | No                    |
+------------+------------+------------+-----------------------+
Moustafa paid $400 on "2020-08-01" and received $200 on "2020-08-03", credit (100 -400 +200) = -$100
Jonathan received $500 on "2020-08-02" and paid $200 on "2020-08-08", credit (200 +500 -200) = $500
Winston received $400 on "2020-08-01" and paid $500 on "2020-08-03", credit (10000 +400 -500) = $9990
Luis didn't received any transfer, credit = $800

*/

-- Schema for Bank Account Summary:

-- Create Users table
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(100),
    credit INT
);

-- Create Transactions table
CREATE TABLE Transactions (
    trans_id INT PRIMARY KEY,
    paid_by INT,
    paid_to INT,
    amount INT,
    transacted_on DATE,
    FOREIGN KEY (paid_by) REFERENCES Users(user_id),
    FOREIGN KEY (paid_to) REFERENCES Users(user_id)
);

-- Insert data into Users table
INSERT INTO Users (user_id, user_name, credit) VALUES
(1, 'Moustafa', 100),
(2, 'Jonathan', 200),
(3, 'Winston', 10000),
(4, 'Luis', 800);

-- Insert data into Transactions table
INSERT INTO Transactions (trans_id, paid_by, paid_to, amount, transacted_on) VALUES
(1, 1, 3, 400, '2020-08-01'),
(2, 3, 2, 500, '2020-08-02'),
(3, 2, 1, 200, '2020-08-03');

-- Solution to Bank Account Summary
-- Using Joins
SELECT
    t.user_id,
    user_name,
    SUM(t.credit) AS credit,
    IF(SUM(t.credit) < 0, 'Yes', 'No') AS credit_limit_breached
FROM
    (
        SELECT paid_by AS user_id, -amount AS credit FROM Transactions
        UNION ALL
        SELECT paid_to AS user_id, amount AS credit FROM Transactions
        UNION ALL
        SELECT user_id, credit FROM Users
    ) AS t
    JOIN Users AS u ON t.user_id = u.user_id
GROUP BY t.user_id;

-- Using cte
WITH Paid AS (
    SELECT paid_by AS user_id, SUM(amount) AS total_paid
    FROM Transactions
    GROUP BY paid_by
),
Received AS (
    SELECT paid_to AS user_id, SUM(amount) AS total_received
    FROM Transactions
    GROUP BY paid_to
),
Balance AS (
    SELECT 
        u.user_id,
        u.user_name,
        u.credit - IFNULL(p.total_paid, 0) + IFNULL(r.total_received, 0) AS credit
    FROM Users u
    LEFT JOIN Paid p ON u.user_id = p.user_id
    LEFT JOIN Received r ON u.user_id = r.user_id
)
SELECT 
    user_id,
    user_name,
    credit,
    CASE 
        WHEN credit < 0 THEN 'Yes'
        ELSE 'No'
    END AS credit_limit_breached
FROM Balance;

-- Another way
SELECT 
    u.user_id,
    u.user_name,
    u.credit 
        - IFNULL(paid.total_paid, 0) 
        + IFNULL(received.total_received, 0) AS credit,
    CASE 
        WHEN u.credit - IFNULL(paid.total_paid, 0) + IFNULL(received.total_received, 0) < 0 
        THEN 'Yes' 
        ELSE 'No' 
    END AS credit_limit_breached
FROM Users u
LEFT JOIN (
    SELECT paid_by, SUM(amount) AS total_paid
    FROM Transactions
    GROUP BY paid_by
) paid ON u.user_id = paid.paid_by
LEFT JOIN (
    SELECT paid_to, SUM(amount) AS total_received
    FROM Transactions
    GROUP BY paid_to
) received ON u.user_id = received.paid_to;