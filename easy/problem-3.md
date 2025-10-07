# Problema 3: Recordatorio de Cita Médica

## Nivel: Fácil

## Objetivo
Extraer datos estructurados de un mensaje de recordatorio de cita médica con un solo prompt claro. Debes identificar la información relevante del mensaje y devolverla en formato JSON con las keys específicas requeridas.

## Instrucciones
Lee el siguiente mensaje y extrae la información solicitada. Tu respuesta debe ser ÚNICAMENTE el JSON con la estructura exacta mostrada en el ejemplo de salida, sin texto adicional antes o después.

## Texto de entrada
```
Hola María! Te recordamos que tienes cita con el Dr. Mendez este miércoles 30 de octubre a las 14:30 en el Hospital Británico. Es importante que llegues 15 minutos antes para completar el formulario de actualización de datos. La consulta tiene un costo de $1,800. Recuerda traer tu carné de salud y los estudios de sangre que te solicitamos. Por cualquier consulta, puedes llamarnos al 2487-3000. Saludos, Recepción.
```

## Salida requerida
Tu respuesta debe ser exactamente un JSON con la siguiente estructura y keys:

```json
{
    "nombre": "María",
    "doctor": "Dr. Mendez",
    "dia_semana": "miércoles",
    "dia_mes": 30,
    "mes": "octubre",
    "hora": "14:30",
    "lugar": "Hospital Británico",
    "minutos_antes": 15,
    "costo": 1800,
    "telefono": "2487-3000"
}
```

## Notas importantes
- La hora debe estar en formato 24 horas (HH:MM)
- El día del mes debe ser número entero
- Los minutos deben ser número entero
- El costo debe ser número (sin símbolo de moneda)
- El día de la semana y mes deben estar en minúsculas
- Responde SOLO con el JSON, sin explicaciones adicionales

## Evaluación
Este problema será evaluado automáticamente usando el script: `easy/evaluation-scripts/problem-3.js`
El script verificará que tu salida contenga exactamente las keys esperadas con los valores correctos.