# Problema 2: Extracción de Pedido Online

## Nivel: Fácil

## Objetivo
Extraer datos estructurados de un mensaje de confirmación de pedido con un solo prompt claro. Debes identificar la información relevante del pedido y devolverla en formato JSON con las keys específicas requeridas.

## Instrucciones
Lee el siguiente mensaje de confirmación y extrae la información solicitada. Tu respuesta debe ser ÚNICAMENTE el JSON con la estructura exacta mostrada en el ejemplo de salida, sin texto adicional antes o después.

## Texto de entrada
```
¡Gracias por tu compra! Tu pedido #ORD-2024-8934 ha sido confirmado.
Productos: 2x Laptop Dell XPS 13 ($1,200.00 c/u), 1x Mouse Logitech MX Master ($89.99)
Subtotal: $2,489.99. Descuento aplicado: 10% (-$249.00). Envío express: $15.00
Total final: $2,255.99
Dirección de envío: Av. Rivera 3245 apto 401, Montevideo, Uruguay, CP 11300
Fecha estimada de entrega: martes 22 de octubre 2025
Método de pago: Tarjeta terminada en 4782
```

## Salida requerida
Tu respuesta debe ser exactamente un JSON con la siguiente estructura y keys:

```json
{
    "numero_orden": "ORD-2024-8934",
    "cantidad_items": 3,
    "subtotal": 2489.99,
    "descuento_porcentaje": 10,
    "costo_envio": 15.00,
    "total": 2255.99,
    "codigo_postal": "11300",
    "fecha_entrega_iso": "2025-10-22",
    "ultimos_digitos_tarjeta": "4782"
}
```

## Notas importantes
- Los montos deben ser números (sin símbolo de moneda ni formato de texto)
- La fecha debe estar en formato ISO (YYYY-MM-DD)
- El código postal debe ser string
- cantidad_items es la suma total de productos (2+1=3 en este caso)
- Responde SOLO con el JSON, sin explicaciones adicionales

## Evaluación
Este problema será evaluado automáticamente usando el script: `easy/evaluation-scripts/problem-2.js`
El script verificará que tu salida contenga exactamente las keys esperadas con los valores correctos.