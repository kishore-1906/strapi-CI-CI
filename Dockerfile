FROM node:18-alpine

# Install required OS packages
RUN apk add --no-cache build-base python3 sqlite-dev

WORKDIR /app

# Copy package files
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install --legacy-peer-deps

# Copy all project files
COPY . .

# Build Strapi admin panel
RUN npm run build

EXPOSE 1337

CMD ["npm", "start"]

