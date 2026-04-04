CREATE INDEX idx_room_price ON room(price);

CREATE INDEX idx_booking_room_dates
ON booking(hotel_id, room_number, start_date, end_date);

CREATE INDEX idx_renting_room_dates
ON renting(hotel_id, room_number, start_date, end_date);