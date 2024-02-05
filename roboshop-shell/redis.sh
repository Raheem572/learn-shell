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
        exit 1
    else
        echo -e "$2 ....... $G Success $N"
    fi

}


if [ $USERID -ne 0 ];
then
    echo -e "$R ERROR::Please run this script with root access $N"
    exit 1
fi


yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$LOGFILE

VALIDATE $? "Installing Redis repo"

yum module enable redis:remi-6.2 -y &>>$LOGFILE

VALIDATE $? "Enabiling redis 6.2"

yum install redis -y &>>$LOGFILE

VALIDATE $? "Installing redis 6.2"

sed -i "s/127.0.0.1/0.0.0.0/g" /etc/redis.conf /etc/redis/redis.conf

VALIDATE $? "Allowing remore connections to redis"

systemctl enable redis &>>$LOGFILE

VALIDATE $? "Enabiling redis"

systemctl start redis &>>$LOGFILE

VALIDATE $? "starting redis"
