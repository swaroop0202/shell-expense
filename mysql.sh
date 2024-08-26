#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
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
        echo "$2...failure"
        exit1
    else
        echo "$2..success"
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