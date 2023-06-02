#!/bin/bash

source ./utils.sh
clear_with_hat

COLUMN_MENU_LIST=$(df --output=source,fstype,target | grep -vE 'tmpfs|sys|proc' | cut -d " " -f1)
COLUMN_MENU_CHOOSE_PHRASE="Выберите файловую систему, чьи параметры вы хотите посмотреть >>> "
column_menu
CHOSEN_FS=$COLUMN_MENU_CHOOSE

clear_with_hat
COMMAND="tune2fs -l $CHOSEN_FS"
eval $COMMAND
echo -n "" | prSection 1

echo -n "Введите любую клавишу, чтобы вернуться ... "; getkey

