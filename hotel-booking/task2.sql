-- Задача 2: Найти клиентов с более чем двумя бронированиями
-- в разных отелях и тратами более 500 долларов,
-- отсортировать по общей сумме по возрастанию

WITH many_bookings AS (
    SELECT
        c.ID_customer,
        c.name,
        COUNT(b.ID_booking) AS total_bookings,
        COUNT(DISTINCT h.ID_hotel) AS unique_hotels,
        SUM(r.price * (b.check_out_date - b.check_in_date)) AS total_spent
    FROM Customer c
    JOIN Booking b ON c.ID_customer = b.ID_customer
    JOIN Room r ON b.ID_room = r.ID_room
    JOIN Hotel h ON r.ID_hotel = h.ID_hotel
    GROUP BY c.ID_customer, c.name
    HAVING COUNT(b.ID_booking) > 2
       AND COUNT(DISTINCT h.ID_hotel) > 1
),
high_spenders AS (
    SELECT
        c.ID_customer,
        c.name,
        SUM(r.price * (b.check_out_date - b.check_in_date)) AS total_spent,
        COUNT(b.ID_booking) AS total_bookings
    FROM Customer c
    JOIN Booking b ON c.ID_customer = b.ID_customer
    JOIN Room r ON b.ID_room = r.ID_room
    GROUP BY c.ID_customer, c.name
    HAVING SUM(r.price * (b.check_out_date - b.check_in_date)) > 500
)
SELECT
    mb.ID_customer,
    mb.name,
    mb.total_bookings,
    mb.total_spent,
    mb.unique_hotels
FROM many_bookings mb
INNER JOIN high_spenders hs ON mb.ID_customer = hs.ID_customer
ORDER BY mb.total_spent ASC;
