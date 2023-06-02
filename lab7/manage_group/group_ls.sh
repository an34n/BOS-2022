#!/bin/bash

source ./utils.sh

GROUP_LIST=$(cat /etc/group | cut -d ":" -f1,4)

COLUMN_MENU_LIST=$(echo "$GROUP_LIST")
COLUMN_MENU_COUNTER=0
COLUMN_MENU_NUMLIST=""
clear_with_hat
for i in $COLUMN_MENU_LIST; do
    i=$(echo "$i" | sed 's/:/: /' | sed 's/: $/: no members/')
    echo $(( COLUMN_MENU_COUNTER++ )) &> /dev/null
    COLUMN_MENU_NUMLIST="$COLUMN_MENU_NUMLIST*${COLUMN_MENU_COUNTER})${i}"
    if (( $COLUMN_MENU_COUNTER % 4 == 0 )); then
        COLUMN_MENU_NUMLIST="$COLUMN_MENU_NUMLIST"$'\n'
    fi
done

column -s '*' -t < <(echo "$COLUMN_MENU_NUMLIST") | prSection $(( $(echo "$COLUMN_MENU_LIST" | wc -l) / 4 + 1)) 

echo -n "Нажмите любую клавишу, чтобы вернуться... "; getkey
