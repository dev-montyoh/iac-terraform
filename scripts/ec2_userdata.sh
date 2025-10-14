#!/bin/bash
dnf update -y

# MySQL 설치
## install mysql yum repository
dnf install https://dev.mysql.com/get/mysql80-community-release-el9-5.noarch.rpm -y

## install mysql-server@8.0
dnf install mysql-community-server -y

## mysql 실행 설정
sed -i 's/^port.*/port=4001/' /etc/my.cnf
sed -i 's/^bind-address.*/bind-address=0.0.0.0/' /etc/my.cnf
systemctl enable --now mysqld

# Redis 설치
## install redis6
dnf install redis6 -y

## redis 실행 설정
sed -i 's/^port .*/port 4002/' /etc/redis6.conf
sed -i 's/^bind .*/bind 0.0.0.0/' /etc/redis6.conf
sed -i 's/^protected-mode .*/protected-mode no/' /etc/redis6.conf
systemctl enable --now redis6

# Docker 설치
## Install docker
dnf install docker -y

## Start and enable Docker service
systemctl enable --now docker
usermod -a -G docker ec2-user
