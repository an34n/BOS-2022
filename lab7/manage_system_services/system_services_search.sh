#!/bin/bash

source ./utils.sh

clear_with_hat
echo -n "Введите ключевое слово для поиска сервиса >>> "; read SERVICE
COLUMN_MENU_LIST=$(sudo systemctl list-units | awk '{print $1}' | grep $SERVICE | grep ".*\..*")

COLUMN_MENU_COUNTER=0
COLUMN_MENU_NUMLIST=""
for i in $COLUMN_MENU_LIST; do
    echo $(( COLUMN_MENU_COUNTER++ )) &> /dev/null
    COLUMN_MENU_NUMLIST="$COLUMN_MENU_NUMLIST*${COLUMN_MENU_COUNTER})${i}"
    if (( $COLUMN_MENU_COUNTER % 4 == 0 )); then
        COLUMN_MENU_NUMLIST="$COLUMN_MENU_NUMLIST"$'\n'
    fi
done

column -s '*' -t < <(echo "$COLUMN_MENU_NUMLIST") | prSection $(( $(echo "$COLUMN_MENU_LIST" | wc -l) / 3 + 1))

echo -n "Введите любую клавишу, чтобы вернуться... "; getkey
