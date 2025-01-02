#!/bin/bash
yum update -y

# install mysql yum repository
yum install https://dev.mysql.com/get/mysql80-community-release-el9-5.noarch.rpm -y

# install mysql-server@8.0
yum install mysql-community-server -y

# mysql 실행 설정
systemctl start mysqld
systemctl enable --now mysqld