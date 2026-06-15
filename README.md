# Football Ticket Booking System - Database Management System

An intermediate-to-advanced relational database design and implementation project simulating a real-world **Football Ticket Booking System**. This system handles security clearances for internal administrators, baseline structural event scheduling, user transactions, and dynamic ticket auditing.


##  Architecture Design & Business Logic

The database layout utilizes a centralized transaction architecture where the `Bookings` table functions as a secure relational bridge managing relations between buyers and competitive fixtures.

### Entity Relationship Rules
* **Users ➔ Bookings (One-to-Many):** A single registered fan can purchase multiple discrete match tickets across a competitive season.
* **Matches ➔ Bookings (Many-to-One):** A premier marquee derby match can accommodate thousands of distinct transactional reservation logs.
* **Row-Level Mapping (Logical One-to-One):** Any isolated transactional record tracking entry in the database correlates exactly one client to one match layout location per seat selection.

### Database Schema Structure

#### 1. Users Table
Tracks user system privileges, identities, and unique contact connection data points.
* `user_id` (SERIAL, Primary Key)
* `full_name` (VARCHAR)
* `email` (VARCHAR, Unique)
* `role` (VARCHAR, Restricted via CHECK constraint to: `'Ticket Manager'`, `'Football Fan'`)
* `phone_number` (VARCHAR, Nullable)

#### 2. Matches Table
Manages upcoming tournament logistical metrics and basic entry fee details.
* `match_id` (SERIAL, Primary Key)
* `fixture` (VARCHAR)
* `tournament_category` (VARCHAR)
* `base_ticket_price` (DECIMAL, Confined via CHECK constraint to $\ge 0$)
* `match_status` (VARCHAR, Restricted via CHECK constraint to: `'Available'`, `'Selling Fast'`, `'Sold Out'`, `'Postponed'`)

#### 3. Bookings Table
The central transactional system engine storing historical billing allocations.
* `booking_id` (SERIAL, Primary Key)
* `user_id` (INT, Foreign Key referencing `Users(user_id)`)
* `match_id` (INT, Foreign Key referencing `Matches(match_id)`)
* `seat_number` (VARCHAR, Nullable)
* `payment_status` (VARCHAR, Restricted via CHECK constraint to: `'Pending'`, `'Confirmed'`, `'Cancelled'`, `'Refunded'`, Nullable)
* `total_cost` (DECIMAL, Confined via CHECK constraint to $\ge 0$)

---

## 💻 Environment Setup & Initialization

Execute the commands below within your SQL management interface (e.g., PostgreSQL pgAdmin, DBeaver, or psql CLI) to configure the target database schema environment:

```sql
-- Build Schema Constraints and Relations
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    role VARCHAR(255) CHECK(role IN('Ticket Manager','Football Fan')),
    phone_number VARCHAR(30)
);

CREATE TABLE Matches (
    match_id SERIAL PRIMARY KEY,
    fixture VARCHAR(255) NOT NULL,
    tournament_category VARCHAR(255) NOT NULL,
    base_ticket_price DECIMAL(10,2) CHECK(base_ticket_price >= 0),
    match_status VARCHAR(255) CHECK(match_status IN('Available','Selling Fast','Sold Out','Postponed'))
);

CREATE TABLE Bookings (
    booking_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id),
    match_id INT REFERENCES Matches(match_id),
    seat_number VARCHAR(55),
    payment_status VARCHAR(60) CHECK(payment_status IN('Pending','Confirmed','Cancelled','Refunded')),
    total_cost DECIMAL(10,2) CHECK(total_cost >= 0)
);