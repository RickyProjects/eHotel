DROP TRIGGER IF EXISTS trg_check_manager_same_hotel ON hotel;
DROP TRIGGER IF EXISTS trg_check_booking_availability ON booking;
DROP TRIGGER IF EXISTS trg_check_renting_availability ON renting;
DROP TRIGGER IF EXISTS trg_one_manager_per_hotel ON employee;

-- Trigger function 1
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

-- Trigger function 2
CREATE OR REPLACE FUNCTION check_booking_availability()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM booking b
        WHERE b.hotel_id = NEW.hotel_id
          AND b.room_number = NEW.room_number
          AND b.booking_id <> NEW.booking_id
          AND b.status IN ('pending', 'confirmed')
          AND b.start_date < NEW.end_date
          AND NEW.start_date < b.end_date
    ) THEN
        RAISE EXCEPTION 'Room already booked.';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM renting r
        WHERE r.hotel_id = NEW.hotel_id
          AND r.room_number = NEW.room_number
          AND r.status IN ('pending', 'confirmed')
          AND r.start_date < NEW.end_date
          AND NEW.start_date < r.end_date
    ) THEN
        RAISE EXCEPTION 'Room already rented.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger function 3
CREATE OR REPLACE FUNCTION check_renting_availability()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM booking b
        WHERE b.hotel_id = NEW.hotel_id
          AND b.room_number = NEW.room_number
          AND b.status IN ('pending', 'confirmed')
          AND b.start_date < NEW.end_date
          AND NEW.start_date < b.end_date
    ) THEN
        RAISE EXCEPTION 'Room already booked.';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM renting r
        WHERE r.hotel_id = NEW.hotel_id
          AND r.room_number = NEW.room_number
          AND r.renting_id <> NEW.renting_id
          AND r.status IN ('pending', 'confirmed')
          AND r.start_date < NEW.end_date
          AND NEW.start_date < r.end_date
    ) THEN
        RAISE EXCEPTION 'Room already rented.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger function 4

CREATE OR REPLACE FUNCTION check_one_manager_per_hotel()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.role = 'manager' THEN
        IF EXISTS (
            SELECT 1
            FROM employee e
            WHERE hotel_id = NEW.hotel_id
                AND e.role = 'manager'
                AND e.employee_id <> NEW.employee_id
        ) THEN
            RAISE EXCEPTION 'This Hotel already has a manager.';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger definition 1
CREATE TRIGGER trg_check_manager_same_hotel
BEFORE INSERT OR UPDATE OF manager_id, hotel_id
ON hotel
FOR EACH ROW
EXECUTE FUNCTION check_manager_same_hotel();

-- Trigger definition 2
CREATE TRIGGER trg_check_booking_availability
BEFORE INSERT OR UPDATE
ON booking
FOR EACH ROW
WHEN (NEW.status IN ('pending','confirmed'))
EXECUTE FUNCTION check_booking_availability();

-- Trigger definition 3
CREATE TRIGGER trg_check_renting_availability
BEFORE INSERT OR UPDATE
ON renting
FOR EACH ROW
WHEN (NEW.status IN ('pending','confirmed'))
EXECUTE FUNCTION check_renting_availability();

CREATE TRIGGER trg_one_manager_per_hotel
BEFORE INSERT OR UPDATE OF hotel_id, role
ON employee
FOR EACH ROW 
WHEN (NEW.role = 'manager')
EXECUTE FUNCTION check_one_manager_per_hotel();