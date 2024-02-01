#!bin/bash

DATE=$(date +%F)
LOGDIR=/home/centos/shellscript-logs
SCRIPT_NAME=$0
LOGFILE=$LOGDIR/$0-$DATE.log
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
    if [ $1 is ne 0 ]
    then
        echo -e "installing $2 .......$R Failure $N"
    else
        echo -e "installing $2 ....... $G Success $N"
    fi

}


if [ $USERID -ne 0 ]
then
    echo "ERROR::Please run this script with root access"
    exit 1
fi





for i in $@
do 
    yum list installed $i &>>$LOGFILE
    if [ $? -ne 0 ]
    then
        echo "$i is not installed, lets install it"
        yum install $i -y &>>$LOGFILE
        VALIDATE $? "$i"
    else
        echo -e "$Y $i is already installed $N"
    fi
done
