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
    echo "output: $line"

done <<< $Disk_USAGE
