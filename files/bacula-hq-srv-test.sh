#!/bin/bash
set -e

HQ_SRV_IP="${1:-192.168.100.2}"
HQ_CLI_IP="${2:-192.168.10.2}"

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

cat > "${PREFIX}/etc/bacula-dir.conf" <<EOF
Director {
  Name = hq-srv-dir
  DIRport = 9101
  QueryFile = "/opt/bacula/scripts/query.sql"
  WorkingDirectory = "/opt/bacula/working"
  PidDirectory = "/opt/bacula/working"
  Maximum Concurrent Jobs = 10
  Password = "P@ssw0rd"
  Messages = Daemon
}

Job {
  Name = "Backup-HQ-SRV-ETC"
  Type = Backup
  Level = Full
  Client = hq-srv-fd
  FileSet = "ETC"
  Storage = HQ-CLI-Storage
  Pool = BackupPool
  Messages = Standard
  Priority = 10
}

FileSet {
  Name = "ETC"
  Include {
    Options { signature = MD5 }
    File = /etc
  }
}

Client {
  Name = hq-srv-fd
  Address = ${HQ_SRV_IP}
  FDPort = 9102
  Catalog = MyCatalog
  Password = "BaculaFD2027!"
}

Storage {
  Name = HQ-CLI-Storage
  Address = ${HQ_CLI_IP}
  SDPort = 9103
  Password = "BaculaSD2027!"
  Device = FileStorage
  Media Type = File
}

Catalog {
  Name = MyCatalog
  dbname = "bacula"
  dbuser = "bacula"
  dbpassword = "P@ssw0rd"
  dbaddress = "127.0.0.1"
}

Pool {
  Name = BackupPool
  Pool Type = Backup
  Recycle = yes
  AutoPrune = yes
  Volume Retention = 30 days
  Maximum Volumes = 10
}

Messages {
  Name = Standard
  console = all, !skipped, !saved
  catalog = all, !skipped, !saved
}

Messages {
  Name = Daemon
  console = all, !skipped, !saved
}
EOF

cat > "${PREFIX}/etc/bacula-fd.conf" <<EOF
Director {
  Name = hq-srv-dir
  Password = "BaculaFD2027!"
}

FileDaemon {
  Name = hq-srv-fd
  FDport = 9102
  FDAddress = ${HQ_SRV_IP}
  Working Directory = "/opt/bacula/working"
  Pid Directory = "/opt/bacula/working"
  Maximum Concurrent Jobs = 10
}

Messages {
  Name = Standard
  director = hq-srv-dir = all, !skipped, !restored
}
EOF

cat > "${PREFIX}/etc/bconsole.conf" <<'EOF'
Director {
  Name = hq-srv-dir
  DIRport = 9101
  address = 127.0.0.1
  Password = "P@ssw0rd"
}
EOF

"${PREFIX}/sbin/bacula-dir" -t -c "${PREFIX}/etc/bacula-dir.conf"
"${PREFIX}/sbin/bacula-fd" -t -c "${PREFIX}/etc/bacula-fd.conf"

pkill -x bacula-dir 2>/dev/null || true
pkill -x bacula-fd 2>/dev/null || true

"${PREFIX}/sbin/bacula-fd" -c "${PREFIX}/etc/bacula-fd.conf"
"${PREFIX}/sbin/bacula-dir" -c "${PREFIX}/etc/bacula-dir.conf"

echo "HQ-SRV готов. HQ-SRV=${HQ_SRV_IP}, HQ-CLI=${HQ_CLI_IP}"
ss -lntp | grep -E '9101|9102' || true
