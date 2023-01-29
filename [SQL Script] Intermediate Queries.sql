-- 1.  Tulis query untuk mendapatkan jumlah customer tiap bulan yang melakukan order pada tahun 1997.
SELECT MONTH([OrderDate]) AS Month,
	COUNT([CustomerID]) AS [Customer Count]
FROM dbo.Orders
WHERE YEAR([OrderDate]) = 1997
GROUP BY MONTH([OrderDate]);

-- 2. Tulis query untuk mendapatkan nama employee yang termasuk Sales Representative.
SELECT CONCAT([FirstName], ' ', [LastName]) AS EmployeeName, 
	Title
FROM dbo.Employees
WHERE [Title] = 'Sales Representative';

-- 3. Tulis query untuk mendapatkan top 5 nama produk yang quantitynya paling banyak diorder pada bulan Januari 1997.
SELECT TOP 5 p.[ProductName], 
	SUM(od.Quantity) AS [Order Quantity]
FROM dbo.[Order Details] AS od
LEFT JOIN dbo.[Products] AS p
	ON p.ProductID = od.ProductID
LEFT JOIN dbo.[Orders] AS o
	ON od.OrderID = o.OrderID
WHERE o.OrderDate BETWEEN '1997-01-01' AND '1997-01-31'
GROUP BY p.[ProductName]
ORDER BY [Order Quantity] DESC;

-- 4. Tulis query untuk mendapatkan nama company yang melakukan order Chai pada bulan Juni 1997.
SELECT c.CompanyName AS [Customer Name], 
	p.ProductName AS [Product Name], 
	CAST(o.OrderDate AS DATE) AS [Order Date]
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o
	ON c.CustomerID = o.CustomerID
LEFT JOIN dbo.[Order Details] AS od
	ON o.OrderID = od.OrderID
LEFT JOIN dbo.Products AS p
	ON od.ProductID = p.ProductID
WHERE p.ProductName = 'Chai' 
	AND MONTH(OrderDate) = 6 AND YEAR(OrderDate) = 1997;

-- 5. Tulis query untuk mendapatkan jumlah OrderID yang pernah melakukan pembelian (unit_price dikali quantity) 
-- <=100, 100<x<=250, 250<x<=500, dan >500.
WITH cte1 AS(

SELECT OrderID, SUM(Quantity * UnitPrice) AS Purchase,
	CASE WHEN SUM(Quantity * UnitPrice) <= 100 THEN '<=100'
	WHEN SUM(Quantity * UnitPrice) > 100 AND SUM(Quantity * UnitPrice) <= 250 THEN '100<x<250'
	WHEN SUM(Quantity * UnitPrice) > 250 AND SUM(Quantity * UnitPrice) <= 500 THEN '250<x<500'
	ELSE '>500' END AS [Purchase Category]
FROM [Order Details]
GROUP BY OrderID)

SELECT [Purchase Category], COUNT(OrderID) AS [Number of OrderID]
FROM cte1
GROUP BY [Purchase Category]
ORDER BY [Number of OrderID];

-- 6. Tulis query untuk mendapatkan Company name pada tabel customer yang melakukan pembelian di atas 500 pada tahun 1997.
SELECT c.CompanyName, 
	SUM(od.UnitPrice * od.Quantity) AS Purchase
FROM Customers AS c
LEFT JOIN Orders AS o
	ON c.CustomerID = o.CustomerID
LEFT JOIN [Order Details] AS od
	ON o.OrderID = od.OrderID
WHERE od.UnitPrice * od.Quantity > 500 
	AND YEAR(o.OrderDate) = 1997
GROUP BY c.CompanyName
ORDER BY Purchase DESC;

--7. Tulis query untuk mendapatkan nama produk yang merupakan Top 5 sales tertinggi tiap bulan di tahun 1997.
SELECT * FROM
(SELECT MONTH(o.OrderDate) AS Month,
	YEAR(o.OrderDate) AS Year,
	p.ProductName,
	SUM(od.UnitPrice * od.Quantity) AS Sales,
	ROW_NUMBER() OVER(PARTITION BY MONTH(o.OrderDate) 
		ORDER BY SUM(od.UnitPrice * od.Quantity) DESC) AS Rank
FROM Orders AS o
LEFT JOIN [Order Details] AS od ON o.OrderID = od.OrderID
LEFT JOIN Products AS p ON p.ProductID = od.ProductID 
WHERE YEAR(o.OrderDate) = 1997
GROUP BY MONTH(o.OrderDate), 
	YEAR(o.OrderDate), 
	p.ProductName) AS Subquery
WHERE Rank < 6;

-- 8. Buatlah view untuk melihat Order Details yang berisi OrderID, ProductID, ProductName, UnitPrice, Quantity, Discount, Harga setelah diskon.
CREATE VIEW [Order Details View] AS
SELECT od.OrderID, 
	od.ProductID, 
	p.ProductName,
	od.UnitPrice,
	od.Quantity, 
	od.Discount, 
	(od.UnitPrice * od.Quantity - od.Discount) AS [Price After Discount]
FROM [Order Details] od
LEFT JOIN Products p ON od.ProductID = p.ProductID;

-- 9. Buatlah procedure Invoice untuk memanggil CustomerID, CustomerName/company name, OrderID, OrderDate, RequiredDate, 
-- ShippedDate jika terdapat inputan CustomerID tertentu.

WITH cte AS
(SELECT c.CustomerID, 
	c.CompanyName AS [Customer Name], 
	o.OrderID, 
	CAST(o.OrderDate AS DATE) AS [Order Date], 
	CAST(o.RequiredDate AS DATE) AS [Required Date],
	CAST(o.ShippedDate AS DATE) AS [Shipped Date]
FROM Customers AS c
LEFT JOIN Orders AS o ON c.CustomerID = o.CustomerID)

SELECT * FROM cte WHERE CustomerID = 'HANAR';
