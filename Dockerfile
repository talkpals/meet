FROM node:20-alpine AS base

# Install pnpm
RUN npm install -g pnpm

# Set working directory
WORKDIR /app

# Build stage
FROM base AS builder
WORKDIR /app

# Copy package files first to leverage Docker cache
COPY package.json pnpm-lock.yaml* ./

# Install dependencies (including dev dependencies)
RUN pnpm install --frozen-lockfile

# Copy the rest of the source files
COPY . .

# Set environment variables
ENV NEXT_TELEMETRY_DISABLED 1

# Build the application with production optimization
RUN NEXT_COMPRESS=true pnpm build

# Production stage
FROM base AS runner
WORKDIR /app

ENV NODE_ENV production
ENV NEXT_TELEMETRY_DISABLED 1

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Copy necessary files from the build stage
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/pnpm-lock.yaml ./pnpm-lock.yaml
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static

# Install ONLY production dependencies and prune
RUN pnpm install --prod --frozen-lockfile && pnpm prune --prod

# Set permissions
RUN chown -R nextjs:nodejs /app

USER nextjs

EXPOSE 3000

ENV PORT 3000
ENV HOSTNAME "0.0.0.0"

# Start the app with optimized Node.js flags
CMD ["node", "--max-old-space-size=512", "server.js"]