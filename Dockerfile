# Stage 1: Build application
FROM node:20-alpine AS builder

WORKDIR /app

# Copy dependency definition files first to leverage build cache
COPY package.json package-lock.json ./
RUN npm ci

# Copy the rest of the application source code
COPY . .

# Build the React application using Vite
RUN npm run build

# Stage 2: Serve application with Nginx
FROM nginx:alpine

# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Copy production build assets from the builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Setup ownership and permissions so Nginx can run as the non-root 'nginx' user
RUN touch /tmp/nginx.pid && \
    chown -R nginx:nginx /tmp/nginx.pid /usr/share/nginx/html /var/cache/nginx /var/log/nginx /etc/nginx/conf.d

# Switch to the non-root 'nginx' user
USER nginx

# Expose the non-privileged port
EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
