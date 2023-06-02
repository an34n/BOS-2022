#!/bin/bash

source ./utils.sh

clear_with_hat
echo -n "Введите ключевое слово для поиска группы >>> "; read group
GROUP_LIST="$(cat /etc/group | cut -d ":" -f1 | grep $group )"

clear_with_hat
echo "Найдены следущие результаты" | prSection 1
for i in $GROUP_LIST; do
    echo "Группа: $i"
    echo "GID: $(cat /etc/group | cut -d ":" -f1-3 | grep $i | cut -d ":" -f3)"
    FILL=$PLUSES
    echo "Members: $(cat /etc/group | grep $i | cut -d ":" -f4 | sed 's/,/, /g')" | prSection 1
done
FILL=$DASHES

echo $'\n'"Введите любую клавишу, чтобы вернуться ... "; getkey
