#!/bin/bash

source ./utils.sh
clear_with_hat

COLUMN_MENU_LIST=$(df --output=source,fstype,target | grep -vE 'tmpfs|sys|proc' | cut -d " " -f1)
COLUMN_MENU_CHOOSE_PHRASE="Выберите файловую систему, режим которой хотите поменять >>> "
column_menu
CHOSEN_FS=$COLUMN_MENU_CHOOSE

MAIN_MENU="
1) Перевести файловую систему в режим «только чтение»
2) Перевести файловую систему в режим «чтение и запись»
"
CHOSEN_FS_MODE='rw'
run_chosen_script() {
    BREAK=1
    case "$MAIN_MENU_COUNTER" in
	2) CHOSEN_FS_MODE="ro";;
	3) CHOSEN_FS_MODE="rw";;
    esac
}
loop_menu

COMMAND="mount -o remount,$CHOSEN_FS_MODE $CHOSEN_FS"
eval $COMMAND &>/dev/null

clear_with_hat

EXIT_CODE=0
if (( $? == 0 )); then
	echo "Изменение режима монтирования прошло успешно" | prSection 1
else
	echo "Ошибка при изменении режима" | prSection 1
	EXIT_CODE=1
fi

echo -n "Введите любую клавишу, чтобы продолжить ... "; getkey
