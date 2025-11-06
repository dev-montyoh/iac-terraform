#!/bin/bash
# 이 스크립트는 apt 패키지 관리자를 사용하는 Ubuntu/Debian 기반 시스템용입니다.

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
DB_NAME="backend-api-server"

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

# === 3. 데이터베이스 생성 (Bash 조건문 사용: CREATE DATABASE는 DO 블록에서 실행 불가) ===
db_exists() {
    sudo -u postgres psql -tAc "SELECT 1 FROM pg_database WHERE datname='${DB_NAME}'" | grep -q 1
}

if ! db_exists; then
    sudo -u postgres psql -c "CREATE DATABASE \"${DB_NAME}\" OWNER ${DB_USERNAME} ENCODING 'UTF8' LC_COLLATE 'C.UTF-8' LC_CTYPE 'C.UTF-8' TEMPLATE template0;"
    # 데이터베이스 생성 후 권한 부여
    sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE \"${DB_NAME}\" TO ${DB_USERNAME};"
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

# === 5. pg_hba.conf 수정: 애플리케이션 유저에 대해 접속 허용 ===
# host 타입, DB 이름, 유저 이름, 허용할 IP 대역 (0.0.0.0/0은 전체 허용), 인증 방식 (md5)
echo "host    ${DB_NAME}    ${DB_USERNAME}    0.0.0.0/0    md5" >> "$PG_HBA"

# === 6. PostgreSQL 재시작 (설정 적용) ===
systemctl restart postgresql

# === 7. 최종 확인 메시지 ===
echo "Postgres setup complete. DB=${DB_NAME}, USER=${DB_USERNAME}"