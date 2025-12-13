# -------- Build stage --------
FROM node:20-alpine AS build

WORKDIR /app

# Required for native modules like better-sqlite3
RUN apk add --no-cache python3 make g++

COPY package.json package-lock.json ./
RUN npm install

COPY . .

RUN npm run build


# -------- Runtime stage --------
FROM node:20-alpine

WORKDIR /app

ENV NODE_ENV=production

COPY --from=build /app ./

EXPOSE 1337

CMD ["npm", "start"]

