#!/bin/bash

source utils.sh
source manage_acl_utils.sh

clear_with_hat
echo "Введите путь до файла или каталога >>> "; read FILENAME

CLEAR_FUNCTION="clear_with_acl"
MAIN_MENU='
1)Добавить запись
2)Удалить запись
3)Изменить запись
'

run_chosen_script() {
    case "$MAIN_MENU_COUNTER" in
        2) bash manage_user/add_user.sh;;
        3) bash manage_user/delete_user.sh;;
        4) bash manage_user/add_user_to_group.sh;;
    esac
}

loop_menu
