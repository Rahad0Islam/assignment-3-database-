-- =========================================================================
-- SYSTEM: Football Ticket Booking System Database Setup Template
-- DESCRIPTION: Pseudo-DDL Template for Table Creation & Data Insertion
-- INSTRUCTIONS: Replace 'TYPE' and the constraint placeholders with your own
--               actual data types, relational keys, and check criteria.
-- =========================================================================

-- DROP TABLES IF THEY ALREADY EXIST TO PREVENT CONFLICTS
DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS Matches;
DROP TABLE IF EXISTS Users;

-- =========================================================================
-- 1. CREATE USERS TABLE
-- =========================================================================
CREATE TABLE Users (
    user_id SERIAL,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    role VARCHAR(255) NOT NULL,
    phone_number VARCHAR(30),

    PRIMARY KEY(user_id),
    UNIQUE(email),
    CHECK(role IN('Ticket Manager','Football Fan'))

);

-- =========================================================================
-- 2. CREATE MATCHES TABLE
-- =========================================================================
CREATE TABLE Matches (
    match_id SERIAL,
    fixture VARCHAR(255) NOT NULL,
    tournament_category VARCHAR(255) NOT NULL,
    base_ticket_price DECIMAL(10,2) NOT NULL,
    match_status VARCHAR(255) NOT NULL,
    PRIMARY KEY(match_id),
    CHECK(base_ticket_price>=0),
    CHECK (match_status IN('Available','Selling Fast','Sold Out','Postponed'))
    -- Write your constraint to make 'match_id' the Primary Key
    -- Write your check constraint to prevent negative ticket prices
    -- Write your check constraint to restrict 'match_status' values

);

-- =========================================================================
-- 3. CREATE BOOKINGS TABLE
-- =========================================================================
CREATE TABLE Bookings (
    booking_id SERIAL,
    user_id INT,
    match_id INT,
    seat_number VARCHAR(55),
    payment_status VARCHAR(60),
    total_cost DECIMAL(10,2),
    
    PRIMARY KEY(booking_id),
    Foreign Key (user_id) REFERENCES Users(user_id),
    Foreign Key (match_id) REFERENCES Matches(match_id),
    CHECK (total_cost>=0),
    CHECK (payment_status IN ('Pending','Confirmed','Cancelled','Refunded'))
    -- Write your constraint to make 'booking_id' the Primary Key
    -- Write your Foreign Key constraint linking 'user_id' to the Users table
    -- Write your Foreign Key constraint linking 'match_id' to the Matches table
    -- Write your check constraint to ensure 'total_cost' is non-negative
    -- Write your check constraint to restrict 'payment_status' values
);


-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO USERS
-- =========================================================================
INSERT INTO Users (user_id, full_name, email, role, phone_number) VALUES
(1, 'Tanvir Rahman', 'tanvir@mail.com', 'Football Fan', '+8801711111111'),
(2, 'Asif Haque', 'asif@mail.com', 'Football Fan', '+8801722222222'),
(3, 'Sajjad Rahman', 'sajjad@mail.com', 'Ticket Manager', '+8801733333333'),
(4, 'Jannat Ara', 'jannat@mail.com', 'Football Fan', NULL);

-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO MATCHES
-- =========================================================================
INSERT INTO Matches (match_id, fixture, tournament_category, base_ticket_price, match_status) VALUES
(101, 'Real Madrid vs Barcelona', 'Champions League', 150.00, 'Available'),
(102, 'Man City vs Liverpool', 'Premier League', 120.00, 'Selling Fast'),
(103, 'Bayern Munich vs PSG', 'Champions League', 130.00, 'Available'),
(104, 'AC Milan vs Inter Milan', 'Serie A', 90.00, 'Sold Out'),
(105, 'Juventus vs Roma', 'Serie A', 80.00, 'Available');

-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO BOOKINGS
-- =========================================================================
INSERT INTO Bookings (booking_id, user_id, match_id, seat_number, payment_status, total_cost) VALUES
(501, 1, 101, 'A-12', 'Confirmed', 150.00),
(502, 1, 102, 'B-04', 'Confirmed', 120.00),
(503, 2, 101, 'A-13', 'Confirmed', 150.00),
(504, 2, 101, NULL, NULL, 150.00),
(505, 3, 102, 'C-20', 'Pending', 120.00);



-- query 1

SELECT match_id,fixture,base_ticket_price
FROM matches
WHERE tournament_category = 'Champions League'
       AND match_status = 'Available';


-- query 2
SELECT user_id,full_name,email
FROM users
WHERE full_name ILIKE 'tanvir%'
or full_name ILIKE '%Haque%';

-- query 3

SELECT booking_id,user_id,match_id,COALESCE(payment_status,'Action Required')as systematic_status
FROM bookings
WHERE payment_status is NULL;

-- query 4
SELECT booking_id,full_name,fixture,total_cost
FROM bookings
INNER join users USING(user_id)
INNER JOIN matches USING(match_id);


-- query 5

SELECT user_id,full_name,booking_id
FROM users
left JOIN bookings USING (user_id);

-- query 6
SELECT booking_id,match_id,total_cost
FROM bookings
WHERE total_cost >  (
    SELECT AVG(total_cost)
    FROM bookings
);

-- query 7
SELECT match_id, fixture, base_ticket_price
FROM matches
ORDER BY base_ticket_price DESC
LIMIT 2 OFFSET 1;


