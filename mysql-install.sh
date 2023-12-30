#!/bin/bash

if [ "$(whoami)" != "root" ]; then
  echo "Please run as root"
  exit 1
else
  echo "Proceed with Installation"
fi

# Download MySQL RPM
wget https://dev.mysql.com/get/mysql80-community-release-el9-4.noarch.rpm

# Check if the download was successful
if [ $? -ne 0 ]; then
  echo "Error downloading MySQL RPM. Exiting."
  exit 1
fi

# Install MySQL
dnf install mysql80-community-release-el9-4.noarch.rpm -y
dnf install mysql-community-server -y

# Check if installation was successful
if [ $? -ne 0 ]; then
  echo "Error in Installing MySQL"
  exit 1
else
  echo "Installed MySQL Successfully"
fi

# Enable and start MySQL service
systemctl enable mysqld
systemctl start mysqld

# Display MySQL version and service status
echo "MySQL Version: $(mysql -V)"
echo "MySQL Service Status: $(systemctl status mysqld)"
