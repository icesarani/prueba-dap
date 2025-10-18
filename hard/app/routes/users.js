const express = require('express');
const router = express.Router();
const User = require('../models/User');

// GET /api/users - List all users
router.get('/', async (req, res) => {
  try {
    const users = await User.find();
    res.json(users);
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
});

// GET /api/users/:id - Get user by ID
// BUG: This endpoint has a bug - it doesn't search by ID correctly
router.get('/:id', async (req, res) => {
  const userId = req.params.id;
  const user = User.findOne(); // Bug: no busca por ID y falta await

  if (!user) {
    return res.status(404).json({ error: 'User not found' });
  }

  res.json(user);
});

// POST /api/users - Create new user
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

module.exports = router;
