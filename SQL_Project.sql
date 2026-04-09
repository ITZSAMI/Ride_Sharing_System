USE Ride_Sharing_System;

CREATE TABLE Users
	(
		user_id INT PRIMARY KEY AUTO_INCREMENT,
		first_name VARCHAR(55) NOT NULL,
		last_name VARCHAR(55) NOT NULL,
		email VARCHAR(55) UNIQUE NOT NULL,
		phone_number VARCHAR(20),
		password_hash VARCHAR(100) NOT NULL,
		date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP
	);
	
CREATE TABLE Drivers
	(
		driver_id INT PRIMARY KEY AUTO_INCREMENT,
		first_name VARCHAR(55) NOT NULL,
		last_name VARCHAR(55) NOT NULL,
		email VARCHAR(55) UNIQUE NOT NULL,
		phone_number VARCHAR(20),
		license_number VARCHAR(55) UNIQUE NOT NULL,
		status ENUM('active', 'inactive', 'suspended') NOT NULL,
		date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP
	);

CREATE TABLE Vehicles
	(
		vehicle_id INT PRIMARY KEY AUTO_INCREMENT,
		driver_id INT NOT NULL UNIQUE,
		make VARCHAR(20) NOT NULL,
		model VARCHAR(20) NOT NULL,
		color VARCHAR(20) NOT NULL,
		license_plate_number VARCHAR(20) UNIQUE NOT NULL,
		vehicle_year INT NOT NULL,
		FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id)
	);
	
CREATE TABLE Ride_Requests
	(
		request_id INT PRIMARY KEY AUTO_INCREMENT,
		user_id INT NOT NULL,
		driver_id INT,
		pickup_address VARCHAR(100) NOT NULL,
		dropoff_address VARCHAR(100) NOT NULL,
		request_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
		status ENUM('pending', 'accepted', 'cancelled', 'completed') NOT NULL,
		estimated_price DECIMAL(10,2),
		estimated_distance_km DECIMAL(5,2),
		duration_min INT,
		FOREIGN KEY (user_id) REFERENCES Users(user_id),
		FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id)
	);

CREATE TABLE Trips
	(
		trip_id INT PRIMARY KEY AUTO_INCREMENT,
		request_id INT NOT NULL,
		driver_id INT NOT NULL,
		vehicle_id INT NOT NULL,
		start_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
		end_time TIMESTAMP,
		pickup_address VARCHAR(100) NOT NULL,
		dropoff_address VARCHAR(100) NOT NULL,
		real_distance_km DECIMAL(10,2),
		real_price DECIMAL(10,2),
		trip_status ENUM('ongoing', 'completed', 'cancelled') NOT NULL,
		FOREIGN KEY (request_id) REFERENCES Ride_Requests(request_id),
		FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id),
		FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id)
	);

CREATE TABLE Transactions
	(
		transaction_id INT PRIMARY KEY AUTO_INCREMENT,
		trip_id INT NOT NULL UNIQUE,
		amount DECIMAL(10,2) NOT NULL,
		transaction_method VARCHAR(20) NOT NULL,
		transaction_status ENUM('pending', 'successful', 'failed') NOT NULL,
		transaction_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
		FOREIGN KEY (trip_id) REFERENCES Trips(trip_id)
	);
	
CREATE TABLE Ratings
	(
		rating_id INT PRIMARY KEY AUTO_INCREMENT,
		trip_id INT NOT NULL UNIQUE,
		user_id INT NOT NULL,
		driver_id INT NOT NULL,
		rating_score DECIMAL(2,1) NOT NULL CHECK (rating_score BETWEEN 1 AND 5),
		comment VARCHAR(255),
		rating_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
		FOREIGN KEY (trip_id) REFERENCES Trips(trip_id),
		FOREIGN KEY (user_id) REFERENCES Users(user_id),
		FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id)
	);


INSERT INTO Users (first_name, last_name, email, phone_number, 
password_hash)
VALUES 
('Sami', 'Albaroudi', 'samialbaroudi2006@gmail.com', '258934857', 'sada8329a'),
('Walter', 'White', 'walterwhite123@gmail.com', '938276540', 'lk4j9d8h1'),
('Cristiano', 'Ronaldo', 'cristianoronaldo7@gmail.com', '009283764', 'sdnv9c89s'),
('Neymar', 'Junior', 'neymarjr@gmail.com', '902348291', 'asnvi38sb'),
('Lionel', 'Messi', 'leomessi@gmail.com', '248765902', 'ch4b87db2'),
('James', 'Bond', 'jamesbond@gmail.com', '438057649', 'sb58nbd92'),
('Elon', 'Musk', 'elonmusk@gmail.com', '309287649', 'asnd8928h'),
('Jamal', 'Musiala', 'jamalmusiala@gmail.com', '349857893', 'fbn45hb69');

