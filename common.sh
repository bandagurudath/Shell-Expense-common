#!/bin/bash

USERID=$(id -u)
SCRIPTNAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGPATH=/tmp/$SCRIPTNAME-$TIMESTAMP.log


R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

validate(){
    if [ $1 -eq 0 ]
    then
    echo -e "$2 .....$G SUCCESS $N"
    else
    echo -e "$2 .....$R FAILURE $N"
    fi
}

root(){
    if [ $USERID -eq 0 ]
    then
    echo "Yor are a super user"
    else
    echo "This script must be run by Super User"
    exit 1
    fi
}
