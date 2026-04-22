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

# Copy build output to nginx
COPY --from=builder /app/build /usr/share/nginx/html

# Expose port
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]