#!/bin/bash

source ./utils.sh

COLUMN_MENU_LIST=$(cat /etc/passwd | cut -d ":" -f1)
clear_with_hat
column_menu

CHOSEN_USER=$COLUMN_MENU_CHOOSE

clear_with_hat
echo -n "Введите новый пароль >>> "
read passwd
echo -n "" | prSection 1
clear_with_hat
echo -n "Введите пароль повторно >>> "
read passwd_check
echo -n "" | prSection 1
clear_with_hat
if [[ $passwd == $passwd_check ]]; then
   echo "$CHOSEN_USER:$passwd" | chpasswd
   echo "Пароль успешно изменен" | prSection 1
else
   echo "Пароли не совпадают, попробуйте с следущий раз" | prSection 1
fi

echo -n "Нажмите любую клавишу, чтобы вернуться... "
getkey
