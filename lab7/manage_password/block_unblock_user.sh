#!/bin/bash

source ./utils.sh

clear_with_hat

COLUMN_MENU_LIST=$(cat /etc/passwd | cut -d ":" -f1)
COLUMN_MENU_COUNTER=0
COLUMN_MENU_NUMLIST=""
COLUMN_MENU_CHOOSE_PHRASE="Выберите пользователя >>> "
for i in $COLUMN_MENU_LIST; do
    echo $(( COLUMN_MENU_COUNTER++ )) &> /dev/null
    if [[ $(passwd -S ${i} | cut -d " " -f2 ) == "L" ]]; then
        COLUMN_MENU_NUMLIST="$COLUMN_MENU_NUMLIST"$'\n'"X${COLUMN_MENU_COUNTER})${i}"
    else
        COLUMN_MENU_NUMLIST="$COLUMN_MENU_NUMLIST"$'\n'"${COLUMN_MENU_COUNTER})${i}"
    fi
done

column -s " " < <(echo "$COLUMN_MENU_NUMLIST") | prSection $(( $(echo "$COLUMN_MENU_NUMLIST" | wc -l) / 3 + 1)) 

echo -n "$COLUMN_MENU_CHOOSE_PHRASE" 
read column_menu_choose
echo -n "" | prSection 1 
COLUMN_MENU_CHOOSE=$(echo "$COLUMN_MENU_LIST" | head -$column_menu_choose | tail -n 1 )
CHOSEN_USER=$COLUMN_MENU_CHOOSE

if [[ $(passwd -S ${CHOSEN_USER} | cut -d " " -f2 ) == "L" ]]; then
    passwd -u $CHOSEN_USER &>/dev/null
    if (( $? == 0 )); then
        echo "Пользователь успешно разблокирован"
    else
        echo "Ошибка при разблокировании пользователя..."
    fi
else
    passwd -l $CHOSEN_USER &>/dev/null
    if (( $? == 0 )); then
        echo "Пользователь успешно заблокирован"
    else
        echo "Ошибка при блокировке пользователя"
    fi
fi
echo -n "" | prSection 1
echo -n "Нажмите любую клавишу, чтобы вернуться... "
getkey
