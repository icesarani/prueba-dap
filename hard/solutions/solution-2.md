# Solution 2: Error al crear producto

## Bug
En el archivo `hard/app/routes/products.js`, falta el keyword `new` al instanciar Product, falta `await` para el save, y no hay manejo de errores.

## Código buggy (original):
```javascript
router.post('/', async (req, res) => {
  const { name, price, stock } = req.body;

  const product = Product({
    name,
    price,
    stock
  });

  product.save();
  res.status(201).json(product);
});
```

## Código corregido:
```javascript
router.post('/', async (req, res) => {
  try {
    const { name, price, stock } = req.body;

    if (!name || price === undefined || stock === undefined) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    const product = new Product({
      name,
      price,
      stock
    });

    await product.save();
    res.status(201).json(product);
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
});
```

## Cambios necesarios:
1. Agregar keyword `new` antes de `Product({...})`
2. Agregar `await` antes de `product.save()`
3. Agregar try-catch para manejo de errores
4. Agregar validación de campos requeridos
5. Devolver status 400 si faltan campos
6. Devolver status 500 en caso de error

## Archivo a modificar:
- `hard/app/routes/products.js` - función del endpoint POST /
