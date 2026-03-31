--mock data for a single hotel chain
INSERT INTO hotel_chain (chain_id, office_address, email_address, amount_hotels)
VALUES
(1, '100 King St W, Toronto, ON', 'contact@northstay.com', 8);

INSERT INTO customer (customer_id, full_name, address, id_type, date_of_registration)
VALUES
(1, 'Alice Johnson', '12 Maple Ave, Ottawa, ON', 'passport', '2026-03-01'),
(2, 'Bob Smith', '45 Pine St, Toronto, ON', 'SIN', '2026-03-02'),
(3, 'Charlie Brown', '78 Oak Rd, Vancouver, BC', 'passport', '2026-03-03'),
(4, 'Diana Prince', '22 Elm St, Montreal, QC', 'driver_licence', '2026-03-04'),
(5, 'Ethan Hunt', '9 Birch Ave, Calgary, AB', 'SSN', '2026-03-05'),
(6, 'Fiona Gallagher', '101 Cedar Ln, Winnipeg, MB', 'health_card', '2026-03-06'),
(7, 'George Miller', '56 Spruce Dr, Halifax, NS', 'residency', '2026-03-07'),
(8, 'Hannah Lee', '33 Willow St, Ottawa, ON', 'passport', '2026-03-08'),
(9, 'Isaac Newton', '88 Maple Rd, Kingston, ON', 'birth_certificate', '2026-03-09'),
(10, 'Julia Roberts', '17 Lakeview Blvd, Mississauga, ON', 'driver_licence', '2026-03-10'),
(11, 'Kevin Hart', '29 Sunset Ave, Edmonton, AB', 'SIN', '2026-03-11'),
(12, 'Liam Neeson', '67 River Rd, Saskatoon, SK', 'passport', '2026-03-12'),
(13, 'Mia Wong', '14 Highland St, Richmond, BC', 'health_card', '2026-03-13'),
(14, 'Noah Davis', '92 Forest Dr, Victoria, BC', 'SSN', '2026-03-14'),
(15, 'Olivia Taylor', '38 Meadow Ln, London, ON', 'driver_licence', '2026-03-15'),
(16, 'Paul Walker', '73 Hilltop Rd, Surrey, BC', 'residency', '2026-03-16'),
(17, 'Quinn Adams', '11 Valley St, Regina, SK', 'passport', '2026-03-17'),
(18, 'Rachel Green', '26 Broadway Ave, Toronto, ON', 'birth_certificate', '2026-03-18'),
(19, 'Sam Wilson', '59 Ocean Dr, Halifax, NS', 'SIN', '2026-03-19'),
(20, 'Tina Turner', '84 Sunset Blvd, Vancouver, BC', 'health_card', '2026-03-20'),
(21, 'Uma Thurman', '47 Garden St, Montreal, QC', 'driver_licence', '2026-03-21');

INSERT INTO hotel (hotel_id, chain_id, manager_id, hotel_address, rating, amount_rooms, email_address)
VALUES
(101, 1, NULL, '50 Rideau St, Ottawa, ON', 4, 5, 'rideau@northstay.com'),
(102, 1, NULL, '374 Elgin St, Ottawa, ON', 3, 5, 'elgin@northstay.com'),
(103, 1, NULL, '610 Somerset St W, Ottawa, ON', 4, 5, 'somerset1@northstay.com'),
(104, 1, NULL, '564 Bronson Ave, Ottawa, ON', 5, 5, 'bronson@northstay.com'),
(105, 1, NULL, '275 Laurier Ave E, Ottawa, ON', 2, 5, 'laurier@northstay.com'),
(106, 1, NULL, '60 Mann Ave, Ottawa, ON', 3, 5, 'mann@northstay.com'),
(107, 1, NULL, '337 Somerset St W, Ottawa, ON', 4, 5, 'somerset2@northstay.com'),
(108, 1, NULL, '525 Exhibition Way, Ottawa, ON', 5, 5, 'exhibitionway@northstay.com');

