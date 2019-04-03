#!/bin/bash

#Создание коммита
Git_commit() {
    echo -n -e "Для создания коммита репозитария ${COLOR_YELLOW}\""$SCRIPTS"\"${COLOR_NC} введите ${COLOR_BLUE}\"y\"${COLOR_NC}, для выхода - ${COLOR_BLUE}\"n\"${COLOR_NC}: "
    while read
        do
            case "$REPLY" in
            "y"|"Y")
                echo -n -e "Для задания имени коммита введите ${COLOR_BLUE}\"y\"${COLOR_NC}, задания вместо имени даты-времени - введите ${COLOR_BLUE}\"любой символ\"${COLOR_NC}: "
                    while read
                        do
                            case "$REPLY" in
                            "y"|"Y")
                                echo -n -e "${COLOR_BLUE}Введите комментарий коммита${COLOR_NC}"
                                read -p ": " comment
                                dt=$(date '+%d/%m/%Y %H:%M:%S')
                                sudo git add .
                                sudo git commit -m "$dt - $comment"
                                break
                                ;;
                            *)
                                dt=$(date '+%d/%m/%Y %H:%M:%S')
                                sudo git add .
                                sudo git commit -m "$dt"
                                break;;
                            esac
                        done
                break
                ;;
            "n"|"N")
                echo 'Отмена создания коммита'
                    menuGit $1
                break;;

            *) echo -n "Команда не распознана: ('$REPLY'). Повторите ввод:" >&2;;
            esac
        done
        menuGit $1
}

#публикация проекта во внешнем репозитарии
Git_remotePush() {
    cd $SCRIPTS
    echo -e "\n${COLOR_YELLOW}Публикация репозитария на github.com и Bitbucket.org:${COLOR_NC}"
    sudo git remote add github https://trashsh@github.com/trashsh/scripts.git
    sudo git remote add bitbucket https://gothundead@bitbucket.org/gothundead/scripts.git
    sudo git push github master
    sudo git push bitbucket master
    echo ""
    menuGit $1
}

# просмотр удаленных репозитариев
Git_remoteView() {
        echo $1
		cd $SCRIPTS
		echo -e "\n${COLOR_YELLOW}Список удаленных репозиториев:${COLOR_NC}"
		git remote -v
		menuGit $1
}
