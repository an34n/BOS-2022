#!/bin/bash

source ./utils.sh
clear_with_hat

echo -n "Введите название группы >>> "; read group_name

grep -w $group_name /etc/group

if (( $? == 1 )); then
    echo "Группы под названием $group_name не существует" | prSection 1
    echo -n "Введите любую клавишу, чтобы вернуться... "; getkey
    exit 1
fi

groupdel $group_name &>/dev/null
clear_with_hat
if (( $? == 0 )); then
    echo "Группа успешно удалена" | prSection 1
else
    echo "Ошибка при удалении группы" | prSection 1
fi

echo -n "Введите любую клавишу, чтобы вернуться... "; getkey


