# Poblamiento y consultas en la base de datos con sentencias SQL

A partir de un caso planteado, tendrás que utilizar sentencias SQL (y Scripts) para diseñar una estructura de base de datos relacional, incluyendo la creación de tablas y definición de restricciones de integridad (constraints), así como el poblamiento de dichas tablas con datos relevantes mediante el uso de secuencias.   Además, deberás realizar algunos reportes de interés, para obtener información de análisis en un formato y orden específico. 

## Descripción del Proyecto :scroll:

⭐⭐ Caso planteado: 

Doña Marta es una emprendedora del sur de Chile que ha administrado su minimarket por más de 15 años. Su negocio, el MiniMarket Doña Marta, se ubica en una zona residencial y ofrece productos esenciales para la comunidad local, incluyendo abarrotes, lácteos, bebidas, artículos de aseo y productos de temporada.
A lo largo de los años, su catálogo ha crecido, incorporando productos de distintas marcas y formatos, y ha establecido relaciones comerciales con diversos proveedores locales y nacionales. Sin embargo, la gestión del minimarket se ha mantenido completamente manual, utilizando libretas, boletas físicas y hojas de cálculo básicas.
Actualmente, el minimarket funciona de la siguiente manera:
-	Recepción de productos: Doña Marta realiza compras a diferentes proveedores de forma periódica. Cada proveedor puede entregar productos de distintas categorías y marcas.
-	Registro de compras: Las compras se anotan en un cuaderno, sin control automático de los productos recibidos ni del valor exacto pagado.
-	Seguimiento de pagos: A veces se paga de inmediato en efectivo o transferencia, pero otras veces quedan pagos pendientes. El estado de las compras no queda registrado formalmente.
-	Control de stock: No existe un sistema que indique cuántas unidades de cada producto hay ni cuál es el stock mínimo recomendado.
-	Promociones y decisiones comerciales: Se hacen de forma intuitiva, sin análisis de datos. Marta decide promociones basadas en lo que ve que no se vende o lo que más se mueve, sin estadísticas reales.
  
Entre los problemas actuales se encuentran:
- Falta de control sobre el inventario, lo que ha llevado a sobrestock de algunos productos y quiebre de otros.
- Desconocimiento del costo real de productos por variación de precios entre proveedores.
- Dificultad para rastrear pagos pendientes, lo que genera desorden en las finanzas.
- Pérdida de tiempo en búsquedas manuales de información al necesitar revisar cuadernos antiguos.
- 
Doña Marta ha decidido digitalizar su sistema de gestión, iniciando con un módulo en:
- Registrar y analizar productos y sus características.
- Controlar compras y pagos asociados.
- Visualizar información clave sin necesidad de cruzar manualmente datos.
- Sentar las bases para, en el futuro, incorporar ventas y clientes si el negocio crece.
  
Su meta es tener un sistema claro, visual, que le permita ahorrar tiempo y tomar decisiones informadas sobre qué productos promocionar, a qué proveedores comprar, y cómo manejar mejor su inventario y su flujo de caja.

Para apoyar este proceso de modernización, se ha diseñado un modelo de base de datos totalmente normalizado, que incluye:
- Información de productos, incluyendo atributos clave como origen, formato, marca y categoría.
- Información detallada de compras realizadas, incluyendo montos y medio de pago.
- Información de proveedores y ubicación geográfica, permitiendo análisis por zona.
- Un registro de los productos involucrados en cada compra.
  
El sistema también permitirá aplicar filtros y cálculos sobre la información registrada, sin depender de múltiples relaciones complejas. En consecuencia, es necesario implementar la base de datos, desarrollando el script DDL para crear las tablas y el script SQL para poblar los datos solicitados, a partir del Modelo Relacional Normalizado (ver Figura 1) que quedó como evidencia de la primera fase del proyecto. 

Posteriormente deberás realizar reportes estadísticos orientados al análisis de datos para generar información relevante para la empresa.

<img width="1421" height="786" alt="Captura de pantalla 2025-10-03 174618" src="https://github.com/user-attachments/assets/84a7c9f2-8bb5-4372-acf6-43080e0a244e" />



### ✨Requisitos   ✨

👉 Caso 1: Implementación del modelo 

Para la construcción del script de creación de las tablas del modelo relacional debes considerar lo siguiente:
- Crear las tablas del Modelo Relacional de la Figura 1 en orden secuencial siguiendo la jerarquía de dependencia, es decir, desde las tablas fuertes a las más débiles. Utiliza el IDE: Oracle SQL Developer.
- Crear las restricciones de Clave Primaria (PK), Clave Foránea (FK), Clave Única (UN) y Check (CK), de las tablas de acuerdo al diagrama relacional y al análisis del modelo.
- Considerar que todas las restricciones (CONSTRAINTS) deben tener un nombre representativo según las tablas en las que pertenecen: PK, FK, CK, UN.
- Asignar los tipos de datos y precisiones de las columnas de las tablas, de acuerdo al modelo entregado, para posteriormente no tener problemas con el poblamiento de la base de datos.

Consideraciones para la creación de tablas:
- En la tabla AFP se sabe que identificador es un número que se inicia en 210 y se incrementa en 6 (usa identity).
- En la tabla VENTA el identificador es un número que se inicia en 5050 y se incrementa en 3 (usa identity).


👉 Caso 2: Modificación del modelo

