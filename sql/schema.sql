DROP TABLE IF EXISTS amenities CASCADE;
DROP TABLE IF EXISTS booking CASCADE;
DROP TABLE IF EXISTS renting CASCADE;
DROP TABLE IF EXISTS hotel_phone_number CASCADE;
DROP TABLE IF EXISTS chain_phone_number CASCADE;
DROP TABLE IF EXISTS room CASCADE;
DROP TABLE IF EXISTS employee CASCADE;
DROP TABLE IF EXISTS hotel CASCADE;
DROP TABLE IF EXISTS customer CASCADE;
DROP TABLE IF EXISTS hotel_chain CASCADE;


CREATE TABLE hotel_chain (
    chain_id INTEGER PRIMARY KEY,
    office_address VARCHAR(255) NOT NULL,
    email_address VARCHAR(255) NOT NULL,
    amount_hotels INTEGER NOT NULL CHECK (amount_hotels >= 0)
);

CREATE TABLE customer(
    customer_id INTEGER PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    id_type VARCHAR(50) NOT NULL CHECK (
	    id_type IN ('SSN', 'SIN', 'driver_licence', 'health_card', 'passport', 'residency', 'birth_certificate')
	),
    date_of_registration DATE NOT NULL
);

CREATE TABLE hotel(
    hotel_id INTEGER PRIMARY KEY,
    chain_id INTEGER NOT NULL,
	manager_id INTEGER UNIQUE,
    hotel_address VARCHAR(255) NOT NULL,
    rating INTEGER CHECK (rating BETWEEN 1 AND 5),
    amount_rooms INTEGER CHECK (amount_rooms >= 0),
    email_address VARCHAR(255) NOT NULL,
    FOREIGN KEY (chain_id) REFERENCES hotel_chain(chain_id)
);

CREATE TABLE employee(
    employee_id INTEGER PRIMARY KEY,
    hotel_id INTEGER NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    ssn_sin VARCHAR(20) NOT NULL UNIQUE, --string because integers starting with 0 would lose the 0
    role VARCHAR(50) NOT NULL CHECK (role IN ('service', 'manager', 'administration', 'chef')),
    FOREIGN KEY (hotel_id) REFERENCES hotel(hotel_id)
);

CREATE TABLE room(
    hotel_id INTEGER NOT NULL,
    room_number INTEGER NOT NULL,
    price INTEGER NOT NULL CHECK (price > 0),
    room_capacity VARCHAR(20) NOT NULL CHECK (
        room_capacity IN ('single', 'double', 'twin', 'queen', 'king', 'studio', 'penthouse')
    ),
    view VARCHAR(20) NOT NULL CHECK (
        view IN ('sea', 'mountain', 'city', 'garden')
    ),
    is_extendable BOOLEAN NOT NULL DEFAULT FALSE,
    is_damaged BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (hotel_id, room_number), --composite key because room is a weak entity
    FOREIGN KEY (hotel_id) REFERENCES hotel(hotel_id)
);

CREATE TABLE chain_phone_number(
	chain_id INTEGER NOT NULL,
	phone_number VARCHAR(25) NOT NULL, --string because integers starting with 0 would lose the 0
	PRIMARY KEY (chain_id, phone_number),
	FOREIGN KEY (chain_id) REFERENCES hotel_chain(chain_id)
);

CREATE TABLE hotel_phone_number(
	hotel_id INTEGER NOT NULL,
	phone_number VARCHAR(25) NOT NULL, --string because integers starting with 0 would lose the 0
	PRIMARY KEY (hotel_id, phone_number),
	FOREIGN KEY (hotel_id) REFERENCES hotel(hotel_id)
);

CREATE TABLE amenities(
    hotel_id INTEGER NOT NULL,
    room_number INTEGER NOT NULL,
    amenity VARCHAR(30) NOT NULL CHECK (
        amenity IN ('tv', 'air_conditioning', 'heating', 'fridge', 'free_wifi', 'coffee_machine', 'complementary_breakfast', 'complementary_dinner', 'outlets', 'safe')
    ),
    PRIMARY KEY (hotel_id, room_number, amenity),
    FOREIGN KEY (hotel_id, room_number) REFERENCES room(hotel_id, room_number)
);

CREATE TABLE booking(
	booking_id INTEGER PRIMARY KEY,
	customer_id INTEGER,
	hotel_id INTEGER,
	room_number INTEGER,
	start_date DATE NOT NULL,
	end_date DATE NOT NULL,
	booking_date DATE NOT NULL,
	status VARCHAR(20) NOT NULL CHECK (status IN ('pending', 'confirmed', 'cancelled', 'archived')),
	CHECK (start_date < end_date),
	FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE SET NULL,
    FOREIGN KEY (hotel_id, room_number) REFERENCES room(hotel_id, room_number) ON DELETE SET NULL,

    CHECK (
        status = 'archived'
        OR (customer_id IS NOT NULL AND hotel_id IS NOT NULL AND room_number IS NOT NULL)
    )
);

CREATE TABLE renting(
	renting_id INTEGER PRIMARY KEY,
	customer_id INTEGER,
	hotel_id INTEGER,
	room_number INTEGER,
	start_date DATE NOT NULL,
	end_date DATE NOT NULL,
	checkin_date DATE NOT NULL,
	status VARCHAR(20) NOT NULL CHECK (status IN ('pending', 'confirmed', 'cancelled', 'archived')),
	CHECK (start_date < end_date),
	CHECK (checkin_date >= start_date),
	FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE SET NULL,
    FOREIGN KEY (hotel_id, room_number) REFERENCES room(hotel_id, room_number) ON DELETE SET NULL,

    CHECK (
        status = 'archived'
        OR (customer_id IS NOT NULL AND hotel_id IS NOT NULL AND room_number IS NOT NULL)
    )
);

