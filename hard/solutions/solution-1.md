# Solution 1: Usuario no encontrado

## Bug
En el archivo `hard/app/routes/users.js`, la query usa `User.findOne()` sin parámetros en lugar de buscar por ID.

## Código buggy (original):
```javascript
router.get('/:id', async (req, res) => {
  const userId = req.params.id;
  const user = User.findOne(); // Bug: no busca por ID

  if (!user) {
    return res.status(404).json({ error: 'User not found' });
  }

  res.json(user);
});
```

## Código corregido:
```javascript
router.get('/:id', async (req, res) => {
  try {
    const userId = req.params.id;
    const user = await User.findById(userId);

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.json(user);
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
});
```

## Cambios necesarios:
1. Cambiar `User.findOne()` por `User.findById(userId)`
2. Agregar `await` antes de la llamada a findById
3. Agregar try-catch para manejo de errores
4. Devolver status 500 en caso de error

## Archivo a modificar:
- `hard/app/routes/users.js` - función del endpoint GET /:id
