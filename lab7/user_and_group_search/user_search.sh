#!/bin/bash

source ./utils.sh

clear_with_hat
echo -n "Введите ключевое слово для поиска пользователя >>> "; read user

USER_LIST="$(cat /etc/passwd | cut -d ":" -f1 | grep $user )"

clear_with_hat
echo "Найдены следущие результаты" | prSection 1
for i in $USER_LIST; do
    echo "Пользователь: $i"
    echo "UID: $(id -u $i)"
    echo "Shell: $(cat /etc/passwd | grep $i | cut -d ":" -f7)"
    FILL=$PLUSES
    echo "Groups:$(groups $i | cut -d ":" -f2)"
    echo ""
done
FILL=$DASHES
echo -n "" | prSection 1

echo "Введите любую клавишу, чтобы вернуться ... "; getkey
