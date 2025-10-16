-- PARA ESTE EJEMPLO ESTAMOS USANDO LA BASE DE DATOS NORTHWIND

-- constid: clave de la restriccion
-- rkeyid: clave de la tabla padre
-- rkey: posicion de la columna en la tabla padre
-- fkeyid: clave de la tabla hijo
-- fkey: posicion de la columna en la tabla hija

SELECT
    nombreFk = constid,
    tablaPadre = rkeyid,
    columnaPadre = rkey,
    tablaHijo = fkeyid,
    columnaHija = fkey
FROM sys.sysforeignkeys


SELECT
    nombreFK = object_name(constid),
    TablaPadre = object_name(rkeyid),
    columnaPadre = rkey,
    TablaHijo = object_name(fkeyid),
    columnaHija = fkey
FROM sys.sysforeignkeys

select
    id,
    colorder,
    name
from sys.syscolumns
WHERE object_id('Products') = id

-- restriciones donde productos es hijo
SELECT
    nombreFK = object_name(constid),
    Padre = object_name(rkeyid),
    columnaPadre = rkey,
    Hijo = object_name(fkeyid),
    columnaHija = fkey
FROM sys.sysforeignkeys
WHERE fkeyid = OBJECT_ID('Products')

-- Restricicones donde productos es padre
SELECT
    nombreFK = object_name(constid),
    Padre = object_name(rkeyid),
    columnaPadre = rkey,
    Hijo = object_name(fkeyid),
    columnaHija = fkey
FROM sys.sysforeignkeys
WHERE rkeyid = OBJECT_ID('Products')

--Obtener la tablas que nunca seran padre, son las tablas centrales
select
    id,
    name
from sys.sysobjects
WHERE
    xtype = 'u' AND
    id NOT IN (select rkeyid from sys.sysforeignkeys) AND
    name NOT LIKE 'sys%' AND
    name NOT LIKE 'ms%'
ORDER BY id

-- agarramos una tabla central y se agregan a sus padres
SELECT
    nombreFK = object_name(constid),
    Padre = object_name(rkeyid),
    Hijo = object_name(fkeyid)
FROM  sys.sysforeignkeys
WHERE fkeyid = OBJECT_ID('order details')


-- TIpos de funciones definidas por los usuarios
-- Sql utiliza tres tipos de funcines:
--1 Las funciones escalares
--2 Tabla en linea
--3 .funciones en tabla
/*
Los tres tipos de funciones aceptan parametros de cualquier tipo excepto el rowversion
las funciones escalares devuelven un solo valor, tabla en linea, multisentencias devuelven
un tipo de tabla

Limitaciones
Las funciones definidas por el usuario tienen algunas restricciones. No todas las sentencias sql son
validas dentro de una funcion

Invalidas:
-Sentencias de modificaciones o actualizacion de tablas o vistas sobre tablas de usuario
(Update, delete, insert)
_ Opereaciones cursos fetch que devuelven datos del cliente
-No se pueden utilizar procedimientos almacenados dentro de la funcion
-No se puede utilizar tablas temporales

Valido
-Las sentencias de asignacion
-Las sentencias de control de flujo while, if
-Sentencias select y modificacion de variables locales
-Operaciones de cursores sobre variables locales
-Sentencias INSERT, UPDATE, DELETE Con variables Locales tipo Tabla.


1.- FUnciones escalares
Las funciones escalares devuelven un tipo de los datos tal como int, money,varchar,real,etc.
Pueden ser utilizadas en cualquier lugar incluso incorporada dentro de sentencias SQL.

La sintaxis para una funcion escalar es la siguiente:
CREATE FUNCTION [NombrePropietario]NombreFuncion
(@nombreParametro TipoDato [= default], ...)
RETURNS TipoDeDatoRetorno
AS
BEGIN
    CuerpoFuncion

    RETURN ValorRetorno
END

--Funcion que calucle el cubo de un numero
*/

CREATE FUNCTION dbo.Cubo(@num numeric(12,2))
    RETURNS numeric(12,2)
AS
BEGIN
    RETURN( @num * @num * @num)
END
GO
--Ejecucion TIENE QUE SER CON DBO SI NO NO SERA UNA FUNCION RECONOCIDA
SELECT dbo.Cubo(3) AS resultado

DECLARE @R numeric(12,2);
SELECT @R = dbo.cubo(3)
SELECT @R AS resultado

-- Nombre y precio del producto al cubo
SELECT
    productname,
    dbo.cubo(UnitPrice) AS precioAlCubo
FROM Products