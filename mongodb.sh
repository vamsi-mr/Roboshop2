#/bin/bash

source ./common.sh
app_name=mongodb

check_root_access

cp mongodb.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copying mongodb.repo"

dnf install mongodb-org -y &>>$LOG_FILE
VALIDATE $? "Installing MongoDB server"

systemctl enable mongod &>>$LOG_FILE
VALIDATE $? "Enabling MongodB"

systemctl start mongod &>>$LOG_FILE
VALIDATE $? "Starting MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>>$LOG_FILE
VALIDATE $? "Editing MOngoDB configuration file to enable remote connections"

systemctl restart mongod &>>$LOG_FILE
VALIDATE $? "Restarting MongoDB"

END_TIME=$(date +%s)
TOTAL_TIME=$(( $END_TIME - $START_TIME ))

echo "Script execution completed successfully, $Y time taken: $TOTAL_TIME seconds $N" | tee -a $LOG_FILE