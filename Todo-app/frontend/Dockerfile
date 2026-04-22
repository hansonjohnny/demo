# ---------- Stage 1: Build React App ----------
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

# Build static files
RUN npm run build

# ---------- Stage 2: Serve with Nginx ----------
FROM nginx:alpine

COPY --from=builder /app/build /usr/share/nginx/html

# Run as non-root user
RUN chown -R nginx:nginx /usr/share/nginx/html
USER nginx

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]