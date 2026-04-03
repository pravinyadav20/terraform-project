#!/bin/bash

# Update & install Docker
apt-get update -y
apt-get install -y docker.io
systemctl start docker
systemctl enable docker

# Login to Docker Hub
docker login -u $DOCKERHUB_USERNAME -p $DOCKERHUB_PASSWORD

# Remove old container if exists
sudo docker rm -f terraform-app || true
sudo systemctl stop nginx
sudo systemctl disable nginx

# Pull and run your image
docker pull pravinyadav20/terraform-app:latest
sudo docker run -d -p 80:80 --name terraform-app pravinyadav20/terraform-app:latest

# Only start NGINX if you plan to reverse proxy Docker container
# Otherwise skip this to avoid port conflict
# systemctl start nginx
# systemctl enable nginx
