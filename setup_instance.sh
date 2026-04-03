#!/bin/bash
# Update & install Docker
sudo apt-get update -y
sudo apt-get install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker

# Optional: install Nginx inside Docker container
sudo docker pull nginx:latest
sudo docker run -d -p 80:80 --name terraform-nginx nginx:latest
