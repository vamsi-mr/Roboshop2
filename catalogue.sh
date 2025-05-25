#/bin/bash

source ./common.sh
app_name=catalogue

check_root_access
app_setup
nodejs_setup
systemd_setup


cp $SCRIPT_DIR/mongodb.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copying mongodb.repo"

dnf install mongodb-mongosh -y -y &>>$LOG_FILE
VALIDATE $? "Installing MongoDB client"

mongosh --host mongodb.ravada.site </app/db/master-data.js &>>$LOG_FILE
VALIDATE $? "Loading data to the $app_name"

END_TIME=$(date +%s)
TOTAL_TIME=$(( $END_TIME - $START_TIME ))

echo "Script execution completed successfully, $Y time taken: $TOTAL_TIME seconds $N" | tee -a $LOG_FILE