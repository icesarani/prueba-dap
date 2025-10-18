# Problem 2: POST /api/products crashea el servidor

## Bug Report #4598 - CRÍTICO

**Archivo:** `routes/products.js`
**Endpoint:** `POST /api/products`

### Síntoma
```bash
curl -X POST http://localhost:3000/api/products \
  -H "Content-Type: application/json" \
  -d '{"name": "Laptop", "price": 1200, "stock": 10}'

# Respuesta: {"error": "Internal server error"} - Status 500
# El servidor crashea y requiere reinicio
```

### Stack trace
```
TypeError: Cannot read property 'save' of undefined
    at /app/routes/products.js:32:13
POST /api/products 500 45ms
[Server crashed - restart required]
```

### Contexto
- El endpoint `GET /api/products` funciona ✓
- El body se parsea correctamente
- El error ocurre al llamar `.save()` en un objeto `undefined`

### Código de referencia (endpoint que SÍ funciona)

```javascript
// POST /api/users - FUNCIONA ✓
router.post('/', async (req, res) => {
  try {
    const { name, email, role } = req.body;
    if (!name || !email) {
      return res.status(400).json({ error: 'Name and email are required' });
    }
    const user = new User({ name, email, role });
    await user.save();
    res.status(201).json(user);
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
});
```

### Documentación Mongoose

```javascript
// ✓ CORRECTO - Usar 'new' keyword
const product = new Product({ name: 'Laptop', price: 1200 });
await product.save();

// ✗ INCORRECTO - Sin 'new' (product será undefined)
const product = Product({ name: 'Laptop', price: 1200 });
await product.save(); // ERROR: Cannot read property 'save' of undefined
```

### Análisis del dev senior

> "Error clásico de Mongoose: falta el keyword `new` al instanciar Product, por eso product es undefined. También falta `await` antes de save(), try-catch para no crashear, y validación de campos requeridos."

### Tests a pasar (6)
1. ✅ POST /api/products con datos válidos → 201
2. ✅ Crea el producto con todos los campos
3. ✅ POST con datos inválidos/faltantes → 400 (no crashea)
4. ✅ El producto se persiste en MongoDB
5. ✅ Maneja errores con try-catch → 500
6. ✅ Compila sin errores
