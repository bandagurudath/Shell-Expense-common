#!/bin/bash

source ./common.sh

root

echo "Enter mysql_root_password"
read mysql_root_password

dnf install mysql-server -y &>>$LOGPATH
validate $? "Installing mysql-server"

systemctl start mysqld &>>$LOGPATH
validate $? "Starting mysqld service"

systemctl enable mysqld &>>$LOGPATH
validate $? "enabling mysqld service"

mysql -h db.gurudathbn.site -uroot -p$mysql_root_password -e 'show databases;' &>>$LOGPATH
if [ $? -eq 0 ]
then
echo "mysql_root_password is alreday set"
else
mysql_secure_installation --set-root-pass $mysql_root_password &>>$LOGPATH
validate $? "Setting mysql root password"
fi