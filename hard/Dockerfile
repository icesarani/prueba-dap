FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY app/package*.json ./

# Install dependencies
RUN npm install

# Copy application code
COPY app/ ./

# Copy tests
COPY tests/ ./tests/
COPY jest.config.js ./

# Expose port
EXPOSE 3000

# Default command
CMD ["npm", "start"]
