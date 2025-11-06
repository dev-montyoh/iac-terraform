#!/bin/bash

# 환경 변수가 외부에서 설정되지 않았다면, 여기에 기본값을 설정해야 합니다.
# export DB_USERNAME="your_app_user"
# export DB_PASSWORD="your_secure_password"

# === 시스템 업데이트 ===
apt-get update -y
apt-get upgrade -y

# === PostgreSQL 설치 ===
apt-get install -y postgresql postgresql-contrib

# === PostgreSQL 서비스 활성화 및 시작 ===
systemctl enable postgresql
systemctl start postgresql

# PostgreSQL 이 준비될 때까지 대기
sudo -u postgres bash -c "until psql -c '\q' 2>/dev/null; do sleep 1; done"

# === PostgreSQL 버전 동적 확인 및 설정 경로 지정 ===
# 설치된 버전을 확인하여 PG_VERSION 설정
PG_CONF="/etc/postgresql/${PG_VERSION}/main/postgresql.conf"
PG_HBA="/etc/postgresql/${PG_VERSION}/main/pg_hba.conf"

# === 1. 슈퍼유저 비밀번호 설정 ===
sudo -u postgres psql -c "ALTER USER postgres PASSWORD '${DB_PASSWORD}';"

# === 2. 애플리케이션 유저 생성 (존재하지 않으면) ===
sudo -u postgres psql <<EOSQL_USER
DO \$\$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '${DB_USERNAME}') THEN
      CREATE ROLE ${DB_USERNAME} WITH LOGIN PASSWORD '${DB_PASSWORD}';
   END IF;
END
\$\$;
EOSQL_USER

# === 3. 데이터베이스 생성 (Bash 조건문 사용: DB 이름을 직접 입력) ===
db_exists() {
    # DB 이름을 "backend-api-server"로 직접 확인
    sudo -u postgres psql -tAc "SELECT 1 FROM pg_database WHERE datname='backend-api-server'" | grep -q 1
}

if ! db_exists; then
    # DB 이름을 "backend-api-server"로 직접 생성
    sudo -u postgres psql -c "CREATE DATABASE \"backend-api-server\" OWNER ${DB_USERNAME} ENCODING 'UTF8' LC_COLLATE 'C.UTF-8' LC_CTYPE 'C.UTF-8' TEMPLATE template0;"
    # DB 이름을 "backend-api-server"로 직접 권한 부여
    sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE \"backend-api-server\" TO ${DB_USERNAME};"
fi

# === 4. postgresql.conf 수정: 외부 접속 허용 (listen_addresses = '*') ===
if grep -q "^#listen_addresses" "$PG_CONF" 2>/dev/null; then
  sed -i "s/^#listen_addresses.*/listen_addresses = '*'/" "$PG_CONF"
else
  if grep -q "^listen_addresses" "$PG_CONF" 2>/dev/null; then
    sed -i "s/^listen_addresses.*/listen_addresses = '*'/" "$PG_CONF"
  else
    echo "listen_addresses = '*'" >> "$PG_CONF"
  fi
fi

# === 5. pg_hba.conf 수정: 애플리케이션 유저에 대해 접속 허용 (DB 이름 직접 입력) ===
echo "host    backend-api-server    ${DB_USERNAME}    0.0.0.0/0    md5" >> "$PG_HBA"

# === 6. PostgreSQL 재시작 (설정 적용) ===
systemctl restart postgresql

# === 7. 최종 확인 메시지 (DB 이름 직접 입력) ===
echo "Postgres setup complete. DB=backend-api-server, USER=${DB_USERNAME}"