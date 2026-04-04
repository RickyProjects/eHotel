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

DROP TRIGGER IF EXISTS trg_check_manager_same_hotel ON hotel;

CREATE TRIGGER trg_check_manager_same_hotel
BEFORE INSERT OR UPDATE OF manager_id, hotel_id
ON hotel
FOR EACH ROW
EXECUTE FUNCTION check_manager_same_hotel();

CREATE OR REPLACE FUNCTION prevent_overlapping_booking()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM booking b
        WHERE b.hotel_id = NEW.hotel_id
          AND b.room_number = NEW.room_number
          AND b.status IN ('pending', 'confirmed')
          AND b.booking_id <> COALESCE(NEW.booking_id, -1)
          AND b.start_date < NEW.end_date
          AND NEW.start_date < b.end_date
    ) THEN
        RAISE EXCEPTION 'Overlapping booking exists for this room.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_prevent_overlapping_booking ON booking;

CREATE TRIGGER trg_prevent_overlapping_booking
BEFORE INSERT OR UPDATE OF hotel_id, room_number, start_date, end_date, status
ON booking
FOR EACH ROW
WHEN (NEW.status IN ('pending', 'confirmed'))
EXECUTE FUNCTION prevent_overlapping_booking();