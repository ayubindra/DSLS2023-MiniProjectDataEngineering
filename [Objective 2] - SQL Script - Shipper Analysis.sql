SELECT o.OrderID,
	p.ProductName AS Product, 
	c.CategoryName AS Category, 
	od.Quantity, 
	o.RequiredDate, 
	o.ShippedDate, 
	DATEDIFF(Day, o.ShippedDate, o.RequiredDate) AS DayDiff, 
	o.Freight, 
	s.CompanyName AS [Shipper Company],
	o.ShipName, o.ShipCity, o.ShipCountry
INTO [Shipper Analysis]
FROM Orders AS o
LEFT JOIN [Order Details] AS od ON o.OrderID = od.OrderID
LEFT JOIN Products AS p ON od.ProductID = p.ProductID
LEFT JOIN Shippers AS s ON s.ShipperID = o.ShipVia
LEFT JOIN Categories AS c ON c.CategoryID = p.CategoryID
WHERE o.ShippedDate IS NOT NULL;