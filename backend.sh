#!/bin/bash

source ./common.sh

root

echo "Enter mysql_root_password"
read mysql_root_password

dnf module disbale nodejs -y &>>$LOGPATH
validate $? "Disabling deafult nodejs"

dnf module enable nodejs:20 -y &>>$LOGPATH
validate $? "Enabling nodejs version 20"

dnf install nodejs -y &>>$LOGPATH
validate $? "starting nodejs"

id expense &>>$LOGPATH
if [ $? -eq 0 ]
then
echo "expense user already exists"
else
useradd expense &>>$LOGPATH
validate $? "creating expense user"
fi

rm -rf /app &>>$LOGPATH
curl -o /tmp/backend.service https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGPATH
validate $? "Downloading backend code to /tmp"

mkdir -p /app &>>$LOGPATH
cd /app &>>$LOGPATH
unzip /tmp/backend.zip &>>$LOGPATH
validate $? "Unzipping backend code to /app"

npm install &>>$LOGPATH
validate $? "installing node js dependencies"

cp /home/ec2-user/shell-expense/backend.service /etc/systemd/system/backend.service &>>$LOGPATH
validate $? "copyinh backend service file to systemd"

systemctl daemon-reload &>>$LOGPATH
validate $? "reloading daemon"

mysql -h db.gurudathbn.site -uroot -p$mysql_root_password < /app/schema/backend.sql &>>$LOGPATH
validate $? "loading data to mysql"

systemctl start backend &>>$LOGPATH
validate $? "Starting backend"

