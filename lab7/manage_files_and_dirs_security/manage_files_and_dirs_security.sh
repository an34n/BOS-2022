#!/bin/bash

source ./utils.sh
source ./manage_files_and_dirs_security/manage_files_and_dirs_security_utils.sh

clear_with_hat
echo -n "Введите имя файла >>> "; read FILENAME

MAIN_MENU='
1) Изменить права доступа
2) Изменить владельца и группу файла
'

run_chosen_script() {
    case "$MAIN_MENU_COUNTER" in
        2) bash manage_files_and_dirs_security/change_permissions.sh $FILENAME;;
        3) bash manage_files_and_dirs_security/change_owner.sh $FILENAME;;
    esac
}
CLEAR_FUNCTION="clear_with_file"
loop_menu
