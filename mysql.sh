#!/bin/bash

DATE=$(date +%F)
    SCRIPT_NAME=$0
    LOGFILE=/tmp/$SCRIPT_NAME-$DATE.log
    R="\e[31m"
    G="\e[32m"
    N="\e[0m"

cartID=$(id -u)
if [ $cartID -ne 0 ]
then
echo -e "$R ERROR:: Please sign in with root access $N"
exit 1
fi

VALIDATE(){
if [ $1 -ne 0 ]
then
echo -e "$2 ........$R FAILURE $N"
exit 1
else 
echo -e "$2............$G SUCCESS $N"
fi
}

yum module disable mysql -y &>>$LOGFILE
VALIDATE $? "Disabling mysql"

cp mysql.repo /etc/yum.repos.d/mysql.repo  &>>$LOGFILE
VALIDATE $? "Copying mysql.repo"

yum install mysql-community-server -y &>>$LOGFILE
VALIDATE $? "Installing mysql"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "Enabling mysql"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "Starting mysql"

mysql_secure_installation --set-root-pass RoboShop@1 &>>$LOGFILE
VALIDATE $? "Setting cartname and password"

# mysql -uroot -pRoboShop@1 &>>$LOGFILE
# VALIDATE $? "Checking cartname and password"