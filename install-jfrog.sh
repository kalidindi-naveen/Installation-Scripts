#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOG=jfrog-install.log

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

docker pull docker.bintray.io/jfrog/artifactory-oss:latest
VALIDATE $? "Pull Docker Image"

mkdir -p /jfrog/artifactory
VALIDATE $? "Making jfrog/artifactory Directory"

chown -R 1030 /jfrog/
VALIDATE $? "Changing Permissions of jfrog Directory" 

docker run --name artifactory -d \
  -p 8081:8081 \
  -p 8082:8082 \
  -v /jfrog/artifactory:/var/opt/jfrog/artifactory \
  docker.bintray.io/jfrog/artifactory-oss:latest
VALIDATE $? "Started Docker Image:- http://xx.xx.xx.xx:8081/artifactory"
