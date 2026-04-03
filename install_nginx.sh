#!/bin/bash
apt install -y docker.io
 systemctl start docker
 systemctl enable docker

docker run -d -p 80:80 ${var.image_name}
              
