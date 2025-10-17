# Problema 1: Caza de Datos

## Nivel: Fácil

## Objetivo
Extraer datos estructurados de un texto ruidoso con un solo prompt claro. Debes identificar la información relevante y devolverla en formato JSON con las keys específicas requeridas.

## Instrucciones
Lee el siguiente texto y extrae la información solicitada. Tu respuesta debe ser ÚNICAMENTE el JSON con la estructura exacta mostrada en el ejemplo de salida, sin texto adicional antes o después.

## Texto de entrada
```
Nos vemos en la Feria de empleo de la ORT este jueves 17/10 a las 3 pm. Lugar: Facultad de Ingeniería de la ORT, Montevideo. Estaremos en el stand 21. Consultas: people@crunchloop.io
```

## Salida requerida
Tu respuesta debe ser exactamente un JSON con la siguiente estructura y keys:

```json
{
    "nombre_evento": "Feria de empleo de la ORT",
    "fecha": "2025-10-17",
    "hora_inicio": "15:00",
    "ciudad": "Montevideo",
    "stand": "21",
    "email_contacto": "people@crunchloop.io"
}
```

## Notas importantes
- La fecha debe estar en formato ISO (YYYY-MM-DD)
- La hora debe estar en formato 24 horas (HH:MM)
- Asume que el año es 2025 si no se especifica
- Responde SOLO con el JSON, sin explicaciones adicionales

## Evaluación
Este problema será evaluado automáticamente usando el script: `easy/evaluation-scripts/problem-1.js`
El script verificará que tu salida contenga exactamente las keys esperadas con los valores correctos.