-- =================================================================================
-- SCRIPT PARA MINIMARKET DOÑA MARTA
-- Este script crea la estructura de la base de datos, aplica reglas de negocio,
-- puebla tablas iniciales y genera los informes solicitados.
-- =================================================================================

-- ***********************************************************************************
-- 1. LIMPIEZA DE TABLAS
-- ***********************************************************************************

DROP TABLE DETALLE_VENTA CASCADE CONSTRAINTS;;
DROP TABLE VENTA CASCADE CONSTRAINTS;;
DROP TABLE PROVEEDOR CASCADE CONSTRAINTS;;
DROP TABLE PRODUCTO CASCADE CONSTRAINTS;;
DROP TABLE MARCA CASCADE CONSTRAINTS;;
DROP TABLE CATEGORIA CASCADE CONSTRAINTS;;
DROP TABLE VENDEDOR CASCADE CONSTRAINTS;;
DROP TABLE ADMINISTRATIVO CASCADE CONSTRAINTS;;
DROP TABLE EMPLEADO CASCADE CONSTRAINTS;;
DROP TABLE AFP CASCADE CONSTRAINTS;;
DROP TABLE SALUD CASCADE CONSTRAINTS;;
DROP TABLE MEDIO_PAGO CASCADE CONSTRAINTS;;
DROP TABLE COMUNA CASCADE CONSTRAINTS;;
DROP TABLE REGION CASCADE CONSTRAINTS;;


-- ***********************************************************************************
-- 2. CREACIÓN DE TABLAS (SIN CONSTRAINTS PK/FK INICIALES)
-- Se crean las tablas fuertes primero, seguidas de las débiles.
-- Se usa IDENTITY para AFP e VENTA según las consideraciones del caso 1.
-- ***********************************************************************************

CREATE TABLE REGION (
    id_region       NUMBER(4) NOT NULL,
    nombre_region   VARCHAR2(255) NOT NULL
);

CREATE TABLE COMUNA (
    id_comuna       NUMBER(4) NOT NULL,
    nombre_comuna   VARCHAR2(100) NOT NULL,
    cod_region      NUMBER(4) NOT NULL
);

CREATE TABLE MEDIO_PAGO (
    id_mpago        NUMBER(3) NOT NULL,
    nombre_mpago    VARCHAR2(50) NOT NULL
);

CREATE TABLE SALUD (
    id_salud        NUMBER(4) NOT NULL,
    nom_salud       VARCHAR2(40)NOT NULL
);

CREATE TABLE AFP (
    id_afp          NUMBER(4) GENERATED ALWAYS AS IDENTITY (START WITH 210 INCREMENT BY 6) NOT NULL,
    nom_afp         VARCHAR2(255) NOT NULL
);

CREATE TABLE EMPLEADO (
    id_empleado     NUMBER(4) NOT NULL,
    rut_empleado    VARCHAR2(10) NOT NULL,
    nombre_empleado VARCHAR2(25) NOT NULL,
    apellido_paterno VARCHAR2(25) NOT NULL,
    apellido_materno VARCHAR2(25) NOT NULL,
    fecha_contratacion DATE NOT NULL,
    sueldo_base     NUMBER(10) NOT NULL,
    bono_jefatura   NUMBER(10),
    activo          CHAR(1) NOT NULL,
    tipo_empleado   VARCHAR2(25) NOT NULL,
    cod_empleado    NUMBER(4),
    cod_salud       NUMBER(4) NOT NULL,
    cod_afp         NUMBER(5) NOT NULL
);

CREATE TABLE VENDEDOR (
    id_empleado     NUMBER(4) NOT NULL,
    comision_venta  NUMBER(5,2) NOT NULL
);

CREATE TABLE ADMINISTRATIVO (
    id_empleado     NUMBER(4) NOT NULL
);

CREATE TABLE CATEGORIA (
    id_categoria    NUMBER(3) NOT NULL,
    nombre_categoria VARCHAR2(255) NOT NULL
);

CREATE TABLE MARCA (
    id_marca        NUMBER(3) NOT NULL,
    nombre_marca    VARCHAR2(25) NOT NULL
);

