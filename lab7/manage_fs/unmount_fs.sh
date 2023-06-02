#!/bin/bash

source ./utils.sh
clear_with_hat

COLUMN_MENU_LIST=$(df --output=source,fstype,target | grep -vE 'tmpfs|sys|proc' | cut -d " " -f1)
COLUMN_MENU_CHOOSE_PHRASE="Выберите файловую систему, которую хотите отмонтировать >>> "

column_menu

CHOSEN_FS=$COLUMN_MENU_CHOOSE

COMMAND="umount $CHOSEN_FS"
eval COMMAND &>/dev/null
EXIT_CODE=0
if (( $? == 0 )); then
	echo "Файловая система успешно отмонтирована"
else
	echo "Ошибка при отмонтировании файловой системы"
	EXIT_CODE=1
fi
echo -n "" | prSection 1
echo -n "Введите любую клавишу, чтобы вернуться ... "; getkey
exit $EXIT_CODE

