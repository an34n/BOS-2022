#!/bin/bash

source ./utils.sh
clear_with_hat

echo -n "Введите название группы, которую хотите добавить >>> "; read group_name

groupadd $group_name &>/dev/null

if (( $? == 0 )); then
    echo "Группа успешно создана!!!" | prSection 1
else
    echo "Ошибка при создании группы" | prSection 1
fi

echo -n "Нажмите любую клавишу, чтобы вернуться... "; getkey
