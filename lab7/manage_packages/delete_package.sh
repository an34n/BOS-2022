#!/bin/bash

source ./utils.sh
clear_with_hat

echo -n "Введите имя пакета для установки >>> "; read PACKAGE_NAME

COMMAND="yum install -y $PACKAGE_NAME"
clear_with_hat
eval $COMMAND &>/dev/null
if (( $? == 0 )); then
	echo "Пакет успешно установлен" | prSection 1
else
	echo "Пакет не найден, выберете один из похожих пакетов" | prSection 1
	COLUMN_MENU_LIST=$(sudo yum list $PACKAGE_NAME\* | sed -n '/Avai/,$p' | grep -v "Avai" | cut -d " " -f1)
	COLUMN_MENU_CHOOSE_PHRASE="Введите номер пакета >>> "
	column_menu
	CHOOSEN_PACKAGE=$COLUMN_MENU_CHOOSE
	COMMAND="yum install -y $CHOOSEN_PACKAGE"
	clear_with_hat
	EXIT_CODE=0
	eval $COMMAND &>/dev/null
	if (( $? == 0 )); then
		echo "Установка пакета произведена успешно" | prSection 1
	else
		echo "Ошибка при установке пакета" | prSection 1
		EXIT_CODE=1
	fi

	echo "Введите любую клавишу, чтобы вернуться ... "; getkey
	exit $EXIT_CODE
fi
