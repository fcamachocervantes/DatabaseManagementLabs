--Name: Francisco Camacho

/* step 1 */
DROP TABLE IF EXISTS customer CASCADE;
CREATE TABLE customer(
    id SERIAL PRIMARY KEY,
    name TEXT,
    phone_number TEXT,
    location_point POINT,
    location_address TEXT
);

DROP TABLE IF EXISTS driver CASCADE;
CREATE TABLE driver(
    id SERIAL PRIMARY KEY,
    "name" TEXT,
    registration TEXT UNIQUE,
    phone_number TEXT
);

/* step 2 */
DROP TABLE IF EXISTS trips;
CREATE TABLE trips(
    id SERIAL PRIMARY KEY,
    "date" DATE,
    "time" TIME,
    "type" TEXT,
    number_of_riders INTEGER,  
    destination_point POINT,
    destination_address TEXT,
    fare NUMERIC (10,2)
);

DROP TABLE IF EXISTS vehicles CASCADE;
CREATE TABLE vehicles(
    driver_registration TEXT REFERENCES driver(registration),
    seats INTEGER,
    "state"  TEXT,
    plate_number TEXT UNIQUE,
    PRIMARY KEY(driver_registration, plate_number)
);

/* step 3 */
ALTER TABLE driver
ADD COLUMN vehicle_plate_number TEXT
    UNIQUE
    REFERENCES vehicles(plate_number);

/* step 4 */

ALTER TABLE trips
ADD COLUMN customer_id INTEGER
    REFERENCES customer(id);

ALTER TABLE trips
ADD COLUMN driver_id INTEGER
    REFERENCES driver(id);

/* step 5 */
DROP TABLE IF EXISTS payment_xref;
CREATE TABLE payment_xref(
    confirmation_number TEXT,
    customer_id INTEGER,
    driver_id INTEGER,
    method TEXT,
    amount NUMERIC (10,2),
    PRIMARY KEY (confirmation_number, customer_id, driver_id),
    FOREIGN KEY (customer_id) REFERENCES customer(id),
    FOREIGN KEY (driver_id) REFERENCES driver(id)
);

/* step 6 */
DROP TABLE IF EXISTS features;
CREATE TABLE features(
    feature TEXT,
    vehicle_plate_number TEXT,
    PRIMARY KEY (vehicle_plate_number, feature),
    FOREIGN KEY (vehicle_plate_number) REFERENCES vehicles(plate_number)
);

/* step 7 */
--not neccessary

/* step 8 */

CREATE VIEW trip_view AS
SELECT trip.id, customer.location_point<@>trips.destination_point AS distance
FROM customer, trips;