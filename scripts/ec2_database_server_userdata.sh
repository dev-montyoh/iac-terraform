#!/bin/bash
yum update -y

# install mysql yum repository
yum install https://dev.mysql.com/get/mysql80-community-release-el9-5.noarch.rpm -y

# install mysql-server@8.0
yum install mysql-community-server -y

systemctl start mysqld
systemctl enable --now mysqld

# 임시 비밀번호 확인
grep 'temporary password' /var/log/mysqld.log