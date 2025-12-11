#!/bin/bash
set -e

echo "---- Updating system ----"
apt-get update -y

echo "---- Installing Docker ----"
apt-get install -y docker.io

systemctl enable docker
systemctl start docker

echo "---- Pulling Strapi image ----"
docker pull ${dockerhub_username}/strapi-app:${image_tag}

echo "---- Stopping old Strapi container ----"
docker rm -f strapi || true

echo "---- Running new Strapi container ----"
docker run -d \
  --name strapi \
  -p 1337:1337 \
  ${dockerhub_username}/strapi-app:${image_tag}

echo "---- Deployment Completed ----"

