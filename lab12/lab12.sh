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
	echo 'Лабораторная работа "Изучение SELinux"

Данный скрипт позволяет интерактивно управлять SELinux.
Запустите скрипт без аргументов чтобы увидеть список возможностей.
'
	exit
fi

PS3=$'\n> '
options=(
	"Управление портами"
	"Управление файлами"
	"Управление переключателями"
	"Справка"
	"Выйти"
)

select opt in "${options[@]}"
do
	case $opt in
	"Управление портами")
		readarray -t services < <(semanage port -l -n | cut -d' ' -f1)
		partselect services "Введите имя службы или его часть: " "Введите число, соответствующее интересующему сервису"
		res=$?
		[ $res == 0 ] && continue
		service=${services[res - 1]}
		select opt in "Добавить новый порт для службы" "Удалить порт службы" "Изменить существующий порт службы" "Справка" "Назад"; do
		case $opt in
            "Добавить новый порт для службы")
				read -p "Введите номер порта: " port
				semanage port -a -t "$service" -p tcp "$port"
                check $? "Порт добавлен" "Ошибка добавления порта"
                ;;
            "Удалить порт службы")
				readarray -t ports < <(semanage port -l | grep -E "^$service\s" | awk '{$1=$2=""; print $0}' | sed 's/,/\n/g' | sed 's/\s//g')
				listselect ports "Введите число, соответствующее интересующему порту"
				res=$?
				if [ $res -ne 0 ]; then
					port=${ports[res - 1]}
					semanage port -d -t "$service" -p tcp "$port"
                	check $? "Порт удален" "Ошибка удаления порта"
				fi
                ;;
            "Изменить существующий порт службы")
				readarray -t ports < <(semanage port -l | grep -E "^$service\s" | awk '{$1=$2=""; print $0}' | sed 's/,/\n/g' | sed 's/\s//g')
				listselect ports "Введите число, соответствующее интересующему порту"
				res=$?
				if [ $res -ne 0 ]; then
					port=${ports[res - 1]}
					read -p "Введите номер нового порта: " port2
					semanage port -d -t "$service" -p tcp "$port"
                	check $? "Порт удален" "Ошибка удаления порта"
					semanage port -a -t "$service" -p tcp "$port2"
					check $? "Порт добавлен" "Ошибка добавления порта"
				fi
                ;;
            "Справка")
                echo "Выбирете операцию над портами сервиса $service"
                ;;
            "Назад")
                break
                ;;
	        *) echo "Неправильная команда $REPLY";;
		esac
		done
		;;

	"Управление файлами")
        select opt in "Переразметка каталога" "Запустить полную переразметку файловой системы при перезагрузке" "Изменить домен файла или каталога" "Справка" "Назад"; do
		case $opt in
            "Переразметка каталога")
				read -e -p "Введите имя каталога: " path
				restorecon -Rvv "$path"
                check $? "Переразметка успешна" "Ошибка переразметки"
                ;;
            "Запустить полную переразметку файловой системы при перезагрузке")
                touch /.autorelabel
                check $? "Успешно" "Неуспешно"
                ;;
            "Изменить домен файла или каталога")
				read -e -p "Введите имя файла/каталога: " path
				path=$(realpath "$path")
				read -p "Введите новый домен: " newtype
				semanage fcontext -a -t "$newtype" "$path(/.*)?"
                check $? "" "Ошибка назначения домена"
				restorecon -Rv "$path"
                check $? "Переразметка успешна" "Ошибка переразметки"
                ;;
            "Справка")
                echo "Выбирете операцию с доменами файлов и каталогов"
                ;;
            "Назад")
                break
                ;;
	        *) echo "Неправильная команда $REPLY";;
		esac
		done
        ;;

	"Управление переключателями")
		select opt in "Вывести список переключателей с описанием и состоянием" "Изменить переключатель" "Справка" "Назад"; do
		case $opt in
            "Вывести список переключателей с описанием и состоянием")
                getsebool -a
                ;;
            "Изменить переключатель")
				readarray -t booleans < <(getsebool -a | cut -d' ' -f1)
				partselect booleans "Введите имя переключателя или его часть: " "Введите число, соответствующее интересующему переключателю"
				res=$?
				if [ $res -ne 0 ]; then
					boolean=${booleans[res - 1]}
					state=$(getsebool "$boolean" | awk -F '--> ' '{print $2}')
					echo "Текущее состояние: $state"
					read -p "Переключить (y/n)? " answer
					case ${answer:0:1} in
						y|Y )
							state=$(echo "$state" | sed -e 's/off/o_n/' -e 's/on/o_ff/' -e 's/_//')
							setsebool -P "$boolean" "$state"
               		 		check $? "Успешно: $boolean := $state" "Ошибка переключения"
						;;
					esac
				fi
                ;;
            "Справка")
                echo "Выбирете операцию над переключателями"
                ;;
            "Назад")
                break
                ;;
	        *) echo "Неправильная команда $REPLY";;
		esac
		done
		;;
	"Справка")
		echo "Введите интересующую вас команду"
		;;
	"Выйти")
		break
		;;
	*) echo "Неправильная команда $REPLY";;
	esac
done
