#!/bin/bash

source ./utils.sh

USERS=$(cat /etc/passwd | cut -d ":" -f1)

COLUMN_MENU_LIST=$(echo "$USERS")
COLUMN_MENU_CHOOSE_PHRASE="Выберите пользователя >>> "
clear_with_hat
column_menu

CHOOSEN_USER=$COLUMN_MENU_CHOOSE

ALL_GROUPS=$(cat /etc/group | cut -d ":" -f1)
COLUMN_MENU_LIST=$(echo "$ALL_GROUPS")
COLUMN_MENU_CHOOSE_PHRASE="Выберите группу, в которую хотите добавить пользователя >>> "
clear_with_hat
column_menu

CHOOSEN_GROUP=$COLUMN_MENU_CHOOSE

clear_with_hat
echo "DRY_RUN: usermod -a -G $CHOOSEN_GROUP $CHOOSEN_USER"
echo "Введи любую клавишу, чтобы вернуться..."
getkey
