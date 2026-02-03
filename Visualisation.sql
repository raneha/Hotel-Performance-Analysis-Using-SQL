USE hotel_performance;

-- Total Revenue
SELECT 
    ROUND(SUM(revenue_realized),0) AS Total_Revenue
FROM fact_bookings
WHERE booking_status = 'Checked Out';

-- Occupancy Percentage
SELECT
    ROUND(
        SUM(successful_bookings) * 100.0 / SUM(capacity),
        2
    ) AS Occupancy_Percentage
FROM fact_aggregated_bookings;

-- Cancellation Rate
SELECT
    ROUND(
        SUM(CASE 
            WHEN booking_status IN ('Cancelled', 'No Show') THEN 1 
            ELSE 0 
        END) * 100.0 / COUNT(*),
        2
    ) AS Cancellation_Rate
FROM fact_bookings;

-- Total Bookings
SELECT 
    COUNT(booking_id) AS Total_Bookings
FROM fact_bookings;

-- Utilized Capacity
SELECT
    SUM(successful_bookings) AS Utilized_Capacity
FROM fact_aggregated_bookings;

-- Revenue Trend
SELECT
    d.date,
    ROUND(SUM(f.revenue_realized),0) AS Daily_Revenue
FROM fact_bookings f
JOIN dim_date d 
    ON f.check_in_date = d.date
WHERE f.booking_status = 'Checked Out'
GROUP BY d.date
ORDER BY d.date;

-- Weekday vs Weekend Analysis
SELECT
    d.day_type AS Day_Type,
    COUNT(f.booking_id) AS Total_Bookings,
    ROUND(SUM(f.revenue_realized),0) AS Total_Revenue
FROM fact_bookings f
JOIN dim_date d 
    ON f.check_in_date = d.date
WHERE f.booking_status = 'Checked Out'
GROUP BY d.day_type;

-- Revenue by City & Hotel
SELECT
    h.city,
    h.property_name AS Property_Name,
    ROUND(SUM(f.revenue_realized),0) AS Revenue
FROM fact_bookings f
JOIN dim_hotels h 
    ON f.property_id = h.property_id
WHERE f.booking_status = 'Checked Out'
GROUP BY h.city, h.property_name
ORDER BY revenue DESC;

-- Class-wise Revenue Performance
SELECT
    room_category AS Room_Category,
    ROUND(SUM(revenue_realized),0) AS Total_Revenue
FROM fact_bookings
WHERE booking_status = 'Checked Out'
GROUP BY room_category
ORDER BY total_revenue DESC;

-- Booking Status Distribution
SELECT
    booking_status AS Booking_Status,
    COUNT(*) AS Bookings_Count
FROM fact_bookings
GROUP BY booking_status;

-- Weekly Trends
SELECT
    d.week_no,
    COUNT(f.booking_id) AS Total_Bookings,
    SUM(f.revenue_realized) AS Total_Revenue,
    ROUND(
        SUM(a.successful_bookings) * 100.0 / SUM(a.capacity),
        2
    ) AS occupancy_percentage
FROM dim_date d
LEFT JOIN fact_bookings f 
    ON d.date = f.check_in_date 
    AND f.booking_status = 'Checked Out'
LEFT JOIN fact_aggregated_bookings a 
    ON d.date = a.check_in_date
GROUP BY d.week_no
ORDER BY d.week_no;