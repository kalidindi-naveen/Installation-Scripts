#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOG=Tomcat-install.log

USER_ID=$(id -u)
if [ $USER_ID -ne 0 ]; then
	echo  -e "$R You are not the root user, you dont have permissions to run this $N"
	exit 1
fi

VALIDATE(){
	if [ $1 -ne 0 ]; then
		echo -e "$2 ... $R FAILED $N"
		exit 1
	else
		echo -e "$2 ... $G SUCCESS $N"
	fi

}

dnf update  -y &>>$LOG
VALIDATE $? "Updating packages"

dnf install java-17-amazon-corretto -y &>>$LOG
VALIDATE $? "Installed Java"

cd /opt
wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.17/bin/apache-tomcat-10.1.17.tar.gz
VALIDATE $? "Downloaded Tomcat"

tar -xvzf apache-tomcat-10.1.17.tar.gz
VALIDATE $? "Untar Tomcat"

mv apache-tomcat-10.1.17 tomcat
VALIDATE $? "Rename Folder to Tomcat"

cd /opt/tomcat/bin
sh startup.sh
VALIDATE $? "Running Tomcat"
