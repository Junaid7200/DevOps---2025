const http = require('http');
const promClient = require('prom-client');

// Create a Registry to register metrics
const register = new promClient.Registry();

// Create a counter metric
const httpRequestsTotal = new promClient.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'status'],
});

// Register the metric
register.registerMetric(httpRequestsTotal);

// Add a default metric
register.setDefaultLabels({
  app: 'node-app'
});

// Enable the default metrics
promClient.collectDefaultMetrics({ register });

// Create HTTP server
const server = http.createServer((req, res) => {
  httpRequestsTotal.inc({ method: req.method, status: 200 });
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end('Hello from Node.js!\n');
});

// Expose metrics endpoint
server.on('request', (req, res) => {
  if (req.url === '/metrics') {
    res.setHeader('Content-Type', register.contentType);
    register.metrics().then(metrics => res.end(metrics));
  }
});

server.listen(3000, () => console.log('Server running on port 3000'));