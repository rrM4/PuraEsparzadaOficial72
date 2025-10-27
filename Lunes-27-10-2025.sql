-- TRIGGER DISPARADORES, GATILLOS
/*
 SOn procedimientos almacenados especiales que se ejecutan cuando se insertan, actualizan o eliminan registros en una tabla
 detron de un trigger se puede realizar:
 1.- DEclarar variables
 2.- Usar cursores
 3.- Modificiar datos de otras tablas.
 4.- Deshacer la transaccion explicita con ROLLBACK TRAN.
 */

--Creacion
CREATE TRIGGER nombre_trigger
    ON Nombre_tabla
    [WITH ENCRYPTION]
FOR {[DELETE], [,], [INSERT]. [,], [UPTADTE]}
AS
Sentencias sql

-- MODIFICACION
ALTER TRIGGER nombre_trigger
ON Nombre_tabla
FOR {[DELETE], [,], [INSERT], [,], [UPDATE]}
AS
Sentencias sql
-- ELIMINACION
DROP TRIGGER nombre_trigger

CREATE TABLE MATERIALES( clave INT PRIMARY KEY , nombre char(50), precio decimaL(12,2))
    GO
CREATE TRIGGER tr_materiales_ins
    ON Materiales FOR INSERT AS
SELECT 'se ejecuto el trigger de insertar'
SELECT * FROM inserted
    GO
INSERT into materiales VALUES(1, 'Lapiz', 9)
INSERT into materiales VALUES(2, 'Bote', 9)


INSERT MATERIALES
SELECT productid,productname, UnitPrice FROM Products
WHERE ProductID > 2
SELECT * FROM MATERIALES

CREATE TRIGGER tr_materiales_Del
    ON MATERIALES FOR DELETE AS
SELECT ' Se jecuto el trigger al eliminar'
SELECT * FROM deleted
    GO
DELETE MATERIALES WHERE clave = 55
DELETE MATERIALES WHERE clave = 66
DELETE MATERIALES WHERE clave BETWEEN 70 AND 70


CREATE TRIGGER tr_materiales_upd
    oN Materiales for update as
SELECT 'SE jecuto el trigger al actualizar'
SELECT * FROM inserted
SELECT * FROM deleted
    GO
UPDATE MATERIALES SET nombre = 'cepillo', precio = 12 where clave = 25
UPDATE MATERIALES SET nombre = 'Bote', precio = 23 where clave = 15

DROP TRIGGER tr_materiales_upd
DROP TRIGGER tr_materiales_ins
DROP TRIGGER tr_materiales_Del


-- Transacciones, algo se hizo para probar y todos los precios se hicieron 11
-- LO que sea hace es hacer un rollback a la transaccion que se hizo y vuelve todo a la normalidad
BEGIN TRAN
UPDATE Products SET UnitPrice = 111
SELECT ProductID, UnitPrice FROM Products

    ROLLBACK TRAN -- SE DESHACE LA TRANSACCION
COMMIT TRAN -- CON EXITO


--Validar que al actualizar el precio de un material no sea con un precio menor
CREATE TRIGGER tr_materiales_up
    ON MATERIALES FOR UPDATE AS
DECLARE @precioViejo NUMERIC(12,2), @precioNuevo NUMERIC(12,2)

SELECT @precioNuevo = PRECIO FROM inserted
SELECT @precioViejo = PRECIO FROM deleted

                                      IF @precioNuevo < @precioViejo
BEGIN
ROLLBACK TRAN
    RAISERROR ('ERror al actualizar el precio, precio nuevo es menor', 16,1)
end
go
-- No deja
SELECT * FROM MATERIALES WHERE CLAVE = 40
-- Si deja
UPDATE MATERIALES SET PRECIO = 20 WHERE CLAVE = 40