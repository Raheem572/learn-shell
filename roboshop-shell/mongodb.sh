#!bin/bash

DATE=$(date +%F)
LOGDIR=/tmp
SCRIPT_NAME=$0
LOGFILE=$LOGDIR/$SCRIPT_NAME-$DATE.log
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
    if [ $1 is ne 0 ]
    then
        echo -e "$2 .......$R Failure $N"
    else
        echo -e "$2 ....... $G Success $N"
    fi

}


if [ $USERID -ne 0 ]
then
    echo "ERROR::Please run this script with root access"
    exit 1
fi

cp mongo.repo /etc/yum.repos.d/mongo.repo

yum install mongodb-org -y &>>$LOGFILE

VALIDATE $? "installing mongodb"

systemctl enable mongod &>>$LOGFILE

VALIDATE $? "enabiling mongodb"

systemctl start mongod &>>$LOGFILE

VALIDATE $? "started mongodb"

sed -i "s/127.0.0.1/0.0.0.0/" /etc/mongod.conf &>>$LOGFILE

VALIDATE $? "edited mongodb conf file"

systemctl restart mongod &>>$LOGFILE

VALIDATE $? "restarted mongodb"