CREATE TABLE PROVEEDOR (
    id_proveedor    NUMBER(5) NOT NULL,
    nombre_proveedor VARCHAR2 (150) NOT NULL, 
    rut_proveedor   VARCHAR2(10) NOT NULL,
    telefono        VARCHAR2(10) NOT NULL,
    email           VARCHAR2(200) NOT NULL,
    direccion       VARCHAR2(200) NOT NULL,
    cod_comuna      NUMBER(4) NOT NULL
);

CREATE TABLE PRODUCTO (
    id_producto     NUMBER(4) NOT NULL,
    nombre_producto VARCHAR2(100) NOT NULL,
    precio_unitario NUMBER(8) NOT NULL,
    origen_nacional CHAR(1) NOT NULL,
    stock_minimo    NUMBER(3) NOT NULL,
    activo          CHAR(1) NOT NULL, 
    cod_marca       NUMBER(3) NOT NULL,
    cod_categoria   NUMBER(3) NOT NULL,
    cod_proveedor   NUMBER(5) NOT NULL
);

CREATE TABLE VENTA (
    id_venta        NUMBER(4) GENERATED ALWAYS AS IDENTITY (START WITH 5050 INCREMENT BY 3) NOT NULL,
    fecha_venta     DATE NOT NULL,
    total_venta     NUMBER(10) NOT NULL,
    cod_mpago       NUMBER(3) NOT NULL,
    cod_empleado    NUMBER(4) NOT NULL
);

-- se agrega a esta tabla un campo que no está en modelo "detalle_valor"
CREATE TABLE DETALLE_VENTA (
    cod_venta       NUMBER(4) NOT NULL,
    cod_producto    NUMBER(4) NOT NULL,
    cantidad        NUMBER(6),
    detalle_valor   NUMBER(10) NOT NULL 
);

-- ***********************************************************************************
-- 3. ASIGNACIÓN DE CONSTRAINTS (PK, FK, UN, CK)
-- Se asignan las restricciones solicitadas, usando ALTER TABLE
-- ***********************************************************************************

-- 3.1. CLAVES PRIMARIAS (PK)

ALTER TABLE REGION ADD CONSTRAINT PK_REGION PRIMARY KEY (id_region);
ALTER TABLE COMUNA ADD CONSTRAINT PK_COMUNA PRIMARY KEY (id_comuna);
ALTER TABLE MEDIO_PAGO ADD CONSTRAINT PK_MEDIO_PAGO PRIMARY KEY (id_mpago);
ALTER TABLE SALUD ADD CONSTRAINT PK_SALUD PRIMARY KEY (id_salud);
ALTER TABLE AFP ADD CONSTRAINT PK_AFP PRIMARY KEY (id_afp);
ALTER TABLE EMPLEADO ADD CONSTRAINT PK_EMPLEADO PRIMARY KEY (id_empleado);
ALTER TABLE VENDEDOR ADD CONSTRAINT PK_VENDEDOR PRIMARY KEY (id_empleado);
ALTER TABLE ADMINISTRATIVO ADD CONSTRAINT PK_ADMINISTRATIVO PRIMARY KEY (id_empleado);
ALTER TABLE CATEGORIA ADD CONSTRAINT PK_CATEGORIA PRIMARY KEY (id_categoria);
ALTER TABLE MARCA ADD CONSTRAINT PK_MARCA PRIMARY KEY (id_marca);
ALTER TABLE PROVEEDOR ADD CONSTRAINT PK_PROVEEDOR PRIMARY KEY (id_proveedor);
ALTER TABLE PRODUCTO ADD CONSTRAINT PK_PRODUCTO PRIMARY KEY (id_producto);
ALTER TABLE VENTA ADD CONSTRAINT PK_VENTA PRIMARY KEY (id_venta);
ALTER TABLE DETALLE_VENTA ADD CONSTRAINT PK_DETALLE_VENTA PRIMARY KEY (cod_venta, cod_producto);

-- 3.2. CLAVES FORÁNEAS (FK)

-- COMUNA
ALTER TABLE COMUNA ADD CONSTRAINT FK_COMUNA_REGION FOREIGN KEY (cod_region) REFERENCES REGION (id_region);

-- EMPLEADO
ALTER TABLE EMPLEADO ADD CONSTRAINT FK_EMPLEADO_SALUD FOREIGN KEY (cod_salud) REFERENCES SALUD (id_salud);
ALTER TABLE EMPLEADO ADD CONSTRAINT FK_EMPLEADO_AFP FOREIGN KEY (cod_afp) REFERENCES AFP (id_afp);
ALTER TABLE EMPLEADO ADD CONSTRAINT FK_EMPLEADO_JEFE FOREIGN KEY (cod_empleado) REFERENCES EMPLEADO (id_empleado);

