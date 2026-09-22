#!/bin/bash
set -e

BC="/opt/bacula/sbin/bconsole"
CONF="/opt/bacula/etc/bconsole.conf"

"$BC" -c "$CONF" <<'EOF'
label storage=HQ-CLI-Storage volume=Backup001 pool=BackupPool
run job=Backup-HQ-SRV-ETC yes
quit
EOF

sleep 3
echo "list jobs" | "$BC" -c "$CONF"