INSERT INTO employee (employee_id, hotel_id, full_name, address, ssn_sin, role)
VALUES
(1001, 101, 'Emma Brown', '77 Bank St, Ottawa, ON', '12-34-56789', 'manager'),
(1002, 101, 'Liam Green', '80 Queen St, Ottawa, ON', '987-65-4321', 'service'),
(1003, 102, 'Edee McEllen', '446 Center Plaza', '106-76-6568', 'manager'),
(1004, 102, 'Cele Spadaro', '88 Calypso Trail', '682-17-6368', 'administration'),
(1005, 103, 'Grove Lebarree', '3 Northland Avenue', '422-06-9451', 'manager'),
(1006, 103, 'Shelia Begg', '9045 Randy Hill', '885-31-1144', 'administration'),
(1007, 104, 'Denys Capron', '4 Alpine Drive', '832-06-3640', 'manager'),
(1008, 104, 'Leigh Houlridge', '54 Jackson Way', '216-35-8466', 'chef'),
(1009, 105, 'Bogart Zywicki', '7575 Harvey Hill', '514-56-6551', 'manager'),
(1010, 105, 'Brynne Eblein', '2021 Dunney Road', '204-01-5191', 'administration'),
(1011, 106, 'Rowan Blankenship', '83 Ohio Trail', '583-91-5100', 'manager'),
(1012, 106, 'Frankie Priestley', '23 Amity Ave', '434-35-2152', 'service'),
(1013, 107, 'Brant MacShirrie', '589 Cove Center W', '555-55-1735', 'manager'),
(1014, 107, 'Adora Gethouse', '839 Prariesview Drive', '362-68-8657', 'chef'),
(1015, 108, 'Jereme Coveley', '7899 Dunning Road', '436-50-6614', 'manager'),
(1016, 108, 'Harland Ranking', '1911 Alveries Circle', '236-55-6114', 'service');

--manually assigns a manager to each hotel
UPDATE hotel SET manager_id = 1001 WHERE hotel_id = 101;
UPDATE hotel SET manager_id = 1003 WHERE hotel_id = 102;
UPDATE hotel SET manager_id = 1005 WHERE hotel_id = 103;
UPDATE hotel SET manager_id = 1007 WHERE hotel_id = 104;
UPDATE hotel SET manager_id = 1009 WHERE hotel_id = 105;
UPDATE hotel SET manager_id = 1011 WHERE hotel_id = 106;
UPDATE hotel SET manager_id = 1013 WHERE hotel_id = 107;
UPDATE hotel SET manager_id = 1015 WHERE hotel_id = 108;

INSERT INTO room (hotel_id, room_number, price, room_capacity, view, is_extendable, is_damaged)
VALUES
(101, 201, 150, 'single', 'city', false, false),
(101, 202, 180, 'double', 'garden', true, false),
(101, 203, 220, 'queen', 'city', false, false),
(101, 204, 250, 'king', 'mountain', true, false),
(101, 205, 400, 'studio', 'sea', false, false),
(102, 201, 400, 'single', 'mountain', false, false),
(102, 202, 329, 'penthouse', 'mountain', false, true),
(102, 203, 118, 'double', 'mountain', false, false),
(102, 204, 137, 'twin', 'sea', false, true),
(102, 205, 69, 'single', 'mountain', true, true),
(103, 201, 338, 'penthouse', 'city', true, false),
(103, 202, 50, 'single', 'mountain', true, false),
(103, 203, 132, 'penthouse', 'city', false, false),
(103, 204, 372, 'single', 'sea', false, true),
(103, 205, 56, 'twin', 'garden', false, false),
(104, 201, 337, 'double', 'sea', false, false),
(104, 202, 207, 'queen', 'mountain', true, false),
(104, 203, 380, 'penthouse', 'garden', false, true),
(104, 204, 53, 'single', 'sea', false, true),
(104, 205, 340, 'queen', 'mountain', false, true),
(105, 201, 246, 'twin', 'mountain', false, true),
(105, 202, 366, 'double', 'garden', true, false),
(105, 203, 335, 'double', 'sea', false, true),
(105, 204, 350, 'double', 'mountain', false, false),
(105, 205, 189, 'penthouse', 'sea', true, false),
(106, 201, 289, 'double', 'city', false, false),
(106, 202, 228, 'king', 'garden', true, true),
(106, 203, 202, 'single', 'mountain', true, true),
(106, 204, 59, 'studio', 'garden', false, true),
(106, 205, 388, 'twin', 'sea', true, false),
(107, 201, 248, 'single', 'sea', true, true),
(107, 202, 125, 'studio', 'sea', true, true),
(107, 203, 301, 'penthouse', 'garden', false, false),
(107, 204, 373, 'single', 'garden', true, true),
(107, 205, 114, 'twin', 'sea', false, true),
(108, 201, 324, 'queen', 'city', true, false),
(108, 202, 112, 'queen', 'city', true, true),
(108, 203, 196, 'single', 'mountain', true, true),
(108, 204, 260, 'penthouse', 'mountain', true, true),
(108, 205, 128, 'double', 'garden', true, false);