-- VENDEDOR / ADMINISTRATIVO
ALTER TABLE VENDEDOR ADD CONSTRAINT FK_VENDEDOR_EMPLEADO FOREIGN KEY (id_empleado) REFERENCES EMPLEADO (id_empleado);
ALTER TABLE ADMINISTRATIVO ADD CONSTRAINT FK_ADMIN_EMPLEADO FOREIGN KEY (id_empleado) REFERENCES EMPLEADO (id_empleado);

-- PROVEEDOR
ALTER TABLE PROVEEDOR ADD CONSTRAINT FK_PROVEEDOR_COMUNA FOREIGN KEY (cod_comuna) REFERENCES COMUNA (id_comuna); 

-- PRODUCTO
ALTER TABLE PRODUCTO ADD CONSTRAINT FK_PRODUCTO_MARCA FOREIGN KEY (cod_marca) REFERENCES MARCA (id_marca);
ALTER TABLE PRODUCTO ADD CONSTRAINT FK_PRODUCTO_CATEGORIA FOREIGN KEY (cod_categoria) REFERENCES CATEGORIA (id_categoria);
ALTER TABLE PRODUCTO ADD CONSTRAINT FK_PRODUCTO_PROVEEDOR FOREIGN KEY (cod_proveedor) REFERENCES PROVEEDOR (id_proveedor);

-- VENTA
ALTER TABLE VENTA ADD CONSTRAINT FK_VENTA_MEDIO_PAGO FOREIGN KEY (cod_mpago) REFERENCES MEDIO_PAGO (id_mpago);
ALTER TABLE VENTA ADD CONSTRAINT FK_VENTA_EMPLEADO FOREIGN KEY (cod_empleado) REFERENCES EMPLEADO (id_empleado);

-- DETALLE_VENTA
ALTER TABLE DETALLE_VENTA ADD CONSTRAINT FK_DETALLE_VENTA_VENTA FOREIGN KEY (cod_venta) REFERENCES VENTA (id_venta);
ALTER TABLE DETALLE_VENTA ADD CONSTRAINT FK_DETALLE_VENTA_PRODUCTO FOREIGN KEY (cod_producto) REFERENCES PRODUCTO (id_producto);


-- ***********************************************************************************
-- CASO 2
-- REGLAS DE NEGOCIO (Restricciones CHECK y UNIQUE)
-- Se implementan las restricciones adicionales solicitadas en el caso 2
-- ***********************************************************************************

-- EMPLEADO: Sueldo base no menor a $400.000
ALTER TABLE EMPLEADO ADD CONSTRAINT CK_EMPLEADO_SUELDO_BASE CHECK (sueldo_base >= 400000);

-- VENDEDOR: Comisión entre 0 y 0.25 (25%)
ALTER TABLE VENDEDOR ADD CONSTRAINT CK_VENDEDOR_COMISION CHECK (comision_venta BETWEEN 0 AND 0.25);

-- PRODUCTO: Stock mínimo de al menos 3 unidades
ALTER TABLE PRODUCTO ADD CONSTRAINT CK_PRODUCTO_STOCK_MINIMO CHECK (stock_minimo >= 3);

-- PROVEEDOR: Correo electrónico único
ALTER TABLE PROVEEDOR ADD CONSTRAINT UN_PROVEEDOR_EMAIL UNIQUE (email);

-- MARCA: Nombre de marca único
ALTER TABLE MARCA ADD CONSTRAINT UN_MARCA_NOMBRE UNIQUE (nombre_marca);

-- DETALLE_VENTA: Cantidad de productos mayor o igual que 1 
ALTER TABLE DETALLE_VENTA ADD CONSTRAINT CK_DETALLE_VENTA_CANTIDAD CHECK (cantidad >= 1);



-- ***********************************************************************************
-- CREACIÓN DE SECUENCIAS (Para IDs que no usan IDENTITY)
-- Se crean secuencias para IDs específicos según las consideraciones del caso 3
-- ***********************************************************************************

