#!/bin/bash

source ./utils.sh

clear_with_hat
echo -n "Введите имя службы >>> "; read UNIT_NAME

clear_with_hat
COLUMN_MENU_LIST='emerg
alert
crit
err
warning
notice
info    
debug'
COLUMN_MENU_CHOOSE_PHRASE="Выберите уровень важности сообщений >>> "
column_menu
PRIOR_LEVEL="-p $COLUMN_MENU_CHOOSE"
if [[ $UNIT_NAME != "" ]]; then
	UNIT_NAME_ARG="--unit $UNIT_NAME"
fi

clear_with_hat

COMMAND="journalctl $UNIT_NAME_ARG $PRIOR_LEVEL | less"
eval $COMMAND

if (( $? != 0 )); then
	echo "Ошибка при попытке показать логи" | prSection 1
fi
echo -n "Введите любую клавишу, чтобы вернуться ... "; getkey
	
