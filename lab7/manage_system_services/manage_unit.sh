#!/bin/bash

source ./utils.sh

clear_with_hat
COLUMN_MENU_LIST=$(sudo systemctl list-units | awk '{print $1}' | grep ".*\..*")
COLUMN_MENU_CHOOSE_PHRASE="Выберите юнит >>> "

column_menu

CHOSEN_UNIT=$COLUMN_MENU_CHOOSE
CHOSEN_UNIT_PATH="$(systemctl cat $CHOSEN_UNIT | head -1 | sed 's/# //g' )"


MAIN_MENU='
1) Включить службу
2) Отключить службу
3) Запустить/перезапустить службу
4) Остановить службу
5) Вывести содержимое юнита службы
6) Отредактировать юнит службы
'

run_chosen_script() {
    case "$MAIN_MENU_COUNTER" in
        2) systemctl enable $CHOSEN_UNIT;;
        3) systemctl disable $CHOSEN_UNIT;;
        4) systemctl restart $CHOSEN_UNIT;;
        5) systemctl stop $CHOSEN_UNIT;;
        6) systemctl cat $CHOSEN_UNIT;getkey;;
        7) vim $CHOSEN_UNIT_PATH;;
    esac
}

loop_menu
