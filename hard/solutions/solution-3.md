# Solution 3: Actualización de stock incorrecta

## Bug
En el archivo `hard/app/routes/products.js`, el endpoint PATCH /:id/stock no lee correctamente el body, no actualiza el campo, y no guarda los cambios.

## Código buggy (original):
```javascript
router.patch('/:id/stock', async (req, res) => {
  const productId = req.params.id;
  const product = await Product.findById(productId);

  if (!product) {
    return res.status(404).json({ error: 'Product not found' });
  }

  res.json(product);
});
```

## Código corregido:
```javascript
router.patch('/:id/stock', async (req, res) => {
  try {
    const productId = req.params.id;
    const { stock } = req.body;

    if (stock === undefined || stock < 0) {
      return res.status(400).json({ error: 'Invalid stock value' });
    }

    const product = await Product.findById(productId);

    if (!product) {
      return res.status(404).json({ error: 'Product not found' });
    }

    product.stock = stock;
    product.updatedAt = new Date();
    await product.save();

    res.json(product);
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
});
```

## Cambios necesarios:
1. Extraer `stock` del `req.body` con destructuring
2. Agregar validación de que stock no sea undefined y no sea negativo
3. Asignar el nuevo valor: `product.stock = stock`
4. Actualizar `product.updatedAt = new Date()`
5. Agregar `await product.save()` para persistir cambios
6. Agregar try-catch para manejo de errores
7. Devolver status 400 si el stock es inválido
8. Devolver status 500 en caso de error

## Archivo a modificar:
- `hard/app/routes/products.js` - función del endpoint PATCH /:id/stock
