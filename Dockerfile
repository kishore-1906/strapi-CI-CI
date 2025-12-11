FROM node:18

WORKDIR /app

# Copy package files
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install --legacy-peer-deps

# Copy entire code
COPY . .

# Build Strapi Admin panel
RUN npm run build

EXPOSE 1337

CMD ["npm", "start"]

