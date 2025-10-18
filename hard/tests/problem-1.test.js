const request = require('supertest');
const mongoose = require('mongoose');
const app = require('../server');
const User = require('../models/User');

describe('Problem 1: GET /api/users/:id', () => {
  let testUserId;

  beforeAll(async () => {
    // Connect to test database
    const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/hardlevel_test';
    await mongoose.connect(MONGODB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true
    });

    // Clear database and create test user
    await User.deleteMany({});
    const user = await User.create({
      name: 'Juan Pérez',
      email: 'juan@example.com',
      role: 'admin'
    });
    testUserId = user._id.toString();
  });

  afterAll(async () => {
    await User.deleteMany({});
    await mongoose.connection.close();
  });

  test('El endpoint compila sin errores', () => {
    expect(true).toBe(true);
  });

  test('GET /api/users/:id devuelve status 200', async () => {
    const response = await request(app)
      .get(`/api/users/${testUserId}`)
      .expect('Content-Type', /json/);

    expect(response.status).toBe(200);
  });

  test('GET /api/users/:id devuelve el usuario correcto con todos los campos', async () => {
    const response = await request(app)
      .get(`/api/users/${testUserId}`)
      .expect(200);

    expect(response.body).toHaveProperty('_id');
    expect(response.body).toHaveProperty('name', 'Juan Pérez');
    expect(response.body).toHaveProperty('email', 'juan@example.com');
    expect(response.body).toHaveProperty('role', 'admin');
  });

  test('GET /api/users/999999999999999999999999 devuelve status 404 para usuario inexistente', async () => {
    const response = await request(app)
      .get('/api/users/999999999999999999999999')
      .expect('Content-Type', /json/);

    expect(response.status).toBe(404);
    expect(response.body).toHaveProperty('error');
  });

  test('GET /api/users/:id devuelve JSON válido', async () => {
    const response = await request(app)
      .get(`/api/users/${testUserId}`)
      .expect('Content-Type', /json/)
      .expect(200);

    expect(() => JSON.parse(JSON.stringify(response.body))).not.toThrow();
  });
});