INSERT INTO chain_phone_number (chain_id, phone_number)
VALUES
(1, '416-555-1000');

INSERT INTO hotel_phone_number (hotel_id, phone_number)
VALUES
(101, '613-255-2000'),
(102, '613-752-2001'),
(103, '613-356-2002'),
(104, '613-755-2003'),
(105, '613-501-2004'),
(106, '613-546-2005'),
(107, '613-129-2006'),
(108, '613-154-2007');

INSERT INTO amenities (hotel_id, room_number, amenity)
VALUES
(101, 201, 'tv'),
(101, 201, 'free_wifi'),
(101, 202, 'tv'),
(101, 202, 'fridge'),
(101, 203, 'coffee_machine'),
(101, 204, 'safe'),
(101, 205, 'complementary_breakfast'),
(102, 201, 'tv'),
(102, 201, 'free_wifi'),
(102, 202, 'tv'),
(102, 202, 'fridge'),
(102, 203, 'coffee_machine'),
(102, 204, 'safe'),
(102, 205, 'complementary_breakfast'),
(103, 201, 'tv'),
(103, 201, 'free_wifi'),
(103, 202, 'tv'),
(103, 202, 'fridge'),
(103, 203, 'coffee_machine'),
(103, 204, 'safe'),
(103, 205, 'complementary_breakfast'),
(104, 201, 'tv'),
(104, 201, 'free_wifi'),
(104, 202, 'tv'),
(104, 202, 'fridge'),
(104, 203, 'coffee_machine'),
(104, 204, 'safe'),
(104, 205, 'complementary_breakfast'),
(105, 201, 'tv'),
(105, 201, 'free_wifi'),
(105, 202, 'tv'),
(105, 202, 'fridge'),
(105, 203, 'coffee_machine'),
(105, 204, 'safe'),
(105, 205, 'complementary_breakfast'),
(106, 201, 'tv'),
(106, 201, 'free_wifi'),
(106, 202, 'tv'),
(106, 202, 'fridge'),
(106, 203, 'coffee_machine'),
(106, 204, 'safe'),
(106, 205, 'complementary_breakfast'),
(107, 201, 'tv'),
(107, 201, 'free_wifi'),
(107, 202, 'tv'),
(107, 202, 'fridge'),
(107, 203, 'coffee_machine'),
(107, 204, 'safe'),
(107, 205, 'complementary_breakfast'),
(108, 201, 'tv'),
(108, 201, 'free_wifi'),
(108, 202, 'tv'),
(108, 202, 'fridge'),
(108, 203, 'coffee_machine'),
(108, 204, 'safe'),
(108, 205, 'complementary_breakfast');

