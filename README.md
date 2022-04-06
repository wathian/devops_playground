# Node.js, Express & MySQL: Simple Add, Edit, Delete, View (CRUD)

A CRUD application hosted in AWS EC2 provisioned via Terraform
## Disclaimer

Forked Repository: [chapagain/nodejs-mysql-crud](https://github.com/chapagain/nodejs-mysql-crud)

Original Guide: [Node.js, Express & MySQL: Simple Add, Edit, Delete, View (CRUD)](http://blog.chapagain.com.np/node-js-express-mysql-simple-add-edit-delete-view-crud/)

## Techstack

| Front-End                 | Back-End  | Infrastructure |
| ------------------------- | --------- | -------------- |
| NodeJS                    | MySQL     | Terraform      |
| Express                   |           | Cloudposse     |
| EJS Templating Engine     |           |                |
|                           |           |                |
## Pre-Requisite

```
# git
yum install git

# clone repository
git clone https://github.com/wathian/govtech_devops_2022.git

# clone submodule
git submodule init
git submodule update
```

## TODO

1. Package all into docker image
2. Run deploy script to pull the image and run as container
3. Setup NLB (public) -> ALB (public) -> EC2 (private)
4. EC2 can use docker, docker-compose to run the containerized environment

## Security Concerns
1. Contains DB credentials: to isolate from db/dev.sql and store into Github Secrets/AWS Secrets Manager/EC2 Parameter Store
2. EC2 contains Github Private Key: to generate new ones and store .pub as Deploy Keys PER repository rather than global ones which can pull from ANY repository of the account
3. EC2 is publicly available, publicly ssh-able: IP Whitelist, Bastion/Jump Host, VPN, AWS Cognito

## Architecture
### Current
![symbiosis_architecture](./symbiosis_infra_current.drawio.png?raw=true)
### Ideal
![symbiosis_architecture](./symbiosis_infra.drawio.png?raw=true)
## Setup

### Running NodeJS

```
# nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
source ~/.bashrc

# node
export NODE_VERSION=16.2.0
nvm install ${NODE_VERSION}

# This will create new/update existing package.json
npm init --yes

# This will install all dependencies defined in package.json
rm -rf node_modules/
npm install

# Running the NodeJS App
node app.js
```

### Install MySQL

1. [MySQL Server ver. 8.0.28](https://dev.mysql.com/downloads/mysql)
2. [MySQL Shell ver. 8.0.28](https://dev.mysql.com/downloads/shell/)
3. [MySQL Workbench ver. 8.0.28](https://dev.mysql.com/downloads/workbench/)

```
# Setup, Check & Enable YUM Repository for MySQL
sudo yum -y install db/mysql80-community-release-el8-3.noarch.rpm
ls -al /etc/yum.repos.d
yum repolist all
yum repolist enabled | grep "mysql"
sudo yum-config-manager --enable mysql80-community

# Install SQLServer and Shell
sudo yum install mysql-community-server

# Install SQL CLI
yum install mysql-client

# Install SQL Shell
yum install mysql-shell

# Use this for ensuring compatibility with MySQL ver.8
npm install mysql2 -save

# In app.js, change this line to use mysql2
var mysql = require('mysql2')

```

### Create Database & Table

```

# Run MySQL Shell with SQL Language
mysqlsh --sql

# Connect to localhost as root using SQL CLI
mysqlsh --sql --host=localhost --user=root --password

# Connect to localhost as root using SQL Shell
sql> \connect root@localhost

sql> create database app;
sql> use app;

sql> CREATE TABLE users (
        id int(11) NOT NULL auto_increment,
        name varchar(100) NOT NULL,
        age int(3) NOT NULL,
        email varchar(100) NOT NULL,
        PRIMARY KEY (id)
    );

# Run all of the above as sql script
chmod u+x db/dev.sql
## Redirects stderr > stdout outputs to both display on terminal and save as sql.log
mysql -h localhost -u root -p < db/dev.sql 2>&1 | tee ./sql.log
```

### Automate NodeJS Service

```
cd /app/govtech_devops_2022
sudo cp deploy/symbiosis-app.service /etc/systemd/system
chown ec2-user /etc/systemd/system/symbiosis-app.service
chmod u+x /etc/systemd/system/symbiosis-app.service
sudo systemctl daemon-reload
sudo systemctl enable symbiosis-app.service
sudo systemctl start symbiosis-app.service

# Useful
sudo systemctl stop symbiosis-app.service
# Returns 0 (active) | >0 (inactive)
sudo systemctl is-active symbiosis-app.service
```
