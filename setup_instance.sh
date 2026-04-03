#!/bin/bash
# Update & install Docker
apt-get update -y
apt-get install -y docker.io
systemctl start docker
systemctl enable docker

# Login to Docker Hub
docker login -u $DOCKERHUB_USERNAME -p $DOCKERHUB_PASSWORD

# Pull and run your image
docker pull pravinyadav20/terraform-app:latest
docker run -d -p 80:80 pravinyadav20/terraform-app:latest

# Start NGINX if needed
systemctl start nginx
systemctl enable nginx
