# ============================================
# Dockerfile - React Todo App
# Author: Farah Naaz
# Description: Dockerizes the React app
#              Contains only the build files
#              Served using nginx on port 3000
# ============================================

# Stage 1: Build the React app
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# Stage 2: Serve with Nginx (only build files)
FROM nginx:alpine

COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 3000

CMD ["nginx", "-g", "daemon off;"]
