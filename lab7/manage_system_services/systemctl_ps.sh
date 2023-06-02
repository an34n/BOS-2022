#!/bin/bash

source ./utils.sh

clear_with_hat

LINES=$(( $(systemctl status | wc -l) - 5 ))

COMMAND="systemctl status | tail -n $LINES | less"

eval $COMMAND

if (( $? != 0 )); then
	echo "Ошибка при выводе процессов"
fi

echo -n "Нажмите любую клавишу, чтобы вернуться ..."; getkey
