#!/bin/bash
set -e
REPO="https://raw.githubusercontent.com/shiraorie/demo-2027/main/files"

apt-get update
apt-get install -y bacula15-storage curl

mkdir -p /backup /var/bacula /var/lib/bacula
chown -R bacula:bacula /backup /var/bacula /var/lib/bacula
chmod 750 /backup

curl -L -o /etc/bacula/bacula-sd.conf "${REPO}/bacula-sd.conf"

bacula-sd -t -c /etc/bacula/bacula-sd.conf
systemctl reset-failed bacula-sd 2>/dev/null || true
systemctl enable --now bacula-sd
systemctl restart bacula-sd

echo "HQ-CLI готов"
systemctl is-active bacula-sd
ss -lntp | grep 9103 || true
