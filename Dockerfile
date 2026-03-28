# ---------- Builder ----------
FROM node:20-alpine AS builder

WORKDIR /server

COPY package.json package-lock.json ./
RUN npm ci --legacy-peer-deps

COPY . .

ENV NODE_ENV=production

# Create the Medusa production build
RUN npx medusa build

# ---------- Runner ----------
FROM node:20-alpine AS runner

WORKDIR /server/.medusa/server

# Copy built output only
COPY --from=builder /server/.medusa/server /server/.medusa/server

# Install runtime dependencies for the built app
RUN npm ci --omit=dev --legacy-peer-deps

# Copy startup script
COPY start-prod.sh /start-prod.sh
RUN sed -i 's/\r$//' /start-prod.sh && chmod +x /start-prod.sh

EXPOSE 9000

ENTRYPOINT ["/start-prod.sh"]