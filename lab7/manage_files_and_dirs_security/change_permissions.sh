#!/bin/bash

source ./utils.sh
source ./manage_files_and_dirs_security/manage_files_and_dirs_security_utils.sh

FILENAME=$1
CLEAR_FUNCTION="clear_with_file"
MAIN_MENU='
1) Права для владельца
2) Права для группы
3) Права для остальных
4) Права для всех
'
CHMOD_ARGS=""
run_chosen_script() {
    BREAK=1
    case "$MAIN_MENU_COUNTER" in
        2) CHMOD_ARGS="u";;
        3) CHMOD_ARGS="g";;
        4) CHMOD_ARGS="o";;
        5) CHMOD_ARGS="a";; 
    esac
}

loop_menu

MAIN_MENU='
1) Чтение
2) Запись
3) Запуск
4) Steaky bit
'
BREAK=0
run_chosen_script() {
    BREAK=1
    case "$MAIN_MENU_COUNTER" in
        2) CHMOD_ARGS="$CHMOD_ARGS r";;
        3) CHMOD_ARGS="$CHMOD_ARGS w";;
        4) CHMOD_ARGS="$CHMOD_ARGS x";;
        5) CHMOD_ARGS="$CHMOD_ARGS s";;
    esac
}

loop_menu

MAIN_MENU='
1) Удалить
2) Добавить
'
BREAK=0
run_chosen_script() {
    BREAK=1
    case "$MAIN_MENU_COUNTER" in
        2) CHMOD_ARGS="$(echo $CHMOD_ARGS | cut -d " " -f1)-$(echo $CHMOD_ARGS | cut -d " " -f2)";;
        3) CHMOD_ARGS="$(echo $CHMOD_ARGS | cut -d " " -f1)+$(echo $CHMOD_ARGS | cut -d " " -f2)";;
    esac
}

loop_menu

COMMAND="chmod $CHMOD_ARGS $FILENAME &>/dev/null"
eval $COMMAND




