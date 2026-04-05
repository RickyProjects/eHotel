--query 1: hotel chain rating based on hotel averages (aggregation)
SELECT chain_id, AVG(rating) AS average_rating
FROM hotel
GROUP BY chain_id;

--query 2: available rooms (nested queries)
SELECT *
FROM room r
WHERE r.is_damaged = FALSE

AND NOT EXISTS (
    SELECT * 
    FROM booking b
    WHERE b.hotel_id = r.hotel_id
        AND b.room_number = r.room_number
        AND b.status IN ('pending', 'confirmed')
        AND b.start_date < CURRENT_DATE
        AND CURRENT_DATE < b.end_date
)

AND NOT EXISTS (
    SELECT *
    FROM renting rt
    WHERE rt.hotel_id = r.hotel_id
        AND rt.room_number = r.room_number
        AND rt.status IN ('pending', 'confirmed')
        AND rt.start_date < CURRENT_DATE
        AND CURRENT_DATE < rt.end_date
);

--query 3: find damaged rooms 
SELECT r.room_number
FROM room r
WHERE r.is_damaged = TRUE;

--query 4: number of employees per manager
SELECT 
    m.employee_id AS manager_id,
    m.full_name AS manager_name,
    COUNT(e.employee_id) AS num_employees
FROM hotel h 
JOIN employee m ON h.manager_id = m.employee_id
JOIN employee e ON h.hotel_id = e.hotel_id
WHERE e.employee_id <> m.employee_id
GROUP BY m.employee_id, m.full_name;


