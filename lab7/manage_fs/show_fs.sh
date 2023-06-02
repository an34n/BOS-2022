#!/bin/bash

source ./utils.sh

clear_with_hat
COMMAND="df --output=source,fstype,target | grep -vE 'tmpfs|sys|proc'"
eval $COMMAND
echo -n "" | prSection 1

if (( $? != 0 )); then
	echo "Ошибка при выведении списка файловых систем"
fi

echo -n "Введите любую клавишу, чтобы вернуться... "; getkey
