#!/bin/bash

START_TIME=$(date +%s)
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOGSFOLDER="/var/log/roboshop-logs
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE=$LOGSFOLDER/$SCRIPT_NAME
SCRIPT_DIR=$PWD

    mkdir -p $LOGSFOLDER
    echo "Script started executing at: $(date)" | tee -a $LOG_FILE


check_root_access () {

    if [ $USERID -ne 0 ]
    then    
        echo -e "$R ERROR : Please run with root access $N" | tee -a $LOG_FILE
        exit 1
    else    
        echo -e "$Y You are running with root access $N" | tee -a $LOG_FILE
fi  
}


VALIDATE () {
    if [ $1 -eq 0 ]
    then
        echo -e "$G $2 is ...... SUCCESS $N" | tee -a $LOG_FILE
    else 
        echo -e "$R $2 is ...... FAILURE $N" | tee -a $LOG_FILE
        exit 1
fi
}
