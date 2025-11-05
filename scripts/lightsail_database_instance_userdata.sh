#!/bin/bash
# === System Update ===
apt-get update -y
apt-get upgrade -y

# === Install PostgreSQL ===
apt-get install -y postgresql postgresql-contrib

# === Enable and Start PostgreSQL ===
systemctl enable postgresql
systemctl start postgresql

# === Set PostgreSQL Password ===
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'your_password_here';"

# === Allow remote connections ===
echo "listen_addresses = '*'" >> /etc/postgresql/*/main/postgresql.conf
echo "host all all 0.0.0.0/0 md5" >> /etc/postgresql/*/main/pg_hba.conf
systemctl restart postgresql
