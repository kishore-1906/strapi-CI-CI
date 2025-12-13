#!/bin/bash
set -e

echo "---- Updating system ----"
apt update -y

echo "---- Installing Docker ----"
apt install -y docker.io
systemctl enable docker
systemctl start docker

# Optional but good practice
usermod -aG docker ubuntu || true

echo "---- Pulling Strapi image ----"
docker pull kishore190/strapi-app:latest

echo "---- Stopping old Strapi container ----"
docker stop strapi || true
docker rm strapi || true

echo "---- Running new Strapi container ----"
docker run -d \
  --name strapi \
  -p 1337:1337 \
  -e NODE_ENV=production \
  -e APP_KEYS="key1,key2,key3,key4" \
  -e API_TOKEN_SALT="randomapitokensalt123" \
  -e ADMIN_JWT_SECRET="adminjwtsecret12345" \
  -e JWT_SECRET="jwtsecret12345" \
  -e TRANSFER_TOKEN_SALT="transfersalt123" \
  kishore190/strapi-app:latest

echo "---- Deployment Completed ----"

