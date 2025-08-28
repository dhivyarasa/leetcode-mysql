/*

Consecutive Available Seats Problem

Description
LeetCode Problem 603.

Several friends at a cinema ticket office would like to reserve consecutive available seats.
Can you help to query all the consecutive available seats order by the seat_id using the following cinema table?

| seat_id | free |
|---------|------|
| 1       | 1    |
| 2       | 0    |
| 3       | 1    |
| 4       | 1    |
| 5       | 1    |
Your query should return the following result for the sample case above.

| seat_id |
|---------|
| 3       |
| 4       |
| 5       |
Note:

The seat_id is an auto increment int, and free is bool (‘1’ means free, and ‘0’ means occupied.).
Consecutive available seats are more than 2(inclusive) seats consecutively available.

*/

-- Schema for Consecutive Available Seats:

-- Create the Cinema table
CREATE TABLE Cinema (
    seat_id INT AUTO_INCREMENT PRIMARY KEY,
    free BOOLEAN
);

-- Insert sample data into Cinema table
INSERT INTO Cinema (free) VALUES
(1),  -- seat_id 1, free
(0),  -- seat_id 2, occupied
(1),  -- seat_id 3, free
(1),  -- seat_id 4, free
(1);  -- seat_id 5, free

-- Solution to Consecutive Available Seats
SELECT 
    c1.seat_id
FROM
    cinema c1,
    cinema c2
WHERE
    ((c1.seat_id = c2.seat_id + 1)
        OR (c1.seat_id = c2.seat_id - 1))
        AND (c1.free = 1)
        AND (c2.free = 1)
GROUP BY c1.seat_id;

-- Another code
SELECT DISTINCT seat_id
FROM cinema
WHERE seat_id IN (
    SELECT c1.seat_id
    FROM cinema c1
    JOIN cinema c2 ON c1.seat_id = c2.seat_id - 1
    JOIN cinema c3 ON c2.seat_id = c3.seat_id - 1
    WHERE c1.free = 1 AND c2.free = 1 AND c3.free = 1

    UNION

    SELECT c2.seat_id
    FROM cinema c1
    JOIN cinema c2 ON c1.seat_id = c2.seat_id - 1
    JOIN cinema c3 ON c2.seat_id = c3.seat_id - 1
    WHERE c1.free = 1 AND c2.free = 1 AND c3.free = 1

    UNION

    SELECT c3.seat_id
    FROM cinema c1
    JOIN cinema c2 ON c1.seat_id = c2.seat_id - 1
    JOIN cinema c3 ON c2.seat_id = c3.seat_id - 1
    WHERE c1.free = 1 AND c2.free = 1 AND c3.free = 1
)
ORDER BY seat_id;
