# Problema 3: Análisis de Inscripciones en Cursos

## Dificultad: Media

## Descripción
Encuentra todos los cursos que están por encima del 50% de capacidad basándose en las inscripciones actuales, junto con los detalles de inscripción de estudiantes.
Esto ayuda a identificar cursos que podrían necesitar secciones adicionales.

## Requisitos
- Calcular el número de estudiantes inscritos en cada curso
- Calcular el porcentaje de inscripción (inscritos/capacidad * 100)
- Filtrar cursos donde la inscripción es mayor al 50% de la capacidad
- Incluir nombre del curso, créditos, capacidad, conteo de inscripción actual y porcentaje de inscripción
- Ordenar por porcentaje de inscripción descendente
- Redondear el porcentaje de inscripción a 2 decimales

## Tablas Involucradas
- Courses
- Enrollments

## Columnas Esperadas en la Salida
- CourseName
- Credits
- Capacity
- CurrentEnrollment
- EnrollmentPercentage (redondeado a 2 decimales)

## Ejemplo de Salida Esperada
```
CourseName         | Credits | Capacity | CurrentEnrollment | EnrollmentPercentage
-------------------|---------|----------|-------------------|---------------------
Database Systems   | 4       | 30       | 18                | 60.00
Machine Learning   | 4       | 25       | 15                | 60.00
```

## Pistas
- Usa COUNT() para obtener el número de inscripciones por curso
- Usa GROUP BY para agregar por curso
- Calcula el porcentaje como (COUNT(*) * 100.0 / Capacity)
- Usa la cláusula HAVING para filtrar grupos
- Usa INNER JOIN para conectar cursos con inscripciones
