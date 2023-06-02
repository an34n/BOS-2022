#!/bin/bash

source ./utils.sh

clear_with_hat

echo "Введите логин пользователя" | prSection 1
echo -n ">>> "
read login

clear_with_hat
id ${login} &> /dev/null
if (( $? == 0 )); then
    echo "Пользователь с таким логином существует" | prSection 1
else
    useradd -s /bin/bash -m -G sudo $login &>/dev/null
    if (( $? == 0 )); then
        echo "Пользователь с логином: $login успешно создан!" | prSection 1 
    else
        echo "Ошибка при создании пользователя" | prSection 1
    fi
fi
echo "Нажмите любую клавишу, чтобы вернуться назад!" | prSection 1
getkey
