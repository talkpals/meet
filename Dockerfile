FROM node:23-bullseye-slim

# Set working directory
WORKDIR /app

# Install pnpm globally
RUN npm install -g pnpm

# Copy all project files at once
COPY . .

# Install project dependencies
RUN pnpm install

# Command to run the development server
CMD ["pnpm", "start"]
