#!/bin/bash
apt-get update -y


# ----------------------
# Docker 설치
# ----------------------
apt-get install -y ca-certificates curl gnupg
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io

systemctl enable --now docker
usermod -a -G docker ubuntu


# ----------------------
# Github Registry 세팅
# ----------------------
echo "${AWS_EC2_USERDATA_GHCR_TOKEN}" | docker login ghcr.io -u dev-montyoh --password-stdin


# ----------------------
# Docker Compose 설치 및 실행
# ----------------------
curl -L "https://github.com/docker/compose/releases/download/v2.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

mkdir -p /home/ubuntu/app
chown -R ubuntu:ubuntu /home/ubuntu/app

su - ubuntu <<'EOF'

    cd /home/ubuntu/app

    curl -L -o docker-compose.yml https://raw.githubusercontent.com/dev-montyoh/iac-terraform/refs/heads/master/docker-compose.yml
    docker-compose pull
    docker-compose up -d

EOF