CREATE SEQUENCE SEQ_ID_SALUD
START WITH 2050
INCREMENT BY 10;

CREATE SEQUENCE SEQ_ID_EMPLEADO
START WITH 750
INCREMENT BY 3;


-- ***********************************************************************************
-- CASO 3
-- POBLAMIENTO DE TABLAS
-- ***********************************************************************************

-- Tablas Sin Dependencia (REGIONALES, PAGOS, PREVISIONALES)

-- REGION
INSERT INTO REGION (id_region, nombre_region) VALUES (1, 'Región Metropolitana');
INSERT INTO REGION (id_region, nombre_region) VALUES (2, 'Valparaíso');
INSERT INTO REGION (id_region, nombre_region) VALUES (3, 'Biobío');
INSERT INTO REGION (id_region, nombre_region) VALUES (4, 'Los Lagos');

-- COMUNA (Se asume una comuna por región para el poblamiento simple)
INSERT INTO COMUNA (id_comuna, nombre_comuna, cod_region) VALUES (1, 'Santiago', 1);
INSERT INTO COMUNA (id_comuna, nombre_comuna, cod_region) VALUES (2, 'Valparaíso', 2);
INSERT INTO COMUNA (id_comuna, nombre_comuna, cod_region) VALUES (3, 'Concepción', 3);
INSERT INTO COMUNA (id_comuna, nombre_comuna, cod_region) VALUES (4, 'Puerto Montt', 4);

-- MEDIO_PAGO
INSERT INTO MEDIO_PAGO (id_mpago, nombre_mpago) VALUES (11, 'Efectivo');
INSERT INTO MEDIO_PAGO (id_mpago, nombre_mpago) VALUES (12, 'Tarjeta Débito');
INSERT INTO MEDIO_PAGO (id_mpago, nombre_mpago) VALUES (13, 'Tarjeta Crédito');
INSERT INTO MEDIO_PAGO (id_mpago, nombre_mpago) VALUES (14, 'Cheque');

-- SALUD (Usa secuencia SEQ_ID_SALUD, que comienza en 2050 e incrementa en 10)
INSERT INTO SALUD (id_salud, nom_salud) VALUES (SEQ_ID_SALUD.NEXTVAL, 'Fonasa'); -- id_salud = 2050
INSERT INTO SALUD (id_salud, nom_salud) VALUES (SEQ_ID_SALUD.NEXTVAL, 'Isapre Colmena'); -- id_salud = 2060
INSERT INTO SALUD (id_salud, nom_salud) VALUES (SEQ_ID_SALUD.NEXTVAL, 'Isapre Banmédica'); -- id_salud = 2070
INSERT INTO SALUD (id_salud, nom_salud) VALUES (SEQ_ID_SALUD.NEXTVAL, 'Isapre Cruz Blanca'); -- id_salud = 2080

-- AFP (Usa IDENTITY, comienza en 210, incrementa en 6)
INSERT INTO AFP (nom_afp) VALUES ('AFP Habitat'); -- id_afp = 210
INSERT INTO AFP (nom_afp) VALUES ('AFP Cuprum'); -- id_afp = 216
INSERT INTO AFP (nom_afp) VALUES ('AFP ProVida'); -- id_afp = 222
INSERT INTO AFP (nom_afp) VALUES ('AFP PlanVital'); -- id_afp = 228

-- EMPLEADO (Usa secuencia SEQ_ID_EMPLEADO, comienza en 750, incrementa en 3)

INSERT INTO EMPLEADO (id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp)
VALUES (SEQ_ID_EMPLEADO.NEXTVAL, '111111-1', 'Marcela', 'González', 'Pérez', DATE '2022-03-15', 950000, 80000, 'S', 'Administrativo', NULL, 2060, 210); -- id_empleado = 750

INSERT INTO EMPLEADO (id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp)
VALUES (SEQ_ID_EMPLEADO.NEXTVAL, '222222-2', 'José', 'Muñoz', 'Ramírez', DATE '2021-07-10', 900000, 75000, 'S', 'Administrativo', 750, 2060, 216); -- id_empleado = 753

INSERT INTO EMPLEADO (id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp)
VALUES (SEQ_ID_EMPLEADO.NEXTVAL, '333333-3', 'Verónica', 'Soto', 'Alarcón', DATE '2020-01-05', 880000, 70000, 'S', 'Vendedor', 750, 2060, 228); -- id_empleado = 756

