const request = require('supertest');
const mongoose = require('mongoose');
const app = require('../app/server');
const Product = require('../app/models/Product');

describe('Problem 3: PATCH /api/products/:id/stock', () => {
  let testProductId;

  beforeAll(async () => {
    // Connect to test database
    const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/hardlevel_test';
    await mongoose.connect(MONGODB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true
    });
  });

  afterAll(async () => {
    await Product.deleteMany({});
    await mongoose.connection.close();
  });

  beforeEach(async () => {
    await Product.deleteMany({});
    const product = await Product.create({
      name: 'Mouse',
      price: 25,
      stock: 100
    });
    testProductId = product._id.toString();
  });

  test('El endpoint compila sin errores', () => {
    expect(true).toBe(true);
  });

  test('PATCH /api/products/:id/stock devuelve status 200', async () => {
    const response = await request(app)
      .patch(`/api/products/${testProductId}/stock`)
      .send({ stock: 50 })
      .expect('Content-Type', /json/);

    expect(response.status).toBe(200);
  });

  test('PATCH /api/products/:id/stock actualiza el stock correctamente', async () => {
    const response = await request(app)
      .patch(`/api/products/${testProductId}/stock`)
      .send({ stock: 50 })
      .expect(200);

    expect(response.body.stock).toBe(50);
  });

  test('PATCH /api/products/:id/stock persiste el cambio en la base de datos', async () => {
    await request(app)
      .patch(`/api/products/${testProductId}/stock`)
      .send({ stock: 75 })
      .expect(200);

    const updatedProduct = await Product.findById(testProductId);
    expect(updatedProduct.stock).toBe(75);
  });

  test('PATCH /api/products/999999999999999999999999/stock devuelve status 404 para producto inexistente', async () => {
    const response = await request(app)
      .patch('/api/products/999999999999999999999999/stock')
      .send({ stock: 50 })
      .expect('Content-Type', /json/);

    expect(response.status).toBe(404);
  });

  test('PATCH /api/products/:id/stock con stock negativo devuelve status 400', async () => {
    const response = await request(app)
      .patch(`/api/products/${testProductId}/stock`)
      .send({ stock: -10 })
      .expect('Content-Type', /json/);

    expect(response.status).toBe(400);
  });

  test('PATCH /api/products/:id/stock actualiza el campo updatedAt', async () => {
    const originalProduct = await Product.findById(testProductId);
    const originalUpdatedAt = originalProduct.updatedAt;

    // Wait a bit to ensure time difference
    await new Promise(resolve => setTimeout(resolve, 100));

    const response = await request(app)
      .patch(`/api/products/${testProductId}/stock`)
      .send({ stock: 60 })
      .expect(200);

    expect(new Date(response.body.updatedAt).getTime()).toBeGreaterThan(originalUpdatedAt.getTime());
  });
});