Implementa, usando la sentencia ALTER TABLE, las restricciones necesarias para incorporar las siguientes reglas de negocio:
- Todo empleado del minimarket debe recibir un sueldo base que cumpla con el salario mínimo vigente. Por ello, se debe implementar una restricción CHECK en la tabla EMPLEADO que establece que ningún empleado puede tener un sueldo base inferior a $400.000.
- Los vendedores pueden recibir una comisión por venta, pero esta no puede superar el 25% del valor vendido. Por tanto, establece en la tabla VENDEDOR una validación CHECK donde la comisión debe estar entre 0 y 0.25.
- No es posible registrar una venta de producto si no se cuenta con stock para realizar la transacción. Se requiere implementar una restricción CHECK que valide que el stock mínimo de la tabla PRODUCTO tenga al menos tres unidades.
- Para mantener una comunicación clara y sin ambigüedades, es necesario agregar una restricción UNIQUE en la tabla PROVEEDOR que no permita tener dos proveedores con el mismo correo electrónico.
- Cada marca registrada en el sistema debe tener un nombre único, ya que el nombre es la forma principal de identificación para productos. Por lo tanto, se recomienda agregar una restricción UNIQUE en la tabla MARCA.
- En el detalle de venta las cantidades de los productos deben ser valores que 1.  Si una cantidad se registra cero o menos, significa un error de registro o mal uso del sistema.  Se requiere implementar una restricción CHECK en la tabla DETALLE_VENTA que controle esta situación.
 
👉Caso 3: Poblamiento del modelo

Consideraciones para el poblado de las tablas:
- Se sabe que el sistema debe registrar distintas empresas de salud.  Por un tema de seguridad, al poblar la tabla SALUD, el id_salud debe iniciar en 2050, y se debe incrementar en 10 unidades (usa objeto secuencia)
- Se conoce que hay del orden de 50 empleados. Por lo tanto, para poblar la tabla EMPLEADO debes usar una identificación numérica que comience en 750 y que se incremente en 3 (usa objeto secuencia).
 

Considera que tu script se ejecutará en forma secuencial, es decir, debes ordenarlo según las restricciones de integridad y dependencia.  Las tablas cruciales que debes llenar son:

1.	Tabla EMPLEADO: Contiene todos los datos personales, contrato y estructura jerárquica de los trabajadores.
2.	Tabla VENTA: Contiene los datos de las ventas realizadas en el minimarket.
3.	Tabla MEDIO_PAGO: Nombre de los medios de pago que acepta la empresa.
4.	Tabla AFP: Nombre de las administradoras de fondos de pensiones asociadas a los empleados.
5.	Tabla SALUD: Nombre de las instituciones previsionales de salud a las que están afiliados los empleados (Fonasa, Isapres).
6.	Tabla VENDEDOR: Contiene las comisiones que reciben los vendedores.


👉Caso 4: Recuperación de Datos
Posteriormente al poblamiento de los datos, debes recuperar toda la información que el Departamento de Gestión del Personal te solicite, generando informes usando la sentencia SELECT de manera adecuada.


⭐⭐ INFORME 1 ⭐⭐

El minimarket quiere simular el sueldo total estimado de sus empleados activos que tienen un bono de jefatura asignado. Para esto, calcula el total sumando el sueldo base más el bono (sin funciones ni condiciones).
Entrega un listado con el nombre completo del empleado, su sueldo base, el bono de jefatura y el total estimado (sueldo + bono). Solo considera empleados activos (activo = 'S') y que tienen bono (bono distinto de NULL). 

El informe debe mostrar las siguientes columnas con alias adecuados:
- IDENTIFICADOR: id del empleado
- NOMBRE COMPLETO: nombre completo del empleado
- SALARIO: sueldo base del empleado
- BONIFICACION: bono entregado por la jefatura
- SALARIO SIMULADO: sueldo estimado después agregar la bonificación
- 
Ordena por los datos por el salario simulado de forma descendente. En caso de empate, ordena descendentemente por apellido paterno.



⭐⭐ INFORME 2 ⭐⭐

La administración desea identificar empleados cuyo sueldo base está en el rango medio definido entre $550.000 y $800.000. Esta revisión será usada para ajustar beneficios futuros.
Entrega un listado con el nombre completo del empleado, su sueldo base y un posible aumento del 8%. Solo incluye a los empleados cuyo sueldo esté entre 550.000 y 800.000 (inclusive). 
El informe debe mostrar las siguientes columnas con alias adecuados:
- EMPLEADO: nombre completo del empleado
- SUELDO: sueldo base del empleado
- POSIBLE AUMENTO: porcentaje de aumento del sueldo base
- SALARIO SIMULADO: sueldo estimado después agregar el aumento
Ordena por sueldo base de forma ascendente.



## Solución planteada:


<img width="817" height="501" alt="Captura de pantalla 2025-10-03 173806" src="https://github.com/user-attachments/assets/1c1d2021-5f5c-49f1-9108-edb972e9e9cc" />

<img width="820" height="532" alt="Captura de pantalla 2025-10-03 173848" src="https://github.com/user-attachments/assets/4a6d2b19-0d91-4853-bf1e-7a9d3192eaf7" />


## Autora ⚡ 

- **Andrea Rosero** ⚡  - [Andrea Rosero](https://github.com/andreaendigital)
