# Problema 1: Caza de Datos

## Nivel: F�cil

## Objetivo
Extraer datos estructurados de un texto ruidoso con un solo prompt claro. Debes identificar la informaci�n relevante y devolverla en formato JSON con las keys espec�ficas requeridas.

## Instrucciones
Lee el siguiente texto y extrae la informaci�n solicitada. Tu respuesta debe ser �NICAMENTE el JSON con la estructura exacta mostrada en el ejemplo de salida, sin texto adicional antes o despu�s.

## Texto de entrada
```
Nos vemos en la Feria de empleo de la ORT este jueves 17/10 a las 3 pm. Lugar: Facultad de Ingenier�a de la ORT, Montevideo. Estaremos en el stand 21. Consultas: people@crunchloop.io
```

## Salida requerida
Tu respuesta debe ser exactamente un JSON con la siguiente estructura y keys:

```json
{
    "nombre_evento": "Feria de empleo",
    "fecha_iso": "2025-10-17",
    "hora_inicio_24h": "15:00",
    "ciudad": "Montevideo",
    "stand": "21",
    "email_contacto": "people@crunchloop.io"
}
```

## Notas importantes
- La fecha debe estar en formato ISO (YYYY-MM-DD)
- La hora debe estar en formato 24 horas (HH:MM)
- Asume que el a�o es 2025 si no se especifica
- Responde SOLO con el JSON, sin explicaciones adicionales

## Evaluación
Este problema será evaluado automáticamente usando el script: `easy/evaluation-scripts/problem-1.js`
El script verificará que tu salida contenga exactamente las keys esperadas con los valores correctos.