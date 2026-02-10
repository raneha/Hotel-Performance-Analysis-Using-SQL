CREATE DATABASE IF NOT EXISTS hotel_performance;
USE hotel_performance;

CREATE TABLE IF NOT EXISTS dim_date (
    date DATE PRIMARY KEY,
    mmm_yy VARCHAR(10),
    week_no INT,
    day_type VARCHAR(10) 
);

CREATE TABLE IF NOT EXISTS dim_hotels (
    property_id INT PRIMARY KEY,
    property_name VARCHAR(100),
    category VARCHAR(50),
    city VARCHAR(50)
);

CREATE TABLE dim_rooms (
    room_id VARCHAR(10) PRIMARY KEY,
    room_class VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS fact_aggregated_bookings (
    property_id INT,
    check_in_date DATE,
    room_category VARCHAR(30),
    successful_bookings INT,
    capacity INT,
    FOREIGN KEY (property_id) REFERENCES dim_hotels(property_id),
    FOREIGN KEY (check_in_date) REFERENCES dim_date(date)
);

CREATE TABLE IF NOT EXISTS fact_bookings (
    booking_id VARCHAR(50) PRIMARY KEY,
    property_id INT,
    booking_date DATE,
    check_in_date DATE,
    checkout_date DATE,
    no_guests INT,
    room_category VARCHAR(30),
    booking_platform VARCHAR(50),
    ratings_given DECIMAL(3,1),
    booking_status VARCHAR(20),
    revenue_generated DECIMAL(10,2),
    revenue_realized DECIMAL(10,2),
    FOREIGN KEY (property_id) REFERENCES dim_hotels(property_id),
    FOREIGN KEY (check_in_date) REFERENCES dim_date(date)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/dim_date.csv'
INTO TABLE dim_date
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@date, mmm_yy, @week_no, day_type)
SET
date = @date,
week_no = CAST(REPLACE(@week_no, 'W ', '') AS UNSIGNED);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/dim_hotels.csv'
INTO TABLE dim_hotels
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(property_id, property_name, category, city);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/dim_rooms.csv'
INTO TABLE dim_rooms
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(room_id, room_class);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/fact_aggregated_bookings.csv'
INTO TABLE fact_aggregated_bookings
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(property_id, check_in_date, room_category, successful_bookings, capacity);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/fact_bookings.csv'
INTO TABLE fact_bookings
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
 booking_id,
 property_id,
 booking_date,
 check_in_date,
 checkout_date,
 no_guests,
 room_category,
 booking_platform,
 @ratings_given,
 booking_status,
 revenue_generated,
 revenue_realized
)
SET
ratings_given = NULLIF(@ratings_given, '');


SELECT *FROM dim_date;
SELECT *FROM dim_hotels;
SELECT *FROM dim_rooms;
SELECT *FROM fact_aggregated_bookings;
SELECT *FROM fact_bookings;
