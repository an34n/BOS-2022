#!/bin/bash

source ./utils.sh
clear_with_hat
echo -n "Введите ключевое слово для поиска пакета"$'\n'">>> ";read PACKAGE_NAME

clear_with_hat
COMMAND="yum list $PACKAGE_NAME\*"
eval $COMMAND 2>/dev/null
EXIT_CODE=0
(( $? != 0 )) && echo "Ошибка при выведении списка установленных пакетов" | prSection 1;EXIT_CODE=1
echo -n "" | prSection 1

echo -n "Введите любую клавишу, чтобы вернуться ... ";getkey
exit $EXIT_CODE

