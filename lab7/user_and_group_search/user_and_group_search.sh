#!/bin/bash

source utils.sh


MAIN_MENU='
1) Найти пользователя 
2) Найти группу
'

run_chosen_script() {
    case "$MAIN_MENU_COUNTER" in
        2) bash user_and_group_search/user_search.sh;;
        3) bash user_and_group_search/group_search.sh;;
    esac
}

loop_menu
