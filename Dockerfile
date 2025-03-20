FROM node:20-slim

# Set working directory
WORKDIR /app

# Copy package files for better caching
COPY package.json pnpm-lock.yaml* ./

# Install pnpm globally
RUN npm install -g pnpm

# Install project dependencies
RUN pnpm install

# Copy the rest of the project
COPY . .

# Command to run the development server
CMD ["pnpm", "dev"]
