#/bin/bash

source ./common.sh
app_name=redis

check_root_access

dnf module disable redis -y &>>$LOG_FILE
VALIDATE $? "Disabling redis server"

dnf module enable redis:7 -y &>>$LOG_FILE
VALIDATE $? "Enabling redis server"

dnf install redis -y &>>$LOG_FILE
VALIDATE $? "Installing redis server"

systemctl enable redis &>>$LOG_FILE
VALIDATE $? "Enabling redis"

systemctl start redis &>>$LOG_FILE
VALIDATE $? "Starting redis"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf &>>$LOG_FILE
sed -i 's/protected-mode yes/protected-mode no/g' /etc/redis/redis.conf &>>$LOG_FILE
VALIDATE $? "Editing redis configuration file to enable remote connections"

systemctl restart redis &>>$LOG_FILE
VALIDATE $? "Restarting redis"

print_time