#!/bin/bash

source ./utils.sh
clear_with_hat

echo -n "Введите путь до устройства или файла >>> "; read DEVICE_PATH

ls $DEVICE_PATH
(( $? != 0 )) && echo "По данному пути ничего не найдено" | prSection 1; echo -n "Введите любую клавишу, чтобы вернуться ... "; exit 1

DEVICE_TYPE=$(stat $DEVICE_PATH --printf=%F)
BLOCK_REGEX='/^block.*$/'
FILE_REGEX='/^regular.*$/'
if ![[ "$DEVICE_TYPE" =~ "$BLOCK_REGEX" ]] && ![[ "$DEVICE_TYPE" =~ "$FILE_REGEX" ]]; then
	echo "Не поддерживаемый	тип файла" | prSection 1
	echo "Введите любую клавишу, чтобы вернуться ... "; exit 1
fi

clear_with_hat

echo -n "введите путь до точки монтирования >>> "; read MOUNT_PATH

ls $MOUNT_PATH
(( $? != 0 )) && mkdir -p $MOUNT_PATH &>/dev/null

IS_EMPTY=$(find $MOUNT_PATH -maxdepth 0 -empty -exec echo 0 \;)
[[ "$IS_EMPTY" != "0" ]] && echo "Папка не пустая, укажите пустую папку" | prSection 1; echo "Введите любую клавишу, чтобы вернуться ... "; getkey
IS_LOOP=""
[[ "$DEVICE_TYPE" =~ "$FILE_REGEX"]] && IS_LOOP="-o loop"

COMMAND="mount $IS_LOOP $DEVICE_PATH $MOUNT_PATH"
eval $COMMAND &>/dev/null

if (( $? == 0 )); then
	echo "Монтирование прошло успешно"
else
	echo "Ошибка при монтировании"
fi
echo -n "" | prSection 1
echo -n "Введите любую клавишу, чтобы вернуться ... ";getkey


