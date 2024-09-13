// test.js

const request = require('supertest');
const expressApp = require('../index');

describe('Integration tests for Express server setup', () => {
  let app;

  beforeAll(() => {
    app = expressApp; 
  });

  it('should return 200 status code for GET /', async () => {
    const response = await request(app).get('/');
    expect(response.statusCode).toBe(200);
  });

  it('should return 404 status code for undefined routes', async () => {
    const response = await request(app).get('/undefined-route');
    expect(response.statusCode).toBe(404);
  });

  
});
