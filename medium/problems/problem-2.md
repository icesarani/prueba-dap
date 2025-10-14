# Problema 2: Análisis de Salarios por Departamento

## Dificultad: Media

## Descripción
Calcula el salario promedio para cada departamento e identifica qué empleados ganan más que el promedio de su departamento.
Actualiza una bandera hipotética de bono de rendimiento basada en este análisis.

## Requisitos
- Calcular el salario promedio para cada departamento
- Encontrar empleados que ganen más que el promedio de su departamento
- Devolver nombre del departamento, nombre del empleado, salario del empleado y salario promedio del departamento
- Ordenar por nombre del departamento, luego por salario descendente
- Redondear los valores de salario a 2 decimales

## Tablas Involucradas
- Departments
- Employees

## Columnas Esperadas en la Salida
- DepartmentName
- EmployeeName
- Salary
- DeptAvgSalary (redondeado a 2 decimales)

## Ejemplo de Salida Esperada
```
DepartmentName | EmployeeName    | Salary    | DeptAvgSalary
---------------|-----------------|-----------|---------------
Engineering    | Alice Johnson   | 95000.00  | 85000.00
Engineering    | Bob Williams    | 85000.00  | 85000.00
Sales          | Diana Miller    | 70000.00  | 67500.00
```

## Pistas
- Usa una subconsulta o CTE para calcular promedios por departamento
- Usa INNER JOIN para combinar tablas
- Usa la cláusula WHERE para filtrar empleados que ganan por encima del promedio
- Considera usar AVG() con la cláusula OVER() o una subconsulta
