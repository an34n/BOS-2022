#!/bin/bash

source ./utils.sh
source ./manage_files_and_dirs_security/manage_files_and_dirs_security_utils.sh

FILENAME=$1

clear_with_file
echo -n "Введите имя пользователя >> "; read USER_NAME
echo -n "" | prSection 1
echo -n "Введите название группы >> "; read GROUP_NAME

COMMAND="chown $USER_NAME:$GROUP_NAME $FILENAME"
eval $COMMAND


