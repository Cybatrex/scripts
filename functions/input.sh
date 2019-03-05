#!/bin/bash
#запрос на добавление сайта laravel
declare -x -f inputSite_Laravel


declare -x -f userAddSystem_req


userAddSystem_req() {
    echo -e "${COLOR_YELLOW}"Список имеющихся пользователей системы:"${COLOR_NC}"
	viewGroupUsersAccessAll
	#Проверка на существование параметров запуска скрипта

	if [ -n "$1" ]
	then
	#Параметры запуска существуют
	    username=$1
	    dt=$DATETIMESQLFORMAT

	else
	    echo -e -n "${COLOR_BLUE}"Введите имя нового пользователя: "${COLOR_NC}"
		read username
	fi
	    grep "^$username:" /etc/passwd >/dev/null

	    #Проверка на успешность выполнения предыдущей команды
	    if [ $? -eq 0 ]
	    	then
	    		#Пользователь уже существует
	    		echo -e "${COLOR_RED}Пользователь ${COLOR_GREEN}\"$username\"${COLOR_RED} уже существует${COLOR_NC}"
	    		return 1
	    		#Пользователь уже существует (конец)
	    else
                #Пользователь не существует и будет добавлен
                echo -n -e "${COLOR_YELLOW}Подтвердите добавление пользователя ${COLOR_GREEN}\"$username\"${COLOR_YELLOW} введя ${COLOR_BLUE}\"y\"${COLOR_YELLOW}, или для отмены операции ${COLOR_BLUE}\"n\"${COLOR_NC}: "
                while read
                do
                    case "$REPLY" in
                        y|Y)
                            echo -e "${COLOR_YELLOW}Выполнение операций по созданию пользователя ${COLOR_GREEN}\"$username\"${COLOR_NC}"
                            echo -n -e "${COLOR_YELLOW}Установите пароль пользователя ${COLOR_GREEN}$username: ${COLOR_NC}: "
                            read password

                            #Проверка на пустое значение переменной
                            if [[ -z "$password" ]]; then
                                #переменная имеет пустое значение
                                echo -e "${COLOR_RED}"Пароль не может быть пустым. Отмена создания пользователя"${COLOR_NC}"
                                #переменная имеет пустое значение (конец)
                            else
                                #переменная имеет не пустое значение


                                return 0
                            fi
                            #Проверка на пустое значение переменной (конец)

                            break
                            ;;
                        n|N)
                            echo -e "${COLOR_RED}Отмена создания пользователя ${COLOR_GREEN}\"$username\"${COLOR_NC}"
                            return 2
                            break
                            ;;
                        *) echo -n "Команда не распознана: ('$REPLY'). Повторите ввод:" >&2
                           ;;
                    esac
                done

	##Здесь описать порядок действий при создании пользователя
	return 0
                #Пользователь не существует и будет добавлен (конец)
	    fi
	    #Конец проверки на успешность выполнения предыдущей команды
	#Параметры запуска существуют (конец)
}




#запрос на добавление сайта laravel
#$1 - whoami
#return 0 - выполнено успешно, 1 - пользователя $username не существует
inputSite_Laravel() {
    #Проверка на существование параметров запуска скрипта
    if [ -n "$1" ]
    then
    #Параметры запуска существуют
        username=$1
    #Параметры запуска существуют (конец)
    else
    #Параметры запуска отсутствуют
        read -p "Введите имя пользователя, от чьего имени будет запущен скрипт: " username
    #Параметры запуска отсутствуют (конец)
    fi
    #Конец проверки существования параметров запуска скрипта

    #Проверка существования системного пользователя "$username"
    	grep "^$username:" /etc/passwd >/dev/null
    	if  [ $? -eq 0 ]
    	then
    	#Пользователь $username существует
                echo -e "\n${COLOR_GREEN}Добавление сайта на фреймворке Laravel ${COLOR_NC}"
                echo -e "${COLOR_YELLOW}Список имеющихся доменов на сервере: ${COLOR_NC}"
                ls $HOMEPATHWEBUSERS/$username
                echo ""
                echo -n -e "${COLOR_BLUE}Введите домен${COLOR_NC}"
                read -p ": " domain
                echo ''
                site_path=$HOMEPATHWEBUSERS/$username/$domain
                echo -e "${COLOR_YELLOW}Возможные варианты шаблонов apache: ${COLOR_NC}"
                ls $TEMPLATES/apache2/
                echo -n -e "${COLOR_BLUE}Введите название конфигурации apache: ${COLOR_NC}"
                read apache_config
                echo ''
                echo -e "${COLOR_YELLOW}Возможные варианты шаблонов nginx: ${COLOR_NC}"
                ls $TEMPLATES/nginx/
                echo -n -e "${COLOR_BLUE}Введите название конфигурации nginx: ${COLOR_NC}"
                read nginx_config
                echo ''
                echo -n -e "Для создания домена ${COLOR_YELLOW} $domain ${COLOR_NC}, пользователя ${COLOR_YELLOW} $username ${COLOR_NC} в каталоге ${COLOR_YELLOW} $site_path ${COLOR_NC} с конфигурацией apache ${COLOR_YELLOW} \"$apache_config\" ${COLOR_NC} и конфирурацией nginx ${COLOR_YELLOW} \"$nginx_config\" ${COLOR_NC} введите ${COLOR_BLUE}\"y\"${COLOR_NC}, для выхода - любой символ: "
                read item
                case "$item" in
                    y|Y) echo
                        createSite_Laravel $domain $username $site_path $apache_config $nginx_config
                        exit 0
                        ;;
                    *) echo "Выход..."
                        exit 0
                        ;;
                esac
    	#Пользователь $username существует (конец)
    	else
    	#Пользователь $username не существует
    	    echo -e "\n${COLOR_RED}Пользователь ${COLOR_GREEN}\"$username\"${COLOR_RED} не существует. Выполнение скрипта ${COLOR_GREEN}\"inputSite_Laravel\" остановлено${COLOR_NC}"
    	    viewGroupUsersAccessAll "Полный перечень пользователей системы:"
            return 1
    	#Пользователь $username не существует (конец)
    	fi
    #Конец проверки существования системного пользователя $username



}