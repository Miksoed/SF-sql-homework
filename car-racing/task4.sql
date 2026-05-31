-- Задача 4: Определить автомобиль с наименьшей средней позицией
-- среди всех автомобилей, включая страну производства.
-- При одинаковой позиции выбрать по алфавиту.

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
HAVING AVG(r.position) = (
    SELECT MIN(avg_pos)
    FROM (
        SELECT AVG(position) AS avg_pos
        FROM Results
        GROUP BY car
    ) AS all_avgs
)
ORDER BY ca.name ASC
LIMIT 1;
