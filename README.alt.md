# A CRUD Application hosted in AWS EC2 with a simple CI/CD Deployment Pipeline

## Disclaimer

Forked Repository: [chapagain/nodejs-mysql-crud](https://github.com/chapagain/nodejs-mysql-crud)

Original Guide: [Node.js, Express & MySQL: Simple Add, Edit, Delete, View (CRUD)](http://blog.chapagain.com.np/node-js-express-mysql-simple-add-edit-delete-view-crud/

## TODO

1. Setup ALB (NLB not necessary) but be prepared to justify
2. Improve semantic versioning logic to allow MAJOR/MINOR/PATCH
3. Setup EC2 Autoscaling Group
## Future Consideration

1. Package all into docker image
2. Run deploy script to pull the image and run as container
3. EC2 can use docker, docker-compose to run the containerized environment
4. Use K8/ECS for Orchastration

## Security Concerns

1. Config files contain credentials: To fetch as Github Secrets/AWS Secrets Manager/EC2 Parameter Store
2. EC2 contains private key: to generate new ones and store as Deploy Keys PER repository as global ones can pull from ANY repository in this account
3. EC2 is publicly available, publicly ssh-able: Limit access through IP Whitelist, Bastion/Jump Host, VPN, AWS Cognito, AWS Session Manager
4. Insecure API calls using Basic Authenticaton: Use API Keys, JWT, OAuth OIDC

## Architecture

### Techstack

| Front-End             | Back-End | Infrastructure |
| --------------------- | -------- | -------------- |
| NodeJS                | MySQL    | Terraform      |
| Express               |          | Cloudposse     |
| EJS Templating Engine |          |                |
|                       |          |                |

### CI/CD Pipeline

![symbiosis_cicd](./diagram/symbiosis-cicd.drawio.png?raw=true)
### Infrastructure (Current)

![symbiosis_architecture](./diagram/symbiosis_infra_current.drawio.png?raw=true)

### Infrastructure (Ideal)

![symbiosis_architecture](./diagram/symbiosis_infra.drawio.png?raw=true)

## Setup

### Pre-Requisite

```
# git
yum install git

# clone repository
git clone https://github.com/wathian/govtech_devops_2022.git

# clone submodule
git submodule init
git submodule update
```

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

### API

| Endpoints  | Authentication | Description              |
| ---------- | -------------- | ------------------------ |
| /api       | Basic          | Healthcheck              |
| /api/users | Basic          | List all available users |

> All API calls require Basic Authentication and can be set by passing in the Authorization headers

```bash
APP_API_STATUS=$(curl --get --silent --header "Authorization: Basic dGVzdDp0ZXN0MTIz" http://127.0.0.1:3000/api | jq .status)
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
sudo systemctl set-environment ENV=uat
sudo systemctl import-environment ENV
sudo systemctl stop symbiosis-app.service
# Returns 0 (active) | >0 (inactive)
sudo systemctl is-active symbiosis-app.service
```

### NodeJS Healthcheck

After starting of the NodeJS service, we will utilize an API endpoint to check whether it is stable.

```bash
END=6
START=1
while [[ $START -le $END ]]; do
    APP_API_STATUS=$(curl --get --silent --header "Authorization: Basic dGVzdDp0ZXN0MTIz" http://127.0.0.1:3000/api | jq .status)
    if [[ $APP_API_STATUS -eq 10000 ]]; then
        sudo systemctl status symbiosis-app.service
        exit 0
    else
        if [[ $START -eq $END ]]; then
            sudo systemctl status symbiosis-app.service
            exit 1
        fi
        sleep $START
    fi
    START=$(( $START + 1 ))
done
```
