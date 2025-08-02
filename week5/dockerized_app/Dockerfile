FROM node:16
WORKDIR /app
COPY package.json .
RUN npm install prometheus-api-metrics
COPY server.js .
EXPOSE 3000
CMD ["node", "server.js"]