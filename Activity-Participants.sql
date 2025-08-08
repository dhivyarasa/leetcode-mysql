/*

Table: Friends

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
| activity      | varchar |
+---------------+---------+
id is the id of the friend and primary key for this table.
name is the name of the friend.
activity is the name of the activity which the friend takes part in.
Table: Activities

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
+---------------+---------+
id is the primary key for this table.
name is the name of the activity.
Write an SQL query to find the names of all the activities with neither maximum, 
nor minimum number of participants.

Return the result table in any order. Each activity in table Activities is performed
by any person in the table Friends.

The query result format is in the following example:

Friends table:

+------+--------------+---------------+
| id   | name         | activity      |
+------+--------------+---------------+
| 1    | Jonathan D.  | Eating        |
| 2    | Jade W.      | Singing       |
| 3    | Victor J.    | Singing       |
| 4    | Elvis Q.     | Eating        |
| 5    | Daniel A.    | Eating        |
| 6    | Bob B.       | Horse Riding  |
+------+--------------+---------------+

Activities table:
+------+--------------+
| id   | name         |
+------+--------------+
| 1    | Eating       |
| 2    | Singing      |
| 3    | Horse Riding |
+------+--------------+

Result table:
+--------------+
| results      |
+--------------+
| Singing      |
+--------------+

Eating activity is performed by 3 friends, maximum number of participants,
 (Jonathan D. , Elvis Q. and Daniel A.)
Horse Riding activity is performed by 1 friend, minimum number of participants, (Bob B.)
Singing is performed by 2 friends (Victor J. and Jade W.)

*/

-- Schema for Activity Participants:

-- Create the Friends table
CREATE TABLE Friends (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    activity VARCHAR(100)
);

-- Create the Activities table
CREATE TABLE Activities (
    id INT PRIMARY KEY,
    name VARCHAR(100)
);


-- Insert data into Friends table
INSERT INTO Friends (id, name, activity) VALUES
(1, 'Jonathan D.', 'Eating'),
(2, 'Jade W.', 'Singing'),
(3, 'Victor J.', 'Singing'),
(4, 'Elvis Q.', 'Eating'),
(5, 'Daniel A.', 'Eating'),
(6, 'Bob B.', 'Horse Riding');

-- Insert data into Activities table
INSERT INTO Activities (id, name) VALUES
(1, 'Eating'),
(2, 'Singing'),
(3, 'Horse Riding');

-- Solution to Activity Participants
-- Using Subquery
SELECT 
    activity AS results
FROM
    Friends
GROUP BY activity
HAVING COUNT(*) NOT IN (SELECT 
        MAX(cnt)
    FROM
        (SELECT 
            COUNT(*) AS cnt
        FROM
            Friends
        GROUP BY activity) AS subquery UNION SELECT 
        MIN(cnt)
    FROM
        (SELECT 
            COUNT(*) AS cnt
        FROM
            Friends
        GROUP BY activity) AS subquery);

-- Using Window function and cte
WITH activity_counts AS (
    SELECT 
        activity,
        COUNT(*) AS participant_count
    FROM Friends
    GROUP BY activity
),
with_extremes AS (
    SELECT 
        activity,
        participant_count,
        MAX(participant_count) OVER () AS max_count,
        MIN(participant_count) OVER () AS min_count
    FROM activity_counts
)
SELECT activity AS results
FROM with_extremes
WHERE participant_count NOT IN (max_count, min_count);