INSERT INTO Drivers (first_name, last_name, email, phone_number, license_number, status)
VALUES
('Eric', 'Brandy', 'ericbrandy@gmail.com', '389471094', 'B34H7859DK2', 'active'),
('Mike', 'Henry', 'mikehenry@gmail.com', '454545873', 'DE439047', 'active'),
('Steve', 'Brown', 'stevebrown@gmail.com', '459090937', 'DE384736', 'inactive'),
('Ben', 'Hall','benhall@gmail.com', '343492948', 'DE121239', 'active');

UPDATE Drivers 
SET license_number = 'FH43KJBX9S1'
WHERE driver_id = 1;

UPDATE Drivers 
SET license_number = 'B8FC77G63K0'
WHERE driver_id = 2;

UPDATE Drivers 
SET license_number = 'K94FSZ73B29'
WHERE driver_id = 3;

UPDATE Drivers 
SET license_number = 'SB84MC81921'
WHERE driver_id = 4;





INSERT INTO Vehicles (driver_id, make, model, color, 
license_plate_number, vehicle_year)
VALUES
(1, 'Mercedes', 'S300', 'Black', 'B-CA5469', '2024'),
(2, 'BMW', 'M5', 'White', 'B-QF5549', '2019'),
(3, 'Mercedes', 'AMG GT','Navy Blue', 'B-GF8736', '2021'),
(4, 'Toyota', 'Land Cruiser', 'White', 'B-FB2386', '2020');

INSERT INTO Ride_Requests (user_id, driver_id, pickup_address, 
dropoff_address, status, estimated_price, estimated_distance_km, duration_min)
VALUES
(7, 2, 'Bernauer Strasse 2', 'Karlmarx Strasse 16', 'accepted', 12.00, 8.4, 10 ),
(5, 4, 'Waßmannsdorfer Chaussee 100', 'Leopoldstraße 76', 'completed', 15.00, 10.5, 15),
(3, 1, 'Leopoldstraße 43', 'Brandenburgische Straße 97', 'accepted', 13.00, 9.0, 9),
(4, 4, 'Leopoldstraße 66', 'Genslerstraße 125', 'accepted', 17.00, 14.5, 20),
(1, NULL, 'Genslerstraße 81', 'Genslerstraße 16', 'pending', 8.60, 6.8, 7),
(2, 1, 'Brandenburgische Straße 120', 'Brandenburgische Straße 84', 'cancelled', 12.50, 9.3, 12),
(6, 2, 'Waßmannsdorfer Chaussee 100', 'Brandenburgische Straße 66', 'completed', 16.75, 15.2, 18),
(2, 2, 'Brandenburgische Straße 120', 'Brandenburgische Straße 84', 'accepted', 13.00, 9.3, 14);

INSERT INTO Trips (request_id, driver_id, vehicle_id, end_time, pickup_address, 
dropoff_address, real_distance_km, real_price, trip_status)
VALUES 
(1, 2, 2, NULL,'Bernauer Strasse 2', 'Karlmarx Strasse 16', 8.5, 12.50, 'ongoing'),
(2, 4, 4, CURRENT_TIMESTAMP, 'Waßmannsdorfer Chaussee 100', 'Leopoldstraße 76', 10.50, 15.00, 'completed'),
(3, 1, 1, NULL, 'Leopoldstraße 43', 'Brandenburgische Straße 97', 9.0, 13.00, 'ongoing'),
(4, 4, 4, NULL, 'Leopoldstraße 66', 'Genslerstraße 125', 14.5, 18.00, 'ongoing'),
(7, 2, 2, CURRENT_TIMESTAMP, 'Waßmannsdorfer Chaussee 100', 'Brandenburgische Straße 66', 15.50, 17.00, 'completed'),
(8, 2, 2, NULL, 'Brandenburgische Straße 120', 'Brandenburgische Straße 84', 9.30, 13.00, 'ongoing');

ALTER TABLE Trips
MODIFY end_time TIMESTAMP NULL DEFAULT NULL;

UPDATE Trips
SET end_time = NULL
WHERE trip_id = 1;

UPDATE Trips 
SET end_time = NULL
WHERE trip_id = 3;

UPDATE Trips 
SET end_time = NULL
WHERE trip_id = 4;

