# Stage 1: Builder - Install all dependencies and generate Prisma Client
FROM node:20-alpine AS builder
WORKDIR /app

# Copy package files and install all dependencies (including dev for prisma)
COPY package*.json ./
RUN npm install

# Copy prisma schema and generate the client
COPY prisma ./prisma
RUN npx prisma generate

# Stage 2: Production - Create the final lean image
FROM node:20-alpine
WORKDIR /app

# Copy package files and install only production dependencies
COPY package*.json ./
RUN npm ci --omit=dev

# Copy the application source code, including the server, src, and dist folders
COPY . .

# Copy the generated Prisma Client from the builder stage
# This ensures the client is available in the final image
COPY --from=builder /app/node_modules/.prisma ./node_modules/.prisma

# The application expects an 'uploads' directory to exist.
# This command creates it so the app doesn't fail on startup.
RUN mkdir -p uploads

# Expose the port the app runs on
EXPOSE 3000

# The command to start the application
CMD ["node", "server.js"]