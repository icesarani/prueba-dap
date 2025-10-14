SELECT
    d.DepartmentName,
    e.EmployeeName,
    e.Salary,
    ROUND(AVG(e2.Salary), 2) AS DeptAvgSalary
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
INNER JOIN Employees e2 ON e.DepartmentID = e2.DepartmentID
GROUP BY d.DepartmentName, e.EmployeeName, e.Salary, e.DepartmentID
HAVING e.Salary > AVG(e2.Salary)
ORDER BY d.DepartmentName, e.Salary DESC;
