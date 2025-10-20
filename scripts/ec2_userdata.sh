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
# Redis Docker 컨테이너 실행
# ----------------------
#mkdir -p /home/ec2-user/redis-data
#
#docker run -d \
#  --name dev-monty-redis \
#  -p 4002:6379 \
#  -v /home/ec2-user/redis-data:/data \
#  --restart unless-stopped \
#  redis:6 \
#  redis-server --appendonly yes