INSERT INTO EMPLEADO (id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp)
VALUES (SEQ_ID_EMPLEADO.NEXTVAL, '444444-4', 'Luis', 'Reyes', 'Fuentes', DATE '2023-04-01', 560000, NULL, 'S', 'Vendedor', 750, 2070, 228); -- id_empleado = 759

INSERT INTO EMPLEADO (id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp)
VALUES (SEQ_ID_EMPLEADO.NEXTVAL, '555555-5', 'Claudia', 'Fernández', 'Lagos', DATE '2023-04-15', 600000, NULL, 'S', 'Vendedor', 753, 2070, 216); -- id_empleado = 762

INSERT INTO EMPLEADO (id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp)
VALUES (SEQ_ID_EMPLEADO.NEXTVAL, '666666-6', 'Carlos', 'Navarro', 'Vega', DATE '2023-05-01', 610000, NULL, 'S', 'Administrativo', 753, 2060, 210); -- id_empleado = 765

INSERT INTO EMPLEADO (id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp)
VALUES (SEQ_ID_EMPLEADO.NEXTVAL, '777777-7', 'Javiera', 'Pino', 'Rojas', DATE '2023-05-10', 650000, NULL, 'S', 'Administrativo', 750, 2050, 210); -- id_empleado = 768

INSERT INTO EMPLEADO (id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp)
VALUES (SEQ_ID_EMPLEADO.NEXTVAL, '888888-8', 'Diego', 'Mella', 'Contreras', DATE '2023-05-12', 620000, NULL, 'S', 'Vendedor', 750, 2060, 216); -- id_empleado = 771

INSERT INTO EMPLEADO (id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp)
VALUES (SEQ_ID_EMPLEADO.NEXTVAL, '999999-9', 'Fernanda', 'Salas', 'Herrera', DATE '2023-05-18', 570000, NULL, 'S', 'Vendedor', 753, 2070, 228); -- id_empleado = 774

INSERT INTO EMPLEADO (id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp)
VALUES (SEQ_ID_EMPLEADO.NEXTVAL, '101010-0', 'Tomás', 'Vidal', 'Espinoza', DATE '2023-06-01', 530000, NULL, 'S', 'Vendedor', NULL, 2050, 222); -- id_empleado = 777

-- VENDEDOR / ADMINISTRATIVO
-- Se inserta según el tipo_empleado de la tabla EMPLEADO

-- VENDEDOR (id_empleado: 756, 759, 762, 771, 774, 777)
-- Se asigna una comisión de ejemplo, respetando el CHECK (entre 0 y 0.25)
INSERT INTO VENDEDOR (id_empleado, comision_venta) VALUES (756, 0.15);
INSERT INTO VENDEDOR (id_empleado, comision_venta) VALUES (759, 0.10);
INSERT INTO VENDEDOR (id_empleado, comision_venta) VALUES (762, 0.12);
INSERT INTO VENDEDOR (id_empleado, comision_venta) VALUES (771, 0.14);
INSERT INTO VENDEDOR (id_empleado, comision_venta) VALUES (774, 0.10);
INSERT INTO VENDEDOR (id_empleado, comision_venta) VALUES (777, 0.08);

-- ADMINISTRATIVO (id_empleado: 750, 753, 765, 768)
INSERT INTO ADMINISTRATIVO (id_empleado) VALUES (750);
INSERT INTO ADMINISTRATIVO (id_empleado) VALUES (753);
INSERT INTO ADMINISTRATIVO (id_empleado) VALUES (765);
INSERT INTO ADMINISTRATIVO (id_empleado) VALUES (768);

-- VENTA (Usa IDENTITY, comienza en 5050, incrementa en 3)

INSERT INTO VENTA (fecha_venta, total_venta, cod_mpago, cod_empleado) VALUES (DATE '2023-05-12', 225990, 12, 771); -- id_venta = 5050
INSERT INTO VENTA (fecha_venta, total_venta, cod_mpago, cod_empleado) VALUES (DATE '2023-10-23', 524990, 13, 777); -- id_venta = 5053
INSERT INTO VENTA (fecha_venta, total_venta, cod_mpago, cod_empleado) VALUES (DATE '2023-02-17', 466990, 11, 759); -- id_venta = 5056

