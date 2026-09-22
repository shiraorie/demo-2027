#!/bin/bash

CSV_FILE="/opt/Users.csv"
BASE_DN="DC=AU-TEAM,DC=IRPO"

if [ ! -f "$CSV_FILE" ]; then
    echo "Файл $CSV_FILE не найден"
    exit 1
fi

echo "Создание организационных подразделений..."

tail -n +2 "$CSV_FILE" | cut -d';' -f5 | sort -u | while read -r ou; do
    [ -z "$ou" ] && continue

    if samba-tool ou list | grep -Fxq "$ou"; then
        echo "OU $ou уже существует"
    else
        samba-tool ou create "OU=${ou},${BASE_DN}" \
            --description="${ou} department"
    fi
done

echo "Импорт пользователей..."

while IFS=';' read -r fname lname role phone ou street zip city country password; do

    if [[ "$fname" == "First Name" ]]; then
        continue
    fi

    username=$(echo "${fname:0:1}${lname}" | tr '[:upper:]' '[:lower:]')

    echo "Добавление пользователя: $username -> OU=$ou"

    samba-tool user add "$username" "$password" \
        --given-name="$fname" \
        --surname="$lname" \
        --job-title="$role" \
        --telephone-number="$phone" \
        --userou="OU=$ou"

done < "$CSV_FILE"

echo "Импорт пользователей завершен"
