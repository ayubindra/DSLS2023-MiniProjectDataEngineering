SELECT o.OrderID,
	CAST(o.OrderDate AS date) AS [Order Date], 
	CAST(o.ShippedDate AS date) AS [Shipped Date], 
	c.CompanyName AS [Customer Name],
	c.Country,
	p.ProductName AS [Product Name],
	ca.CategoryName AS [Product Category],
	od.Quantity AS [Unit Sold],
	(od.Quantity * od.UnitPrice - od.Discount) AS [Sales]
INTO [dbo].[RFM Analysis]
FROM Orders o
LEFT JOIN Customers c ON o.CustomerID = c.CustomerID
LEFT JOIN [Order Details] od ON o.OrderID = od.OrderID
LEFT JOIN Products p ON p.ProductID = od.ProductID
LEFT JOIN Categories ca ON ca.CategoryID = p.CategoryID
WHERE o.OrderDate IS NOT NULL AND 
	YEAR(o.OrderDate) = 1997;