--  PRODUCTO y DETALLE_VENTA no tienen datos en las imágenes,

-- CATEGORIA
INSERT INTO CATEGORIA (id_categoria, nombre_categoria) VALUES (101, 'Abarrotes');
INSERT INTO CATEGORIA (id_categoria, nombre_categoria) VALUES (102, 'Lácteos');
INSERT INTO CATEGORIA (id_categoria, nombre_categoria) VALUES (103, 'Aseo');

-- MARCA
INSERT INTO MARCA (id_marca, nombre_marca) VALUES (201, 'Nestlé');
INSERT INTO MARCA (id_marca, nombre_marca) VALUES (202, 'Soprole');
INSERT INTO MARCA (id_marca, nombre_marca) VALUES (203, 'Mastercat');

-- PROVEEDOR (Usando Comuna 1: Santiago)
INSERT INTO PROVEEDOR (id_proveedor, nombre_proveedor, rut_proveedor, telefono, email, direccion, cod_comuna)
VALUES (30001, 'Distribuidora A.B', '12111222-3', '987654321', 'contacto@ab.cl', 'Calle Falsa 123', 1);

INSERT INTO PROVEEDOR (id_proveedor, nombre_proveedor, rut_proveedor, telefono, email, direccion, cod_comuna)
VALUES (30002, 'Lácteos Sur S.A.', '15333444-5', '912345678', 'ventas@lacteos.cl', 'Av. Siempre Viva 456', 3);


-- PRODUCTO (id_producto: 4001, 4002, 4003)
-- (Stock Mínimo debe ser >= 3 por la restricción CK_PRODUCTO_STOCK_MINIMO)

-- Producto 1: Leche, Origen Nacional, Marca Soprole (202), Categoría Lácteos (102), Proveedor Lácteos Sur (30002)
INSERT INTO PRODUCTO (id_producto, nombre_producto, precio_unitario, origen_nacional, stock_minimo, activo, cod_marca, cod_categoria, cod_proveedor)
VALUES (4001, 'Leche Entera 1lt', 950, 'S', 5, 'S', 202, 102, 30002);

-- Producto 2: Arroz, Origen Extranjero, Marca Nestlé (201), Categoría Abarrotes (101), Proveedor Distribuidora A&B (30001)
INSERT INTO PRODUCTO (id_producto, nombre_producto, precio_unitario, origen_nacional, stock_minimo, activo, cod_marca, cod_categoria, cod_proveedor)
VALUES (4002, 'Arroz Grado 1 1kg', 1290, 'N', 10, 'S', 201, 101, 30001);

-- Producto 3: Detergente, Origen Nacional, Marca Mastercat (203), Categoría Aseo (103), Proveedor Distribuidora A&B (30001)
INSERT INTO PRODUCTO (id_producto, nombre_producto, precio_unitario, origen_nacional, stock_minimo, activo, cod_marca, cod_categoria, cod_proveedor)
VALUES (4003, 'Detergente Líquido 3lt', 4500, 'S', 3, 'S', 203, 103, 30001);


-- DETALLE_VENTA (Cantidad debe ser > 1 por la restricción CK_DETALLE_VENTA_CANTIDAD)
-- Se usarán los id_venta ya creados (5050, 5053, 5056) y los nuevos id_producto (4001, 4002, 4003).

-- Detalle para Venta 5050 (Cliente compró Leche y Arroz)
INSERT INTO DETALLE_VENTA (cod_venta, cod_producto, cantidad, detalle_valor)
VALUES (5050, 4001, 4, (4 * 950)); -- 4 unidades de Leche

INSERT INTO DETALLE_VENTA (cod_venta, cod_producto, cantidad, detalle_valor)
VALUES (5050, 4002, 5, (5 * 1290)); -- 5 unidades de Arroz

-- Detalle para Venta 5053 (Cliente compró Detergente)
INSERT INTO DETALLE_VENTA (cod_venta, cod_producto, cantidad, detalle_valor)
VALUES (5053, 4003, 2, (2 * 4500)); -- 2 unidades de Detergente

-- Venta 5056: Cliente compró Leche y Arroz en grandes cantidades.
-- Producto 4001: Leche Entera 1lt (Precio Unitario: 950)
INSERT INTO DETALLE_VENTA (cod_venta, cod_producto, cantidad, detalle_valor)
VALUES (5056, 4001, 10, (10 * 950)); -- 10 unidades de Leche (Detalle_valor: 9500)

