#!/bin/bash

source ./utils.sh

COLUMN_MENU_LIST=$(cat /etc/group | cut -d ":" -f1)
COLUMN_MENU_CHOOSE_PHRASE="Выберете группу, состав которой хотите изменить >>> "
clear_with_hat
column_menu

CHOSEN_GROUP=$COLUMN_MENU_CHOOSE
MAIN_MENU="
1) Удалить пользователя
2) Добавить пользователя
"

CHOSE=0
run_chosen_script() {
    case "$MAIN_MENU_COUNTER" in
        2) CHOSE=0;BREAK=1;;
        3) CHOSE=1;BREAK=1;
    esac
}
clear_with_hat
loop_menu
OPERATION=$( (( CHOSE == 0 )) && echo "Удаление" || echo "Добавление")

COLUMN_MENU_LIST=$(cat /etc/group | cut -d ":" -f1)
COLUMN_MENU_CHOOSE_PHRASE="Выберете пользователя >>> "
clear_with_hat
column_menu
CHOSEN_USER=$COLUMN_MENU_CHOOSE

COMMAND="$( (( $CHOSE == 0 )) && echo "deluser $CHOSEN_USER $CHOSEN_GROUP" || echo "usermod -a -G $CHOSEN_GROUP $CHOSEN_USER" ) &>/dev/null"  

eval $COMMAND

clear_with_hat
echo $COMMAND | prSection 1
if (( $? == 0 )); then
    echo "$OPERATION проведено успешно" | prSection 1
else
    echo "$OPERATION проведено с ошибкой" | prSection 1
fi

echo -n "Нажмите любую клавишу, чтобы вернуться назад"; getkey
