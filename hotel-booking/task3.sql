-- Задача 3: Категоризация отелей и определение предпочтений клиентов
-- Дешевый < 175$, Средний 175-300$, Дорогой > 300$
-- Отсортировать: сначала дешевые, затем средние, затем дорогие

WITH hotel_category AS (
    SELECT
        h.ID_hotel,
        h.name,
        AVG(r.price) AS avg_price,
        CASE
            WHEN AVG(r.price) < 175 THEN 'Дешевый'
            WHEN AVG(r.price) <= 300 THEN 'Средний'
            ELSE 'Дорогой'
        END AS category
    FROM Hotel h
    JOIN Room r ON h.ID_hotel = r.ID_hotel
    GROUP BY h.ID_hotel, h.name
),
customer_hotels AS (
    SELECT
        c.ID_customer,
        c.name,
        hc.category,
        hc.name AS hotel_name
    FROM Customer c
    JOIN Booking b ON c.ID_customer = b.ID_customer
    JOIN Room r ON b.ID_room = r.ID_room
    JOIN hotel_category hc ON r.ID_hotel = hc.ID_hotel
),
customer_preferences AS (
    SELECT
        ID_customer,
        name,
        CASE
            WHEN SUM(CASE WHEN category = 'Дорогой' THEN 1 ELSE 0 END) > 0 THEN 'Дорогой'
            WHEN SUM(CASE WHEN category = 'Средний' THEN 1 ELSE 0 END) > 0 THEN 'Средний'
            ELSE 'Дешевый'
        END AS preferred_hotel_type,
        STRING_AGG(DISTINCT hotel_name, ',' ORDER BY hotel_name) AS visited_hotels
    FROM customer_hotels
    GROUP BY ID_customer, name
)
SELECT
    ID_customer,
    name,
    preferred_hotel_type,
    visited_hotels
FROM customer_preferences
ORDER BY
    CASE preferred_hotel_type
        WHEN 'Дешевый' THEN 1
        WHEN 'Средний' THEN 2
        WHEN 'Дорогой' THEN 3
    END,
    ID_customer;
