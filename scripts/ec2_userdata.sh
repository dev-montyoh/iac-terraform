#!/bin/bash
dnf update -y

# ----------------------
# Docker 설치
# ----------------------
## Install docker
dnf install docker -y

## Start and enable Docker service
systemctl enable --now docker
usermod -a -G docker ec2-user

# ----------------------
# Docker Compose 설치
# ----------------------
# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/download/v2.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# 앱 디렉토리 생성
mkdir -p /home/ec2-user/app
cd /home/ec2-user/app

# docker-compose.yml 생성
cat <<EOF > docker-compose.yml
version: "3.9"
services:
  nginx:
    image: ghcr.io/dev-montyoh/backend-proxy-server:latest
    ports:
      - "80:80"
EOF

# 컨테이너 실행
docker-compose pull
docker-compose up -d