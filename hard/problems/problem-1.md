# Problem 1: GET /api/users/:id siempre retorna 404

## Bug Report #4521

**Archivo:** `routes/users.js`
**Endpoint:** `GET /api/users/:id`

### Síntoma
```bash
curl http://localhost:3000/api/users/507f1f77bcf86cd799439011
# Respuesta: {"error": "User not found"} - Status 404
```

Aunque el usuario existe en la DB, siempre retorna 404.

### Logs del servidor
```
Request received: GET /api/users/507f1f77bcf86cd799439011
User query executed
Result: null
Returning 404 - User not found
```

### Contexto
- El endpoint `GET /api/users` (listar todos) funciona ✓
- El endpoint `POST /api/users` (crear) funciona ✓
- Solo falla el endpoint con parámetro `:id`

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
// Buscar por ID
const user = await User.findById(userId);

// Buscar con condición
const user = await User.findOne({ email: 'test@example.com' });
```

### Análisis del dev senior

> "El endpoint usa `User.findOne()` sin parámetros, lo cual retorna null. Debe usar `User.findById(req.params.id)`. También falta `await` y try-catch."

### Tests a pasar (5)
1. ✅ GET /api/users/:id con ID válido → 200
2. ✅ Retorna usuario completo con todos sus campos
3. ✅ GET /api/users/:id con ID inexistente → 404
4. ✅ Maneja errores con try-catch → 500
5. ✅ Compila sin errores
