const http = require('http');
const prom = require('prometheus-api-metrics');

prom();
const server = http.createServer((req, res) => {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end('Hello from Node.js!\n');
});

server.listen(3000, () => console.log('Server running on port 3000'));