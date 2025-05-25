#!/bin/bash

START_TIME=$(date +%s)
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOGSFOLDER="/var/log/roboshop-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE=$LOGSFOLDER/$SCRIPT_NAME
SCRIPT_DIR=$PWD

    mkdir -p $LOGSFOLDER
    echo "Script started executing at: $(date)" | tee -a $LOG_FILE


check_root_access() {
    if [ $USERID -ne 0 ]
    then    
        echo -e "$R ERROR : Please run with root access $N" | tee -a $LOG_FILE
        exit 1
    else    
        echo -e "$Y You are running with root access $N" | tee -a $LOG_FILE
fi  
}


VALIDATE() {
    if [ $1 -eq 0 ]
    then
        echo -e "$G $2 is ...... SUCCESS $N" | tee -a $LOG_FILE
    else 
        echo -e "$R $2 is ...... FAILURE $N" | tee -a $LOG_FILE
        exit 1
fi
}

app_setup() {
        id roboshop
        if [ $? -ne 0 ]
        then
            useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
            VALIDATE $? "Creating Roboshop user"
        else 
            echo -e "$Y System user roboshop is already created ..... SKIPPING $N"
    fi
    
    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$LOG_FILE
    VALIDATE $? "Downloading $app_name file"

    mkdir -p /app 
    VALIDATE $? "Creating app directory"

    rm -rf /app/*
    cd /app
    unzip /tmp/$app_name.zip &>>$LOG_FILE
    VALIDATE $? "Unzipping $app_name file"
}


nodejs_setup(){
    dnf module disable nodejs -y &>>$LOG_FILE
    VALIDATE $? "Disabling Nodejs"

    dnf module enable nodejs:20 -y &>>$LOG_FILE
    VALIDATE $? "Enabling Nodejs"

    dnf install nodejs -y &>>$LOG_FILE
    VALIDATE $? "Installing Nodejs"

    npm install &>>$LOG_FILE
    VALIDATE $? "Installing Dependencies"
}

systemd_setup(){
    cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service
    VALIDATE $? "Copying $app_name service file"
    
    systemctl daemon-reload &>>$LOG_FILE
    VALIDATE $? "Daemon reloading"

    systemctl enable $app_name &>>$LOG_FILE
    VALIDATE $? "Enabling $app_name"

    systemctl start $app_name &>>$LOG_FILE
    VALIDATE $? "Starting $app_name"
}

maven_setup(){
    dnf install maven -y
    VALIDATE $? "Installing Maven and Java"

    mvn clean package  &>>$LOG_FILE
    VALIDATE $? "Packaging the shipping application"

    mv target/shipping-1.0.jar shipping.jar  &>>$LOG_FILE
    VALIDATE $? "Moving and renaming Jar file"
}


python_setup(){
    dnf install python3 gcc python3-devel -y &>>$LOG_FILE
    VALIDATE $? "Install Python3 packages"

    pip3 install -r requirements.txt &>>$LOG_FILE
    VALIDATE $? "Installing dependencies"

}


print_time(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(($END_TIME - $START_TIME))
    echo -e "Script executed successfully, $Y Time taken: $TOTAL_TIME seconds $N"
}