#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"
echo " Please enter DB password:"
read mysql_root_password

VALIDATE(){
    if [ $1 -ne 0 ]
    then
       echo -e "$2...$R FAILURE $N"
       exit 2
    else
       echo -e "$2...$G SUCCESS $N"
    fi
}
if [ $USERID -ne 0 ]
then 
   echo "Please run this script in root access"
   exit 1
else
   echo "You are a super user"
fi
 
dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installing MYSQL server"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "Enabling MYSQL server"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "Starting MYSQL server"

# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
# VALIDATE $? "Setting up root password"

# Below code will be used to idempotent nature
mysql -h mysql.rajinikar.cloud -uroot -pExpenseApp@1 -e 'show databases;' &>>$LOGFILE
if [$? -ne 0]
then 
   echo "mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
   VALIDATE $? "MYSQL root password setup"
else
   echo -e " MYSQL root password is already setup...$Y SKIPPING $N"
fi