INSERT INTO booking (booking_id, customer_id, hotel_id, room_number, start_date, end_date, booking_date, status)
VALUES
(2, 2, 101, 202, '2026-04-12', '2026-04-16', '2026-03-30', 'confirmed'),
(3, 3, 102, 201, '2026-04-14', '2026-04-18', '2026-03-31', 'pending'),
(4, 4, 103, 205, '2026-04-20', '2026-04-25', '2026-04-01', 'confirmed'),
(5, 5, 101, 204, '2026-04-22', '2026-04-26', '2026-04-02', 'cancelled'),
(6, 6, 104, 203, '2026-04-11', '2026-04-13', '2026-03-29', 'confirmed'),
(7, 7, 105, 201, '2026-04-15', '2026-04-19', '2026-04-01', 'pending'),
(8, 8, 102, 205, '2026-04-18', '2026-04-22', '2026-04-03', 'confirmed'),
(9, 9, 103, 201, '2026-04-25', '2026-04-30', '2026-04-04', 'pending'),
(10, 10, 104, 202, '2026-04-17', '2026-04-20', '2026-04-02', 'confirmed'),
(11, 11, 105, 204, '2026-04-19', '2026-04-23', '2026-04-05', 'cancelled'),
(12, 12, 101, 203, '2026-04-13', '2026-04-17', '2026-03-31', 'confirmed'),
(13, 13, 102, 204, '2026-04-21', '2026-04-24', '2026-04-06', 'pending'),
(14, 14, 103, 201, '2026-04-23', '2026-04-28', '2026-04-07', 'confirmed'),
(15, 15, 104, 203, '2026-04-10', '2026-04-14', '2026-03-30', 'pending'),
(16, 16, 105, 204, '2026-04-16', '2026-04-21', '2026-04-03', 'confirmed'),
(17, 17, 101, 205, '2026-04-24', '2026-04-29', '2026-04-08', 'cancelled'),
(18, 18, 102, 202, '2026-04-12', '2026-04-15', '2026-03-30', 'confirmed'),
(19, 19, 103, 202, '2026-04-27', '2026-05-01', '2026-04-09', 'pending'),
(20, 20, 104, 204, '2026-04-14', '2026-04-18', '2026-04-01', 'confirmed'),
(21, 21, 105, 203, '2026-04-22', '2026-04-26', '2026-04-05', 'confirmed');

INSERT INTO renting (renting_id, customer_id, hotel_id, room_number, start_date, end_date, checkin_date, status)
VALUES
(101, 2, 101, 201, '2026-04-05', '2026-04-08', '2026-04-05', 'completed'),
(102, 3, 102, 202, '2026-04-06', '2026-04-10', '2026-04-06', 'completed'),
(103, 4, 103, 203, '2026-04-07', '2026-04-12', '2026-04-08', 'completed'),
(104, 5, 104, 204, '2026-04-08', '2026-04-11', '2026-04-08', 'completed'),
(105, 6, 105, 205, '2026-04-09', '2026-04-13', '2026-04-09', 'completed'),
(106, 7, 101, 201, '2026-04-10', '2026-04-14', '2026-04-11', 'completed'),
(107, 8, 102, 202, '2026-04-11', '2026-04-15', '2026-04-11', 'completed'),
(108, 9, 103, 203, '2026-04-12', '2026-04-16', '2026-04-13', 'completed'),
(109, 10, 104, 204, '2026-04-13', '2026-04-17', '2026-04-13', 'completed'),
(110, 11, 105, 205, '2026-04-14', '2026-04-18', '2026-04-15', 'completed'),
(111, 12, 101, 201, '2026-04-15', '2026-04-19', '2026-04-15', 'completed'),
(112, 13, 102, 202, '2026-04-16', '2026-04-20', '2026-04-17', 'completed'),
(113, 14, 103, 203, '2026-04-17', '2026-04-21', '2026-04-17', 'completed'),
(114, 15, 104, 204, '2026-04-18', '2026-04-22', '2026-04-19', 'completed'),
(115, 16, 105, 205, '2026-04-19', '2026-04-23', '2026-04-19', 'completed'),
(116, 17, 101, 201, '2026-04-20', '2026-04-24', '2026-04-21', 'completed'),
(117, 18, 102, 202, '2026-04-21', '2026-04-25', '2026-04-21', 'completed'),
(118, 19, 103, 203, '2026-04-22', '2026-04-26', '2026-04-23', 'completed'),
(119, 20, 104, 204, '2026-04-23', '2026-04-27', '2026-04-23', 'completed'),
(120, 21, 105, 205, '2026-04-24', '2026-04-28', '2026-04-25', 'completed');