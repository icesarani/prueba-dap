const request = require('supertest');
const mongoose = require('mongoose');
const app = require('../app/server');
const Product = require('../app/models/Product');

describe('Problem 2: POST /api/products', () => {
  beforeAll(async () => {
    // Connect to test database
    const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/hardlevel_test';
    await mongoose.connect(MONGODB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true
    });

    // Clear products
    await Product.deleteMany({});
  });

  afterAll(async () => {
    await Product.deleteMany({});
    await mongoose.connection.close();
  });

  beforeEach(async () => {
    await Product.deleteMany({});
  });

  test('El endpoint compila sin errores', () => {
    expect(true).toBe(true);
  });

  test('POST /api/products devuelve status 201', async () => {
    const response = await request(app)
      .post('/api/products')
      .send({
        name: 'Laptop',
        price: 1200,
        stock: 10
      })
      .expect('Content-Type', /json/);

    expect(response.status).toBe(201);
  });

  test('POST /api/products crea el producto correctamente con todos los campos', async () => {
    const response = await request(app)
      .post('/api/products')
      .send({
        name: 'Laptop',
        price: 1200,
        stock: 10
      })
      .expect(201);

    expect(response.body).toHaveProperty('_id');
    expect(response.body).toHaveProperty('name', 'Laptop');
    expect(response.body).toHaveProperty('price', 1200);
    expect(response.body).toHaveProperty('stock', 10);
    expect(response.body).toHaveProperty('createdAt');
  });

  test('POST /api/products con datos inválidos devuelve status 400', async () => {
    const response = await request(app)
      .post('/api/products')
      .send({
        price: 1200
        // Missing name and stock
      })
      .expect('Content-Type', /json/);

    expect(response.status).toBe(400);
  });

  test('POST /api/products devuelve el producto creado en formato JSON', async () => {
    const response = await request(app)
      .post('/api/products')
      .send({
        name: 'Mouse',
        price: 25,
        stock: 50
      })
      .expect('Content-Type', /json/)
      .expect(201);

    expect(() => JSON.parse(JSON.stringify(response.body))).not.toThrow();
  });

  test('El producto se guarda correctamente en la base de datos', async () => {
    const response = await request(app)
      .post('/api/products')
      .send({
        name: 'Keyboard',
        price: 80,
        stock: 30
      })
      .expect(201);

    const savedProduct = await Product.findById(response.body._id);
    expect(savedProduct).not.toBeNull();
    expect(savedProduct.name).toBe('Keyboard');
    expect(savedProduct.price).toBe(80);
    expect(savedProduct.stock).toBe(30);
  });
});
