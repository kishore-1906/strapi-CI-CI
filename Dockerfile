FROM node:20

WORKDIR /app

# 1. Copy only package files
COPY package.json package-lock.json ./

# 2. Install esbuild BEFORE npm install
RUN npm install esbuild --ignore-scripts

# 3. Install project deps
RUN npm install --legacy-peer-deps

# 4. Copy full project
COPY . .

# 5. Build admin
RUN npm run build

EXPOSE 1337

CMD ["npm", "start"]

