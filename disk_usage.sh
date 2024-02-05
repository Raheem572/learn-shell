#!bin/bash

LOGFILE_DIRECTORY=/tmp
DATE=$(date +%F:%H:%M:%s)
SCRIPT_NAME=$0
LOGFILE=$LOGFILE_DIRECTORY/$SCRIPT_NAME/$DATE.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

DISK_USAGE=$(df -hT | grep -vE 'tmpfs|Filesystem')
DISK_USAGE_THRESHOLD=1

while IFS= read line
do
    usage=$(echo $line | awk '{print $6}' | cut -d % -f1)
    partition=$(echo $line | awk '{print $1}')
    if [ $usage -gt $DISK_USAGE_THRESHOLD ]
    then
        message+="HIGH DISK USSAGE ON $partition: $usage \n"
    fi
done <<< $DISK_USAGE

echo -e "message: $message"

#echo "$message" | mail -s "HIGH DISK USSAGE" raheembasha1993@gmail.com

mail.sh raheembasha1993@gmail.com "HIGH DISK USSAGE" "$message" "DEVOPS TEAM" "HIGH DISK USSAGE"