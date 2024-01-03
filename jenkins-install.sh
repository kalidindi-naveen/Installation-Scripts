#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOG=Jenkins-install.log

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

sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
VALIDATE $? "Addedd Jenkins Repo"

sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
VALIDATE $? "Addedd Jenkins Key"

sudo dnf install java-17-amazon-corretto -y &>>$LOG
VALIDATE $? "Installed Java"

dnf install jenkins -y &>>$LOG
VALIDATE $? "Installing Jenkins"

systemctl enable jenkins &>>$LOG
VALIDATE $? "Enable Jenkins"

sudo systemctl start jenkins &>>$LOG
VALIDATE $? "Start Jenkins"

dnf install git -y &>>$LOG
VALIDATE $? "Installing GIT"

dnf install maven -y &>>$LOG
VALIDATE $? "Installing Maven"

echo  -e "$R You need logout and login to the server $N"
