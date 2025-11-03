
-- AGREGAMOS EL CAMPO CONTADOR PARA LLEVAR EL NUMERO DE ACTUALIZACIONES
ALTER TABLE MATERIALES add contador INT
UPDATE MATERIALES set CONTADOR = 0
ALTER TABLE MATERIALES ADD CONSTRAINT df_mat_contador DEFAULT(0) FOR contador

CREATE TRIGGER tr_materiales_conta
    ON materiales for update as
DECLARE @CLAVE INT, @CONTA INT

SELECT @CLAVE = CLAVE, @CONTA = ISNULL(CONTADOR,0) FROM inserted

                                                            if update(nombre)
BEGIN
    IF @CONTA > 0
BEGIN
ROLLBACK TRAN
        RAISERROR ('No se puede actualizar mas de una vez el nombre', 16,1)
end
ELSE
UPDATE MATERIALES SET CONTADOR = @CONTA + 1 WHERE clave = @CLAVE
end

INSERT MATERIALES(clave,nombre,precio) VALUES(101,'Bolsa', 183)
SELECT * FROM MATERIALES WHERE clave = 101
-- Actualizamos el precio y verificamos que el campo conta no aumenta
UPDATE MATERIALES SET precio = PRECIO + 2 WHERE clave = 101
-- SI se puede
UPDATE MATERIALES SET nombre = 'BOlsas roja' where clave = 101
-- Ya no se permite actualizar una segunda vez
UPDATE MATERIALES SET nombre = 'Bolsas roja' WHERE CLAVE = 101

select * from MATERIALES where clave = 101


--LA TABLA CLIENTES TIENE UN CAMPO LLAMADO IMPORTE (TOTAL DE VENTAS) QUE
-- REPRESENTA EL IMPORTE TOTAL DE VENTAS DE DICHO CLIENTE, CREAR LOS TRIGGER NECESARIOS QUE ACTUALIZE DICHO CONTENIDO
-- SOLUCION CON SP
ALTER TABLE Customers ADD ImporteTotal NUMERIC(12,2)
    GO
CREATE OR ALTER PROC sp_importe AS
DECLARE @Clave CHAR(5), @Importe NUMERIC(12,2)

SELECT @clave = min(CustomerID) FROM Customers
                                         WHILE @Clave IS NOT NULL
BEGIN
SELECT @Importe = sum(Quantity * UnitPrice)
FROM [Order Details] d
    INNER JOIN Orders o  ON d.OrderID = o.OrderID
WHERE O.CustomerID = @Clave

UPDATE Customers SET ImporteTotal = @Importe WHERE CustomerID = @Clave
SELECT @Clave = MIN(CustomerID) FROM Customers WHERE CustomerID > @Clave
end

--1 Buscamos la clave de la orden
--2 Buscar la clave del cliente de la orden encontrada en el punto 1
--3 calculo el importe total de nicho cliente en la tabla order details
--4 actualizo el campo importe en la tabla clientes del cliente

CREATE TRIGGER tr_ActualizaImporteCte ON [Order Details]
FOR INSERT,UPDATE ,DELETE  AS
DECLARE @clave INT, @cte NCHAR(5), @total NUMERIC(12,2)

--1.- Buscar la clave de la orden
IF(SELECT COUNT(*) FROM INSERTED) > 0
SELECT @clave = OrderID from inserted
    ELSE
SELECT @clave = OrderID from deleted

-- 2 Busco la clave del cliente
SELECT @cte = CustomerID FROM Orders WHERE OrderID = @Clave
--3 Calculo el importe total de dicho cliente
SELECT @total = sum(od.unitprice * od.quantity)
FROM Orders o
         JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE o.CustomerID = @cte

-- 4 Actualizo el campo importe en la tabla de clientes
UPDATE Customers SET ImporteTotal = isnull(@total,0) WHERE CustomerID = @cte
    GO
