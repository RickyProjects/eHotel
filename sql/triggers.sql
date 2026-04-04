DROP TRIGGER IF EXISTS trg_check_manager_same_hotel ON hotel;
DROP TRIGGER IF EXISTS trg_prevent_overlapping_booking ON booking;
DROP TRIGGER IF EXISTS trg_prevent_overlapping_renting ON renting;

--Trigger function 1
CREATE OR REPLACE FUNCTION check_manager_same_hotel()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.manager_id IS NULL THEN
        RAISE EXCEPTION 'Each hotel must have a manager.';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM employee e
        WHERE e.employee_id = NEW.manager_id
          AND e.hotel_id = NEW.hotel_id
          AND e.role = 'manager'
    ) THEN
        RAISE EXCEPTION 'manager_id must reference a manager employee working at the same hotel.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--Trigger function 2
CREATE OR REPLACE FUNCTION check_room_availability()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT *
        FROM booking b
        WHERE b.hotel_id = NEW.hotel_id
          AND b.room_number = NEW.room_number
          AND b.status IN ('pending', 'confirmed')
          AND b.start_date <= NEW.end_date
          AND NEW.start_date <= b.end_date
    ) THEN
        RAISE EXCEPTION 'Room booked.';
    END IF;
    
    IF EXISTS (
        SELECT * 
        FROM renting rg 
        WHERE rg.hotel_id = NEW.hotel_id
            AND rg.room_number = NEW.room_number
            AND rg.status IN ('pending', 'confirmed')
            AND rg.start_date <= NEW.end_date
            AND NEW.start_date <= rg.end_date
    ) THEN
        RAISE EXCEPTION 'Room rented.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--Trigger function 3


--Trigger definition 1
CREATE TRIGGER trg_check_manager_same_hotel
BEFORE INSERT OR UPDATE OF manager_id, hotel_id
ON hotel
FOR EACH ROW
EXECUTE FUNCTION check_manager_same_hotel();

--Trigger definition 2
CREATE TRIGGER trg_prevent_overlapping_booking
BEFORE INSERT 
ON booking
FOR EACH ROW
EXECUTE FUNCTION check_room_availability();

--Trigger definition 3

CREATE TRIGGER trg_prevent_overlapping_renting
BEFORE INSERT 
ON renting
FOR EACH ROW
EXECUTE FUNCTION check_room_availability();