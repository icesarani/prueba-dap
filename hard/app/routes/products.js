const express = require('express');
const router = express.Router();
const Product = require('../models/Product');

// GET /api/products - List all products
router.get('/', async (req, res) => {
  try {
    const products = await Product.find();
    res.json(products);
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
});

// GET /api/products/:id - Get product by ID
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

// POST /api/products - Create new product
// BUG: This endpoint has a bug - missing 'new' keyword and 'await'
router.post('/', async (req, res) => {
  const { name, price, stock } = req.body;

  const product = Product({
    name,
    price,
    stock
  });

  product.save(); // Bug: falta await
  res.status(201).json(product);
});

// PATCH /api/products/:id/stock - Update product stock
// BUG: This endpoint has a bug - doesn't update or save the stock
router.patch('/:id/stock', async (req, res) => {
  const productId = req.params.id;
  const product = await Product.findById(productId);

  if (!product) {
    return res.status(404).json({ error: 'Product not found' });
  }

  // Bug: no lee el stock del body, no actualiza el campo, no guarda
  res.json(product);
});

module.exports = router;
