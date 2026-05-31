-- Задача 5: Определить классы автомобилей с наибольшим количеством
-- автомобилей с низкой средней позицией (больше 3.0)
-- отсортировать по количеству таких автомобилей

WITH car_avgs AS (
    SELECT
        ca.name AS car_name,
        ca.class AS car_class,
        AVG(r.position) AS average_position,
        COUNT(r.race) AS race_count,
        cl.country AS car_country
    FROM Cars ca
    JOIN Results r ON ca.name = r.car
    JOIN Classes cl ON ca.class = cl.class
    GROUP BY ca.name, ca.class, cl.country
),
class_stats AS (
    SELECT
        car_class,
        COUNT(*) FILTER (WHERE average_position > 3.0) AS low_position_count,
        SUM(race_count) AS total_races
    FROM car_avgs
    GROUP BY car_class
),
max_low AS (
    SELECT MAX(low_position_count) AS max_count
    FROM class_stats
    WHERE low_position_count > 0
)
SELECT
    a.car_name,
    a.car_class,
    a.average_position,
    a.race_count,
    a.car_country,
    s.total_races,
    s.low_position_count
FROM car_avgs a
JOIN class_stats s ON a.car_class = s.car_class
JOIN max_low m ON s.low_position_count = m.max_count
WHERE a.average_position > 3.0
ORDER BY s.low_position_count DESC, a.car_class, a.car_name;