-- Producto 4002: Arroz Grado 1 1kg (Precio Unitario: 1290)
INSERT INTO DETALLE_VENTA (cod_venta, cod_producto, cantidad, detalle_valor)
VALUES (5056, 4002, 20, (20 * 1290)); -- 20 unidades de Arroz (Detalle_valor: 25800)

-- Producto 4003: Detergente Líquido 3lt (Precio Unitario: 4500)
INSERT INTO DETALLE_VENTA (cod_venta, cod_producto, cantidad, detalle_valor)
VALUES (5056, 4003, 5, (5 * 4500)); -- 5 unidades de Detergente (Detalle_valor: 22500)


-- ***********************************************************************************
-- CASO 4
-- RECUPERACIÓN DE DATOS
-- ***********************************************************************************


-- ***********************************************************************************
-- INFORME 1: Salario Simulado con Bono de Jefatura
-- Empleados Activos ('S') con Bono_Jefatura distinto de NULL
-- ***********************************************************************************

SELECT
    e.id_empleado AS IDENTIFICADOR,
    e.nombre_empleado || ' ' || e.apellido_paterno || ' ' || e.apellido_materno AS "NOMBRE COMPLETO",
    e.sueldo_base AS SALARIO,
    e.bono_jefatura AS BONIFICACION,
    (e.sueldo_base + e.bono_jefatura) AS "SALARIO SIMULADO"
FROM
    EMPLEADO e
WHERE
    e.activo = 'S'
    AND e.bono_jefatura IS NOT NULL
ORDER BY
    "SALARIO SIMULADO" DESC,
    e.apellido_paterno DESC;

-- Resultado esperado (Figura 3):
-- IDENTIFICADOR | NOMBRE COMPLETO        | SALARIO | BONIFICACION | SALARIO SIMULADO
-- 750           | Marcela González Pérez | 950000  | 80000        | 1030000
-- 753           | José Muñoz Ramírez     | 900000  | 75000        | 975000
-- 756           | Verónica Soto Alarcón  | 880000  | 70000        | 950000




-- ***********************************************************************************
-- INFORME 2: Posible Aumento del 8% por Rango Salarial
-- Empleados con Sueldo_Base entre 550000 y 800000 (inclusive)
-- ***********************************************************************************

SELECT
    e.nombre_empleado || ' ' || e.apellido_paterno || ' ' || e.apellido_materno AS EMPLEADO,
    e.sueldo_base AS SUELDO,
    ROUND(e.sueldo_base * 0.08) AS "POSIBLE AUMENTO",
    ROUND(e.sueldo_base * 1.08) AS "SUELDO SIMULADO"
FROM
    EMPLEADO e
WHERE
    e.sueldo_base BETWEEN 550000 AND 800000
ORDER BY
    SUELDO ASC;

-- Resultado esperado (Figura 4):
-- EMPLEADO                | SUELDO | POSIBLE AUMENTO | SUELDO SIMULADO
-- Luis Reyes Fuentes      | 560000 | 44800           | 604800
-- Fernanda Salas Herrera  | 570000 | 45600           | 615600
-- Claudia Fernández Lagos | 600000 | 48000           | 648000
-- Carlos Navarro Vega     | 610000 | 48800           | 658800
-- Diego Mella Contreras   | 620000 | 49600           | 669600
-- Javiera Pino Rojas      | 650000 | 52000           | 702000



-- ***********************************************************************************

-- 1. Tablas Fuertes e Independientes
SELECT * FROM REGION;
SELECT * FROM COMUNA;
SELECT * FROM MEDIO_PAGO;
SELECT * FROM SALUD;
SELECT * FROM AFP;
SELECT * FROM CATEGORIA;
SELECT * FROM MARCA;

-- 2. Tablas Dependientes
SELECT * FROM EMPLEADO;
SELECT * FROM PROVEEDOR;

-- 3. Tablas de Especialización (Herencia)
SELECT * FROM VENDEDOR;
SELECT * FROM ADMINISTRATIVO;

-- 4. Tablas de Inventario
SELECT * FROM PRODUCTO;

-- 5. Tablas de Transacción
SELECT * FROM VENTA;
SELECT * FROM DETALLE_VENTA;