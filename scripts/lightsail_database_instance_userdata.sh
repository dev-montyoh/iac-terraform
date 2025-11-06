#!/bin/bash
# === System Update ===
apt-get update -y
apt-get upgrade -y

# === Install PostgreSQL ===
apt-get install -y postgresql postgresql-contrib

# === Enable and Start PostgreSQL ===
systemctl enable postgresql
systemctl start postgresql

# Postgresql 이 준비 될 때까지 대기
sudo -u postgres bash -c "until psql -c '\q' 2>/dev/null; do sleep 1; done"

# === 슈퍼유저 비밀번호 설정 ===
sudo -u postgres psql -c "ALTER USER postgres PASSWORD '${DB_PASSWORD}';"

# 유저 생성
sudo -u postgres psql <<EOSQL
-- 유저 생성 (존재하지 않으면)
DO \$\$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '${DB_USERNAME}') THEN
      CREATE ROLE ${DB_USERNAME} WITH LOGIN PASSWORD '${DB_PASSWORD}';
   END IF;
END
\$\$;

-- 데이터베이스 생성 (존재하지 않으면)
DO \$\$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'backend-api-server') THEN
      CREATE DATABASE "backend-api-server" OWNER ${DB_USERNAME}
        ENCODING 'UTF8'
        LC_COLLATE 'C.UTF-8'
        LC_CTYPE 'C.UTF-8'
        TEMPLATE template0;
   END IF;
END
\$\$;

-- 권한 부여
GRANT ALL PRIVILEGES ON DATABASE "backend-api-server" TO ${DB_USERNAME};
EOSQL

# 자동으로 설치된 버전 경로를 사용
PG_CONF="/etc/postgresql/${PG_VERSION}/main/postgresql.conf"
PG_HBA="/etc/postgresql/${PG_VERSION}/main/pg_hba.conf"

# 안전하게 listen_addresses 설정 (주석 라인 교체 혹은 추가)
if grep -q "^#listen_addresses" "$PG_CONF" 2>/dev/null; then
  sed -i "s/^#listen_addresses.*/listen_addresses = '*'/" "$PG_CONF"
else
  # 이미 값이 있으면 대체, 없으면 추가
  if grep -q "^listen_addresses" "$PG_CONF" 2>/dev/null; then
    sed -i "s/^listen_addresses.*/listen_addresses = '*'/" "$PG_CONF"
  else
    echo "listen_addresses = '*'" >> "$PG_CONF"
  fi
fi

# pg_hba: 애플리케이션 유저만 허용 (더 안전)
# 여기가 핵심: 전체 허용 대신 특정 유저/특정 CIDR을 권장합니다.
# 예시: APP_USER 에 대해 전체 IPv4에서 md5 인증 허용 (테스트용)
echo "host    backend-api-server    ${DB_USERNAME}    0.0.0.0/0    md5" >> "$PG_HBA"

# (원한다면 모든 DB/모든 유저를 허용하려면 다음 줄을 추가)
# echo "host    all    all    0.0.0.0/0    md5" >> "$PG_HBA"

# --- 9. PostgreSQL 재시작 ---
systemctl restart postgresql

# --- 10. 최종 확인 메시지 (로그에 남김) ---
echo "Postgres setup complete. DB=backend-api-server, USER=${DB_USERNAME}"
