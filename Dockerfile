FROM node:20

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm install --legacy-peer-deps

COPY . .

RUN npm run build

EXPOSE 1337

CMD ["npm", "start"]

