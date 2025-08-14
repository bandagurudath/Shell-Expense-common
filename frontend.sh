#!/bin/bash

source ./common.sh

root

dnf install nginx -y &>>$LOGPATH
validate $? "Installing nginx"

systemctl start nginx &>>$LOGPATH
validate $? "starting nginx"

systemctl enable nginx &>>$LOGPATH
validate $? "enabling nginx"

rm -rf /usr/share/nginx/html &>>$LOGPATH
curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGPATH
validate $? "Downloading frontend code"

mkdir /usr/share/nginx/html &>>$LOGPATH
cd /usr/share/nginx/html &>>$LOGPATH
unzip /tmp/frontend.zip &>>$LOGPATH
validate $? "unzipping frontend code"

cp /home/ec2-user/shell-Expense-common/expense.conf /etc/nginx/default.d/expense.conf &>>$LOGPATH
validate $? "copying expense conf file"

systemctl restart nginx &>>$LOGPATH
validate $? "restarting nginx"






