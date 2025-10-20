-- Se ejecutan o(n) consultas
CREATE FUNCTION dbo.fn_total(@clave INT)
    RETURNS NUMERIC(12,2)
AS
BEGIN
    DECLARE @TOTAL NUMERIC(12,2)
SELECT @TOTAL = SUM(Quantity * UnitPrice) FROM [Order Details] WHERE OrderID = @clave
    RETURN @TOTAL
END

SELECT dbo.fn_total(10428)

SELECT OrderID,OrderDate, dbo.fn_total(OrderID) AS importe from orders

-- Se ejectua una sola consulta es mejor de manera directa
SELECT
    o.OrderID,
    o.OrderDate,
    sum(Quantity * UnitPrice) as Importe
FROM Orders O
         JOIN [ORDER DETAILS] d on d.OrderID = o.OrderID
GROUP BY o.OrderID, o.OrderDate


CREATE FUNCTION dbo.Ordenes(@emp int)
    RETURNS TABLE
    AS
RETURN( SELECT * FROM Orders WHERE EmployeeID = @emp)
GO
SELECT * FROM dbo.Ordenes(5)

SELECT
    o.OrderID,
    e.FirstName,
    d.UnitPrice,
    d.Quantity
FROM dbo.Ordenes(1) O
         JOIN [Order Details]  d on o.OrderID = d.OrderID
    JOIN Employees e on e.EmployeeID = o.EmployeeID

CREATE FUNCTION dbo.OrdenesAno ( @ano int )
    RETURNS TABLE
    AS
RETURN(
SELECT
    c.CompanyName,
    count(o.orderid) as Total
FROM ORDERS O
RIGHT JOIN customers c on c.CustomerID = o.CustomerID AND
year(o.OrderDate) = @ano
WHERE YEAR(o.OrderDate) = @ano
GROUP BY c.CompanyName
)
GO
SELECT * FROM dbo.OrdenesAno(1996) ORDER BY 1
SELECT * FROM dbo.OrdenesAno(1997) ORDER BY 1
SELECT * FROM dbo.OrdenesAno(1998) ORDER BY 1