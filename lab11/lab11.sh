#!/bin/bash

err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S')]: $*" >&2
}

check() {
	if [ $1 -ne 0 ]; then
		err ${@:3}
		exit
	else
		if [ "$2" != "" ]; then
			echo $2
		fi
	fi
}

display() {
    if [ $(wc -l <<< "$1") -lt 30 ]; then
        echo "$1"
    else
        less <<< "$1"
    fi
}

listselect() {
	local -n list=$1
	list+=("Справка" "Выход")
	select opt in "${list[@]}"; do
	case $opt in
		Выход) return 0;;
		Справка) echo "$2";;
		*)
			if [[ -z $opt ]]; then
				echo "Ошибка: введите число из списка" >&2
			else
				return $REPLY
			fi
			;;
	esac
	done
}

index() {
	local -n list=$1
	for i in "${!list[@]}"; do
		if [[ "${list[$i]}" = "$2" ]]; then
			return "$((i+1))"
		fi
	done
	return 0
}

partselect() {
	read -p "$2" name
	index $1 "$name"
	res=$?
	if [ $res == 0 ]; then
		local -n list=$1
		readarray -t filtered < <(printf -- '%s\n' "${list[@]}" | grep "$name")
		listselect filtered "$3"
		res=$?
		if [ $res == 0 ]; then
			return 0
		else
			index $1 "${filtered[res - 1]}"
			return $?
		fi
	else
		return $res
	fi
}

if [ "$EUID" -ne 0 ]; then
	echo "Запустите программу с правами администратора"
	exit
fi

if [ "$1" = "--help" ]; then
	echo 'Лабораторная работа "Регистрация системных событий"

Данный скрипт позволяет интерактивно регистрировать и анализировать события с помощью системы Linux Auditing System.
Запустите скрипт без аргументов чтобы увидеть список возможностей.
'
	exit
fi

PS3=$'\n> '
options=(
	"Поиск событий аудита"
	"Отчёты аудита"
	"Настройка подсистемы аудита"
	"Справка"
	"Выйти"
)

select opt in "${options[@]}"
do
	case $opt in
	"Поиск событий аудита")
		read -p "Тип события (если пусто, то ALL): " eventtype
		if [ "$eventtype" == "" ]; then
			eventtype=ALL
		fi
		read -p "Введите uid пользователя (может быть пустым): " userid
		read -p "Введите строку поиска: " searchstring
		if [ "$search" == "" ]; then
			search="="
		fi
		if [ "$userid" == "" ]; then
			ausearch -m $eventtype | grep $search -B 2
		else
			ausearch -m "$eventtype" -ui "$userid" | grep "$search" -B 2
		fi
		;;

	"Отчёты аудита")
		report=""
		echo "Выберите интересующую информацию: "
		select opt in "Отчёт входе пользователей в систему" "Отчёт о нарушениях" "Справка" "Назад"; do
		case $opt in
            "Отчёт входе пользователей в систему")
				report="-au"
                break
                ;;
            "Отчёт о нарушениях")
				report="--failed --user"
                break
                ;;
            "Справка")
                echo "Выбирете интересующий отчёт"
                ;;
            "Назад")
                break
                ;;
	        *) echo "Неправильная команда $REPLY";;
		esac
		done
		[ "$report" == "" ] && continue
		period=""
		echo "Выберите интересующий период: "
		select opt in "1 день" "неделя" "месяц" "год" "Справка" "Назад"; do
		case $opt in
            "1 день")
				period="today"
                break
                ;;
            "неделя")
				period="this-week"
                break
                ;;
            "месяц")
				period="this-month"
                break
                ;;
            "год")
				period="this-year"
                break
                ;;
            "Справка")
                echo "Выбирете интересующий период отчета"
                ;;
            "Назад")
                break
                ;;
	        *) echo "Неправильная команда $REPLY";;
		esac
		done
		[ "$period" == "" ] && continue

		aureport $report -ts "$period" > report
		check $? "Отчёт сохранен в файл report" "Ошибка сохранения отчета"
        ;;

	"Настройка подсистемы аудита")
		select opt in "Добавить каталог/файл в список наблюдения" "Удалить из списка наблюдения" "Отчёт по наблюдению" "Справка" "Назад"; do
		case $opt in
            "Добавить каталог/файл в список наблюдения")
				read -e -p "Введите путь до файла/каталога: " path
				if [ "$path" == "" ]; then
					err "Путь не может быть пустой"
					continue
				fi
				if [ -d "$path" ]; then
					auditctl -a exit,always -F "dir=$path" -F perm=warx
				elif [ -f "$path" ]; then
					auditctl -w "$path" -p warx
				else
					err "Такой файл не существует"
					continue
				fi
                ;;
            "Удалить из списка наблюдения")
				rules=$(auditctl -l)
				if [[ "$rules" == "No rules"* ]]; then
					echo "Нет правил"
					continue
				fi
				readarray -t paths < <(auditctl -l | cut -d " " -f2)
				listselect paths "Выберите интересующее вас правило"
				res=$?
				[ $res == 0 ] && continue
				rule="${paths[res - 1]}"
				auditctl -W $rule
                ;;
            "Отчёт по наблюдению")
				rules=$(auditctl -l)
				if [[ "$rules" == "No rules"* ]]; then
					echo "Нет правил"
					continue
				fi
				readarray -t paths < <(cut -d " " -f2 <<< "$rules")
				listselect paths "Выберите интересующий вас путь"
				res=$?
				[ $res == 0 ] && continue
				path=${paths[res - 1]}
				res=$(aureport --file | grep $path)
				[ "$res" == "" ] && res="Нет событий"
				echo "${res}"
                ;;
            "Справка")
                echo "Введите интересующую команду"
                ;;
            "Назад")
                break
                ;;
	        *) echo "Неправильная команда $REPLY";;
		esac
		done
        ;;
	"Справка")
		echo "Введите интересующую команду"
		;;
	"Выйти")
		break
		;;
	*) echo "Неправильная команда";;
	esac
done
