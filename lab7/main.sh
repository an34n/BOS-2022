#!/bin/bash

source ./utils.sh

if [[ $USER != "root" ]]; then
    echo "Для использования скрипта, нужны права суперюзера"
    exit 1
fi

MAIN_MENU='
1) Управление пользователями
2) Управление паролями и блокировка
3) Управление группами
4) Поиск пользователей или групп
5) Управление безопасностью файлов и каталогов
6) Управление ACL для файлов и каталогов
7) Управление системными службами и журналами (systemctl, journalctl)
8) Управление входом в систему (PAM)
9) Управление файловыми системами (монтирование и отмонтирование)
10) Управление сетевыми файловыми системами (монтирование и отмонтирование)
11) Управление RPM-пакетами и репозиториями
12) Управление событиями безопасности (аудит) 
13) Управление SELinux
'
run_chosen_script() {
    case "$MAIN_MENU_COUNTER" in
        2) bash manage_user/manage_user.sh;;
        3) bash manage_password/manage_password.sh;;
        4) bash manage_group/manage_group.sh;;
        5) bash user_and_group_search/user_and_group_search.sh;; 
        6) bash manage_files_and_dirs_security/manage_files_and_dirs_security.sh;; 
    esac
}

loop_menu
