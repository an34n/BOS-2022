#!/bin/bash


UPTOP=$(tput cup 0 0)
ERAS2EOL=$(tput el)
REV=$(tput rev)
OFF=$(tput sgr0)
SMUL=$(tput smul)
RMUL=$(tput rmul)
COLUMNS=$(tput cols)
printf -v DASHES '%*s' $COLUMNS '-'
DASHES=${DASHES// /-}
printf -v PLUSES '%*s' $COLUMNS '+'
PLUSES=${PLUSES// /+}
CONTROLS='K - UP : J - DOWN
Q - BACK/QUIT : ENTER - CHOOSE'

getkey() {
     old_tty_settings=$(stty -g)   # Save old settings.
     stty -icanon
     keypress=$(head -c1)
     stty "$old_tty_settings"      # Restore old settings.
}


function prSection() 
{
    if [ -z ${FILL} ]; then FILL=$DASHES; fi
    local -i i
    for ((i=0; i < ${1:-5}; i++))
    do
        read aline
        printf '%s%s\n' "$aline" "${ERAS2EOL}"
    done
    printf '%s%s\n%s' "$FILL" "${ERAS2EOL}" "${ERAS2EOL}"
}

function clear_with_hat() 
{
    clear
    printf '%s' "$UPTOP"
    echo "${REV}OSS LAB SCRIPT${OFF}" | prSection 1
    echo "${REV}FEDOROV ALEXEY Б20505${OFF}" | prSection 1
    echo "Controls:"$'\n'"$(column -s ':' -t < <(printf "%s\n" "$CONTROLS"))" | prSection 3
}

function column_menu()
{
    COLUMN_MENU_COUNTER=0
    COLUMN_MENU_NUMLIST=""
    for i in $COLUMN_MENU_LIST; do
        echo $(( COLUMN_MENU_COUNTER++ )) &> /dev/null
        COLUMN_MENU_NUMLIST="$COLUMN_MENU_NUMLIST*${COLUMN_MENU_COUNTER})${i}"
        if (( $COLUMN_MENU_COUNTER % 4 == 0 )); then
            COLUMN_MENU_NUMLIST="$COLUMN_MENU_NUMLIST"$'\n'
        fi
    done

    column -s '*' -t < <(echo "$COLUMN_MENU_NUMLIST") | prSection $(( $(echo "$COLUMN_MENU_LIST" | wc -l) / 3 + 1)) 

    echo -n "$COLUMN_MENU_CHOOSE_PHRASE" 
    read column_menu_choose
    echo -n "" | prSection 1 
    COLUMN_MENU_CHOOSE=$(echo "$COLUMN_MENU_LIST" | head -$column_menu_choose | tail -n 1 )
}

function loop_menu() 
{
    [ -z ${CLEAR_FUNCTION} ] && CLEAR_FUNCTION=clear_with_hat
    MAIN_MENU_COUNTER=2
    MAIN_MENU_LINES=$(echo "$MAIN_MENU" | wc -l)
    while true; do
        eval ${CLEAR_FUNCTION}
        LOOP_COUNTER=0
        while read -r i ; do
            echo $(( LOOP_COUNTER++ )) &>/dev/null
            if (( $LOOP_COUNTER == $MAIN_MENU_COUNTER )) && (( $LOOP_COUNTER != 0 )); then
                echo " $i <<<"
            else
                echo " $i"
            fi
        done < <(printf '%s\n' "$MAIN_MENU")
        echo "" | prSection 1
        getkey
        [[ $keypress == "j" ]] && echo $(( MAIN_MENU_COUNTER++ )) &>/dev/null
        [[ $keypress == "k" ]] && echo $(( MAIN_MENU_COUNTER-- )) &>/dev/null
        [[ $keypress == "" ]] && run_chosen_script; if (( $BREAK == 1 )); then break; fi;
        if [[ $keypress == "q" ]]; then clear; exit 0; fi
        (( $MAIN_MENU_COUNTER > $MAIN_MENU_LINES - 1 )) && echo $(( MAIN_MENU_COUNTER = 2 )) &> /dev/null
        (( $MAIN_MENU_COUNTER < 2 )) && echo $(( MAIN_MENU_COUNTER = $MAIN_MENU_LINES - 1 )) &> /dev/null
    done
}

