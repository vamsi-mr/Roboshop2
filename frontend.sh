#/bin/bash

source ./common.sh

check_root_access
VALIDATE

#installing Nginx

dnf module disable nginx -y &>>$LOG_FILE
VALIDATE $? "Disabling Default Nginx"

dnf module enable nginx:1.24 -y &>>$LOG_FILE
VALIDATE $? "Enabling Nginx:1.24"

dnf install nginx -y &>>$LOG_FILE
VALIDATE $? "Installing Nginx"

systemctl enable nginx  &>>$LOG_FILE
VALIDATE $? "Enabling Nginx"

systemctl start nginx &>>$LOG_FILE
VALIDATE $? "Starting Nginx"

rm -rf /usr/share/nginx/html/* &>>$LOG_FILE
VALIDATE $? "Removing default content"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$LOG_FILE
VALIDATE $? "Downloading frontend"

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip &>>$LOG_FILE
VALIDATE $? "unzipping frontend"

rm -rf /etc/nginx/nginx.conf &>>$LOG_FILE
VALIDATE $? "Remove default nginx conf"

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf
VALIDATE $? "Copying nginx.conf"

systemctl restart nginx &>>$LOG_FILE
VALIDATE $? "Restarting nginx"

print_time