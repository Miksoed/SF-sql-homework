-- Задача 3: Определить какие автомобили из каждого класса
-- имеют наименьшую среднюю позицию в гонках,
-- отсортировать по средней позиции

SELECT
    ca.name AS car_name,
    ca.class AS car_class,
    AVG(r.position) AS average_position,
    COUNT(r.race) AS race_count
FROM Cars ca
JOIN Results r ON ca.name = r.car
GROUP BY ca.name, ca.class
HAVING AVG(r.position) = (
    SELECT MIN(avg_pos)
    FROM (
        SELECT ca2.class, AVG(r2.position) AS avg_pos
        FROM Cars ca2
        JOIN Results r2 ON ca2.name = r2.car
        WHERE ca2.class = ca.class
        GROUP BY ca2.name
    ) AS class_avgs
)
ORDER BY average_position ASC;
