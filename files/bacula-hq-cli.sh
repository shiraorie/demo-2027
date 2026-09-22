#!/bin/bash
set -e

HQ_CLI_IP="${1:-192.168.10.2}"

apt-get update
apt-get install -y bacula15-storage curl

mkdir -p /backup /var/bacula /var/lib/bacula
chown -R bacula:bacula /backup /var/bacula /var/lib/bacula
chmod 750 /backup

cat > /etc/bacula/bacula-sd.conf <<EOF
Storage {
  Name = hq-cli-sd
  SDPort = 9103
  SDAddress = ${HQ_CLI_IP}
  Working Directory = "/var/lib/bacula"
  Pid Directory = "/var/bacula"
  Maximum Concurrent Jobs = 10
}

Director {
  Name = hq-srv-dir
  Password = "BaculaSD2027!"
}

Device {
  Name = FileStorage
  Media Type = File
  Archive Device = /backup
  LabelMedia = yes
  Random Access = yes
  AutomaticMount = yes
  RemovableMedia = no
  AlwaysOpen = no
}

Messages {
  Name = Standard
  director = hq-srv-dir = all
}
EOF

bacula-sd -t -c /etc/bacula/bacula-sd.conf

systemctl reset-failed bacula-sd 2>/dev/null || true
systemctl enable --now bacula-sd
systemctl restart bacula-sd

echo "HQ-CLI готов. HQ-CLI=${HQ_CLI_IP}"
systemctl is-active bacula-sd
ss -lntp | grep 9103 || true
