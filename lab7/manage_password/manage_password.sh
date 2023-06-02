#!/bin/bash

source utils.sh


MAIN_MENU='
1) Блокировка пользователя (запрет на вход в систему)
2) Смена пароля пользователя 
'

run_chosen_script() {
    case "$MAIN_MENU_COUNTER" in
        2) bash manage_password/block_unblock_user.sh;;
        3) bash manage_password/change_password.sh;;
    esac
}

loop_menu
