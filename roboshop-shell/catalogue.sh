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
    echo -e "$R ERROR::Please run this script with root access $N"
    exit 1
fi

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE

VALIDATE $? "setting up NPM source"

yum install nodejs -y &>>$LOGFILE

VALIDATE $? "Installing NodeJS"

useradd roboshop &>>$LOGFILE

mkdir /app &>>$LOGFILE

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>>$LOGFILE

VALIDATE $? "downloading catalogue artifact"

cd /app &>>$LOGFILE

VALIDATE $? "Moving into app directory"

unzip /tmp/catalogue.zip &>>$LOGFILE

VALIDATE $? "Unzipping catalogue"

npm install &>>$LOGFILE

VALIDATE $? "Installing dependencies"

cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service &>>$LOGFILE

VALIDATE $? "copying catalogue.service"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "daemon-reload"

systemctl enable catalogue &>>$LOGFILE 

VALIDATE $? "enabiling catalogue"

systemctl start catalogue &>>$LOGFILE

VALIDATE $? "starting catalogue"

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE

VALIDATE $? "copying mongo repo"

yum install mongodb-org-shell -y &>>$LOGFILE

VALIDATE $? "Installing Mongo Client"

mongo --host mongodb.raheemdevops.online </app/schema/catalogue.js &>>$LOGFILE

VALIDATE $? "Loading Catalogue data into mongodb"