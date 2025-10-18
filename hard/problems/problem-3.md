# Problem 3: PATCH /api/products/:id/stock no actualiza

## Bug Report #4612

**Archivo:** `routes/products.js`
**Endpoint:** `PATCH /api/products/:id/stock`

### Síntoma
```bash
# Stock actual
curl http://localhost:3000/api/products/507f1f77bcf86cd799439013
# Respuesta: {"stock": 100, ...}

# Intentar actualizar a 50
curl -X PATCH http://localhost:3000/api/products/507f1f77bcf86cd799439013/stock \
  -d '{"stock": 50}'

# Respuesta: {"stock": 100, ...} - Status 200 ✓
# Pero el stock NO cambió!!! Sigue en 100
```

### Problema
- El endpoint retorna 200 (parece exitoso)
- Pero el stock NO se actualiza
- Los cambios NO se persisten en MongoDB
- `updatedAt` tampoco se actualiza

### Logs
```
PATCH /api/products/.../stock 200 23ms
Product found: Mouse Logitech M185
Returning product... (sin modificar)
```

### Código de referencia (endpoint que SÍ funciona)

```javascript
// GET /api/products/:id - FUNCIONA ✓
router.get('/:id', async (req, res) => {
  try {
    const productId = req.params.id;
    const product = await Product.findById(productId);
    if (!product) {
      return res.status(404).json({ error: 'Product not found' });
    }
    res.json(product);
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
});
```

### Documentación relevante

```javascript
// Extraer del body
const { stock } = req.body;

// Validar
if (stock === undefined || stock < 0) {
  return res.status(400).json({ error: 'Invalid stock value' });
}

// Actualizar campos
product.stock = 50;
product.updatedAt = new Date();

// Guardar cambios en MongoDB
await product.save();
```

### Código buggy actual

```javascript
// PATCH /api/products/:id/stock - BUGGY
router.patch('/:id/stock', async (req, res) => {
  const productId = req.params.id;
  const product = await Product.findById(productId);

  if (!product) {
    return res.status(404).json({ error: 'Product not found' });
  }

  // BUG: Falta extraer stock del req.body
  // BUG: Falta validar el stock
  // BUG: Falta asignar product.stock = stock
  // BUG: Falta product.updatedAt = new Date()
  // BUG: Falta await product.save()
  // BUG: Falta try-catch

  res.json(product); // Devuelve sin cambios
});
```

### Análisis del dev senior

> "El endpoint encuentra el producto correctamente, pero nunca extrae el stock del req.body, nunca lo asigna, y nunca llama a save(). Solo retorna el producto sin modificar. También falta try-catch y validación."

### Tests a pasar (7)
1. ✅ PATCH /api/products/:id/stock → 200
2. ✅ Actualiza el stock correctamente en la respuesta
3. ✅ Los cambios se persisten en MongoDB
4. ✅ PATCH con ID inexistente → 404
5. ✅ PATCH con stock negativo → 400
6. ✅ Actualiza el campo `updatedAt`
7. ✅ Maneja errores con try-catch → 500
