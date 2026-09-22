#!/bin/bash
set -e
REPO="https://raw.githubusercontent.com/shiraorie/demo-2027/main/files"
VER="15.0.3"
PREFIX="/opt/bacula"

apt update
apt install -y build-essential curl libpq-dev postgresql postgresql-client libssl-dev zlib1g-dev libreadline-dev libncurses5-dev
systemctl enable --now postgresql

cd /usr/local/src
[ -f "bacula-${VER}.tar.gz" ] || curl -L -o "bacula-${VER}.tar.gz" "${REPO}/bacula-${VER}.tar.gz"

if [ ! -x "${PREFIX}/sbin/bacula-dir" ]; then
  rm -rf "bacula-${VER}"
  tar -xzf "bacula-${VER}.tar.gz"
  cd "bacula-${VER}"
  ./configure --prefix="${PREFIX}" --with-postgresql --with-openssl
  make -j2
  make install
fi

sudo -u postgres "${PREFIX}/etc/create_postgresql_database" 2>/dev/null || true
sudo -u postgres "${PREFIX}/etc/make_postgresql_tables" 2>/dev/null || true
sudo -u postgres "${PREFIX}/etc/grant_postgresql_privileges" 2>/dev/null || true
sudo -u postgres psql -c "ALTER USER bacula WITH PASSWORD 'P@ssw0rd';"

mkdir -p "${PREFIX}/working"

curl -L -o "${PREFIX}/etc/bacula-dir.conf" "${REPO}/bacula-dir.conf"
curl -L -o "${PREFIX}/etc/bacula-fd.conf" "${REPO}/bacula-fd.conf"
curl -L -o "${PREFIX}/etc/bconsole.conf" "${REPO}/bconsole.conf"

"${PREFIX}/sbin/bacula-dir" -t -c "${PREFIX}/etc/bacula-dir.conf"
"${PREFIX}/sbin/bacula-fd" -t -c "${PREFIX}/etc/bacula-fd.conf"

pkill -x bacula-dir 2>/dev/null || true
pkill -x bacula-fd 2>/dev/null || true
"${PREFIX}/sbin/bacula-fd" -c "${PREFIX}/etc/bacula-fd.conf"
"${PREFIX}/sbin/bacula-dir" -c "${PREFIX}/etc/bacula-dir.conf"

echo "HQ-SRV готов"
ss -lntp | grep -E '9101|9102' || true
