-- Задача 1: Найти всех сотрудников подчиняющихся Ивану Иванову (EmployeeID = 1)
-- включая подчиненных подчиненных, используя рекурсию
-- отсортировать по имени сотрудника

WITH RECURSIVE subordinates AS (
    -- Базовый случай: сам Иван Иванов
    SELECT e.EmployeeID, e.Name, e.ManagerID, e.DepartmentID, e.RoleID
    FROM Employees e
    WHERE e.EmployeeID = 1

    UNION ALL

    -- Рекурсивный случай: подчинённые
    SELECT e.EmployeeID, e.Name, e.ManagerID, e.DepartmentID, e.RoleID
    FROM Employees e
    INNER JOIN subordinates s ON e.ManagerID = s.EmployeeID
)
SELECT
    s.EmployeeID,
    s.Name AS EmployeeName,
    s.ManagerID,
    d.DepartmentName,
    r.RoleName,
    STRING_AGG(DISTINCT p.ProjectName, ', ' ORDER BY p.ProjectName) AS ProjectNames,
    STRING_AGG(DISTINCT t.TaskName, ', ' ORDER BY t.TaskName) AS TaskNames
FROM subordinates s
JOIN Departments d ON s.DepartmentID = d.DepartmentID
JOIN Roles r ON s.RoleID = r.RoleID
LEFT JOIN Projects p ON s.DepartmentID = p.DepartmentID
LEFT JOIN Tasks t ON s.EmployeeID = t.AssignedTo
GROUP BY s.EmployeeID, s.Name, s.ManagerID, d.DepartmentName, r.RoleName
ORDER BY s.Name;
