DROP VIEW IF EXISTS hotel_capacity;
--DROP VIEW IF EXISTS available_rooms_per_area;

--view 1: number of avaialble rooms per area
--CREATE VIEW available_rooms_per_area AS

--view 2: aggregated capacity of all the rooms of a specific hotel.
CREATE VIEW hotel_capacity AS
SELECT h.hotel_id, COUNT(*) AS total_rooms
FROM hotel h 
JOIN room r 
ON h.hotel_id = r.hotel_id
GROUP BY h.hotel_id;

--view 1: test
--view 2: test
SELECT * FROM hotel_capacity;
