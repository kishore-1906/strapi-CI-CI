FROM node:18-alpine

# Install OS dependencies required by Strapi & bcrypt
RUN apk add --no-cache build-base python3

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install --legacy-peer-deps

COPY . .
RUN npm run build

EXPOSE 1337

CMD ["npm", "start"]

