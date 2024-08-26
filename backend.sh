USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
W="\e[37m"

if [ $USERID -ne 0 ]
    then 
        echo "please run this script as root user"
    else
        echo -e "$G you are a super user $W"
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

dnf module disable nodejs -y
VALIDATE $? "disabling nodejs"

dnf module enable nodejs:20 -y
VALIDATE $? "enabling nodejs20"

dnf install nodejs -y
VALIDATE $? "installing nodejs"

id expense
if [ $? -ne 0 ]
    then
        useradd expense
        echo "creating user expense"
    else
        echo "expense user is already there"


mkdir -p /app
VALIDATE $? "creating a directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
VALIDATE $? "downloading code"

cd /app
VALIDATE $? "change directory"

unzip /tmp/backend.zip
VALIDATE $? "unzipping the code"

cd /app
npm install
VALIDATE $? "downloading the dependencies"

cp /home/ec2-user/shell-expense/backend.service  /etc/systemd/system/backend.service

systemctl daemon-reload

systemctl enable backend

dnf install mysql -y

mysql -h 172.31.86.13 -uroot -pExpenseApp@1 < /app/schema/backend.sql