UPDATE Trips 
SET end_time = NULL
WHERE trip_id = 6;

UPDATE Trips 
SET end_time = '2026-03-26 14:30:00'
WHERE trip_id = 2;

UPDATE Trips
SET end_time = '2026-03-24 17:45:00'
WHERE trip_id = 5;

UPDATE Trips
SET start_time = '2026-03-26 14:15:00'
WHERE trip_id = 2;

UPDATE Trips
SET start_time = '2026-03-24 17:27:00'
WHERE trip_id = 5;

UPDATE Trips
SET start_time = '2026-03-27 15:25:00'
WHERE trip_id = 1;

UPDATE Trips
SET start_time = '2026-03-27 15:20:00'
WHERE trip_id = 3;

UPDATE Trips
SET start_time = '2026-03-27 15:30:00'
WHERE trip_id = 4;

UPDATE Trips
SET start_time = '2026-03-27 15:33:00'
WHERE trip_id = 6;

SELECT * FROM Trips;

ALTER TABLE Transactions
MODIFY transaction_time TIMESTAMP NULL DEFAULT NULL;

INSERT INTO Transactions (trip_id, amount, transaction_method, transaction_status, 
transaction_time)
VALUES 
(1, 12.50, 'cash', 'pending', NULL),
(2, 15.00, 'card', 'successful', '2026-03-26 14:08:00'),
(3, 13.00, 'card', 'successful', '2026-03-27 15:15:00'),
(4, 18.00, 'cash', 'pending', NULL),
(5, 17.00, 'card', 'successful', '2026-03-24 17:20:00'),
(6, 13.00, 'cash', 'pending', NULL);

INSERT INTO Ratings (trip_id, user_id, driver_id, rating_score, comment)
VALUES
(2, 5, 4, 4.5, 'Peaceful ride!'),
(5, 6, 2, 3.0, 'Driver was risking our lives');

# Show that all users have been inputed correctly

SELECT * FROM Users;

# Showing all active drivers

SELECT *
FROM Drivers
WHERE status = 'active';

# Showing all vehicles with their respective drivers

SELECT v.vehicle_id, v.make, v.vehicle_year, v.color,  v.model, v.license_plate_number, d.driver_id, d.first_name,
		d.last_name, d.phone_number
FROM Vehicles v
JOIN Drivers d ON v.driver_id = d.driver_id;

# Showing all ride requests with user names

SELECT r.request_id, r.pickup_address, r.dropoff_address, r.status, u.first_name, u.last_name
FROM Ride_Requests r
JOIN Users u ON r.user_id = u.user_id;

# Showing all trips and their respective information (driver, vehicle...)

SELECT t.trip_id, t.pickup_address, t.dropoff_address, t.real_distance_km, 
		t.real_price, t.trip_status, d.first_name, d.last_name, d.phone_number,
		v.make, v.model
FROM Trips t
JOIN Drivers d ON t.driver_id = d.driver_id
JOIN Vehicles v ON t.vehicle_id = v.vehicle_id;

# Number of trips each driver has completed 

SELECT d.driver_id, d.first_name, d.last_name, d.license_number, COUNT(t.trip_id)  AS total_trips
FROM Drivers d
LEFT JOIN Trips t ON d.driver_id = t.driver_id
GROUP BY d.driver_id, d.first_name, d.last_name;

# Sum of successful transactions

SELECT SUM(amount) AS total_amount
FROM Transactions 
WHERE transaction_status = 'successful';

# Show averages for ride duration, estimated price, and estimated distance from ride requests

SELECT
	AVG(duration_min) AS average_duration,
	AVG(estimated_price) AS average_price,
	AVG(estimated_distance_km) AS average_distance
FROM Ride_Requests;

# Highest priced trip

SELECT *
FROM Trips
ORDER BY real_price DESC
LIMIT 1;

SELECT * FROM Trips;

# Users with multiple ride requests

SELECT u.user_id, u.first_name, u.last_name, u.email, COUNT(r.request_id) AS number_requests
FROM Users u
JOIN Ride_Requests r ON u.user_id = r.user_id
GROUP BY u.user_id, u.first_name, u.last_name, u.email
HAVING COUNT(r.request_id) > 1;

# Transaction for each individual trip

SELECT t.trip_id, d.first_name AS Driver_First_Name, d.last_name AS Driver_Last_Name, 
t.trip_status, p.transaction_method, p.transaction_status, 
		p.amount
FROM Trips t
JOIN Transactions p ON t.trip_id = p.trip_id
JOIN Drivers d ON t.driver_id = d.driver_id;

























		
		





	
	

	