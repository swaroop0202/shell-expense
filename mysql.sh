#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
W="\e[37m"

echo "please enter root password"
read  "passwrd"

if [ $USERID -ne 0 ]
    then 
        echo "please run this script as root user"
    else
        echo "you are a super user"
fi

VALIDATE() {
if [ $1 -ne 0 ]
    then
        echo -e "$2...$R failure $W"
        exit1
    else
        echo -e "$2... $G success $W"
fi
}

dnf install mysql-server -y
VALIDATE $? "installing mysql server"

systemctl enable mysqld
VALIDATE $? "enabling mysql"

systemctl start mysqld
VALIDATE $? "starting mysql"

mysql_secure_installation --set-root-pass $passwrd
VALIDATE $? "setting the root password"