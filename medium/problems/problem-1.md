# Problema 1: Mejores Clientes por Ingresos

## Dificultad: Media

## Descripción
Necesitas encontrar los 5 mejores clientes que han generado más ingresos a partir de órdenes completadas.
Los ingresos deben calcularse desde la tabla OrderDetails (Quantity * UnitPrice).

## Requisitos
- Solo incluir órdenes con estado 'Completed'
- Calcular los ingresos totales por cliente
- Devolver nombre del cliente, email e ingresos totales
- Ordenar por ingresos en orden descendente
- Limitar a los 5 mejores clientes
- Redondear los ingresos a 2 decimales

## Tablas Involucradas
- Customers
- Orders
- OrderDetails

## Columnas Esperadas en la Salida
- CustomerName
- Email
- TotalRevenue (redondeado a 2 decimales)

## Ejemplo de Salida Esperada
```
CustomerName    | Email              | TotalRevenue
----------------|--------------------|--------------
John Smith      | john@email.com     | 1209.95
Maria Garcia    | maria@email.com    | 379.98
```

## Pistas
- Usa INNER JOIN para conectar las tres tablas
- Usa la cláusula WHERE para filtrar por estado de la orden
- Usa GROUP BY para agregar por cliente
- Usa la función ROUND() para precisión decimal
- Usa ORDER BY y TOP para obtener los 5 mejores
