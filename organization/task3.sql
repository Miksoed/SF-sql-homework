-- Задача 3: Найти всех сотрудников с ролью Менеджер у которых есть подчиненные
-- включая общее количество всех подчиненных (рекурсивно)
-- отсортировать по EmployeeID

WITH RECURSIVE all_subordinates AS (
    -- Базовый случай: все сотрудники как потенциальные менеджеры
    SELECT e.EmployeeID, e.ManagerID, e.EmployeeID AS RootID
    FROM Employees e

    UNION ALL

    -- Рекурсивный случай: спускаемся по иерархии
    SELECT e.EmployeeID, e.ManagerID, s.RootID
    FROM Employees e
    INNER JOIN all_subordinates s ON e.ManagerID = s.EmployeeID
    WHERE e.EmployeeID != s.RootID
)
SELECT
    e.EmployeeID,
    e.Name AS EmployeeName,
    e.ManagerID,
    d.DepartmentName,
    r.RoleName,
    STRING_AGG(DISTINCT p.ProjectName, ', ' ORDER BY p.ProjectName) AS ProjectNames,
    STRING_AGG(DISTINCT t.TaskName, ', ' ORDER BY t.TaskName) AS TaskNames,
    COUNT(DISTINCT sub.EmployeeID) AS TotalSubordinates
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
JOIN Roles r ON e.RoleID = r.RoleID
LEFT JOIN Projects p ON e.DepartmentID = p.DepartmentID
LEFT JOIN Tasks t ON e.EmployeeID = t.AssignedTo
LEFT JOIN all_subordinates sub ON sub.RootID = e.EmployeeID AND sub.EmployeeID != e.EmployeeID
WHERE r.RoleName = 'Менеджер'
GROUP BY e.EmployeeID, e.Name, e.ManagerID, d.DepartmentName, r.RoleName
HAVING COUNT(DISTINCT sub.EmployeeID) > 0
ORDER BY e.EmployeeID;
