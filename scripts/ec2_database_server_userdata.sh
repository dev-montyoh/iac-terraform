#!/bin/bash
dnf update -y

# MySQL 설치
## install mysql yum repository
dnf install https://dev.mysql.com/get/mysql80-community-release-el9-5.noarch.rpm -y

## install mysql-server@8.0
dnf install mysql-community-server -y

## mysql 실행 설정
systemctl start mysqld
systemctl enable --now mysqld

# Redis 설치
## install redis6
dnf install redis6 -y

## redis 실행 설정
systemctl start redis6
systemctl enable --now redis6