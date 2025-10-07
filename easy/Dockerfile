FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy evaluation scripts (now relative to easy directory)
COPY evaluation-scripts /app/evaluation-scripts

# Make scripts executable
RUN chmod +x /app/evaluation-scripts/*.js

# Set the entrypoint to node
ENTRYPOINT ["node"]