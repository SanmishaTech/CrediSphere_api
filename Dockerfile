# CrediSphere API Dockerfile
# Builds a lightweight production image running on Node.js 20

FROM node:20-alpine

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm ci --omit=dev

# Copy application source
COPY . .

# Expose API port
EXPOSE 3000

# Start the server
CMD ["node", "server.js"]