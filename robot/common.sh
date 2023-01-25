LOGFILE=/tmp/$COMPONENT.log

ID=$(id -u)

if [ $ID -ne 0 ] ; then
    echo -e "\e[31m you need to be root user or with sudo priviledge \e[0m"
    exit 1
fi

stat() {
    if [ $1 -eq 0 ] ; then
        echo -e "\e[32m success \e[0m"
    else
        echo -e "\e[31m failed \e[0m"
    fi
}