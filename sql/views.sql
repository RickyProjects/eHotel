DROP VIEW IF EXISTS hotel_capacity;
DROP VIEW IF EXISTS available_rooms_per_area;

--view 1: number of avaialble rooms per area
CREATE VIEW available_rooms_per_area AS
SELECT 
    TRIM(split_part(h.hotel_address,',',2)) AS area, 
    COUNT(*) AS available_rooms
FROM hotel h 
JOIN room r ON r.hotel_id = h.hotel_id
WHERE r.is_damaged = FALSE

AND NOT EXISTS (
    SELECT *
    FROM booking b
    WHERE b.hotel_id = r.hotel_id
        AND b.room_number = r.room_number
        AND b.status IN ('pending', 'confirmed')
        AND b.start_date <= CURRENT_DATE
        AND CURRENT_DATE <= b.end_date
)

AND NOT EXISTS(
    SELECT *
    FROM renting rg
    WHERE rg.hotel_id = r.hotel_id
      AND rg.room_number = r.room_number
      AND rg.start_date <= CURRENT_DATE
      AND CURRENT_DATE <= rg.end_date
)

GROUP BY TRIM(split_part(h.hotel_address, ',', 2));

--view 2: aggregated capacity of all the rooms of a specific hotel.
CREATE VIEW hotel_capacity AS
SELECT h.hotel_id, COUNT(*) AS total_rooms
FROM hotel h 
JOIN room r 
ON h.hotel_id = r.hotel_id
GROUP BY h.hotel_id;

--view 1: test
SELECT * FROM available_rooms_per_area;
--view 2: test
SELECT * FROM hotel_capacity;
