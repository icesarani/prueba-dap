SELECT TOP 5
    c.CustomerName,
    c.Email,
    ROUND(SUM(od.Quantity * od.UnitPrice), 2) AS TotalRevenue
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
WHERE o.Status = 'Completed'
GROUP BY c.CustomerName, c.Email
ORDER BY TotalRevenue DESC;
