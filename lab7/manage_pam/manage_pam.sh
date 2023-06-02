#!/bin/bash

source ./utils.sh

MAIN_MENU='
1) Настройка срока действия паролей пользователей
2) Настройка сложности (длины) паролей пользователей
3) Настройка количества неверных попыток входа, после чего сеанс запроса пароля должен быть прерван
4) Настройка количества неверных попыток входа, после чего пользователь будет заблокирован
'

run_chosen_script() {
    case "$MAIN_MENU_COUNTER" in
        2) bash manage_user/add_user.sh;;
        3) bash manage_user/delete_user.sh;;
        4) bash manage_user/add_user_to_group.sh;;
    esac
}
loop_menu


