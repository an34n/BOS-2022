#!/bin/bash

err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S')]: $*" >&2
}


if [ "$EUID" -ne 0 ]; then
	echo "Only root can use this script"
	exit
fi


PS3='> '
options=(
         "Поиск системных служб"
         "Вывести список процессов и связанных с ними служб"
         "Управление службами"
         "Поиск событый в журнале"
         "Выход"
       )


makelist() {
  local -n options1=$1
  options1+=(
            "Помощь"
            "Выход"
            ) 
  while true
  do
  select opt in "${options1[@]}"; do
    case $opt in
      "Помощь")
        echo $2
        break
        ;;
      "Выход")
        return 0
        ;;
      *)
        if [ -z "$opt" ]; then
          err "Введите номер из списка"
          break
        else
          return $REPLY
        fi
        ;;
      esac
    done
  done
  }



output() {
  if [ $1 -ne 0 ]; then
    err $3
    return
  else
    echo $2
  fi
}


output_less() {
  if [ $(wc -l <<< "$1") -lt 10 ]; then
    echo "$1"
  else
    less <<< "$1"
  fi
}


if [ "$1" = "-help" ]; then
  echo "Скрипт позволет управлять службами и журналами."
  exit
fi


find_services() {
  read -p "Введите имя службы или часть имени службы: " name
  output_less "$(systemctl list-units --type=service | head -n-6 | tail -n+2 | grep "$name")"
}


list_ps_and_services() {
  output_less "$(ps ax -o'pid,unit,args' | grep  '.service')"
}


find_in_journal() {
  read -p "Имя службы или его часть: " service
  read -p "Степень важности: " priority
  read -p "Строка поиска: " req
  journalctl -p "$priority" -u "$service" -g "$req"
}


manage_service() {
  IFS=$'\n' read -r -d '' -a arr < <(systemctl list-units --type=service | head -n-6 | tail -n+2 | cut -c 3- |  cut -d" " -f 1 && printf '\0')
  makelist arr "Номер сервиса: "
  num=$?
  echo "========" $num
  if [ $num -eq 0 ]; then
    return
  fi
  service=${arr[num-1]}
  options2=(
          "Включить службу"
          "Отключить службу"
          "Запустить или перезапустить службу"
          "Остановить службу"
          "Вывести содержимое юнита службы"
          "Отредактировать юнит службы"
          "Назад"
  )
  select opt in "${options2[@]}"
  do
    case $opt in
      "Включить службу")
      systemctl enable "$service"
      break
      ;;
      "Отключить службу")
      systemctl disable "$service"
      break
      ;;
      "Запустить или перезапустить службу")
      systemctl restart "$service"
      break
      ;;
      "Остановить службу")
      systemctl stop "$service"
      break
      ;;
      "Вывести содержимое юнита службы")
      less "$(systemctl status $service | head -n+2 | tail -n-1 | cut -f2 -d"(" | cut -f1 -d";")"
      break
      ;;
      "Отредактировать юнит службы")
        vim "$(systemctl status $service | head -n+2 | tail -n-1 | cut -f2 -d"(" | cut -f1 -d";")"
      break
      ;;
      "Назад")
      return
      ;;
      *) err "Неверный аргумент $REPLY"
      esac
    done 
}



while true
do
select opt in "${options[@]}"
do
  case $opt in
    "Поиск системных служб")
      find_services
      break
      ;;
    "Вывести список процессов и связанных с ними служб")
      list_ps_and_services
      break
      ;;
    "Управление службами")
      manage_service
      break
      ;;
    "Поиск событый в журнале")
      find_in_journal
      break
      ;;
    "Выход")
      exit
      ;;
    *) err "Неверный аргумент $REPLY"
  esac
done
done
