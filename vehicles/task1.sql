-- Задача 1: Найти производителей и модели мотоциклов
-- с мощностью > 150 л.с., ценой < 20000$ и типом Sport
-- отсортировать по мощности по убыванию

SELECT v.maker, v.model
FROM Vehicle v
JOIN Motorcycle m ON v.model = m.model
WHERE m.horsepower > 150
  AND m.price < 20000
  AND m.type = 'Sport'
ORDER BY m.horsepower DESC;
