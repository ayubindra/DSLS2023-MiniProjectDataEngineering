SELECT o.OrderID, 
	CAST(o.OrderDate AS DATE) AS [Order Date], 
	p.ProRductName AS [Product Name], 
	od.Quantity AS [Unit Sold], 
	p.UnitPrice AS [Unit Price],
	c.CategoryName AS Category, 
	s.CompanyName AS [Supplier Name], 
	s.City AS [Supplier City], 
	s.Country AS [Supplier Country],
	p.UnitsInStock AS [Units In Stock], 
	p.UnitsOnOrder AS [Units On Order], 
--	p.ReorderLevel AS [Reorder Level]
INTO [Supplier Analysis]
FROM [Order Details] AS od
LEFT JOIN Orders AS o ON o.OrderID = od.OrderID
LEFT JOIN Products AS p ON p.ProductID = od.ProductID
LEFT JOIN Categories AS c ON p.CategoryID = c.CategoryID
LEFT JOIN Suppliers AS s ON p.SupplierID = s.SupplierID
WHERE o.OrderDate IS NOT NULL AND o.OrderID IS NOT NULL;