#!/bin/bash

source ./utils.sh
clear_with_hat

echo -n "Введите имя пакета для удаления >>> "; read PACKAGE_NAME

clear_with_hat
COMMAND="yum autoremove -y $PACKAGE_NAME"
eval $COMMAND &>/dev/null
if (( $? == 0 )); then
	echo "Пакет успешно удален" | prSection 1
else
	echo "Пакет не найден, выберете один из похожих пакетов" | prSection 1
	COLUMN_MENU_LIST=$(sudo yum list installed $PACKAGE_NAME\* | cut -d " " -f1)
	COLUMN_MENU_CHOOSE_PHRASE="Введите номер пакета >>> "
	column_menu
	CHOOSEN_PACKAGE=$COLUMN_MENU_CHOOSE
	COMMAND="yum autoremove -y $CHOOSEN_PACKAGE"
	clear_with_hat
	EXIT_CODE=0
	eval $COMMAND &>/dev/null
	if (( $? == 0 )); then
		echo "Удаление пакета произведено успешно" | prSection 1
	else
		echo "Ошибка при удалении пакета" | prSection 1
		EXIT_CODE=1
	fi

	echo "Введите любую клавишу, чтобы вернуться ... "; getkey
	exit $EXIT_CODE
fi
