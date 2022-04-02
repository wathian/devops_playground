# Node.js, Express & MySQL: Simple Add, Edit, Delete, View (CRUD)

A simple and basic CRUD application (Create, Read, Update, Delete) using Node.js, Express, MySQL & EJS Templating Engine.

Guide: [Node.js, Express & MySQL: Simple Add, Edit, Delete, View (CRUD)](http://blog.chapagain.com.np/node-js-express-mysql-simple-add-edit-delete-view-crud/)

## Get Started

```
# This will create new/update existing package.json
npm init

# This will install all dependencies defined in package.json
npm install

# Running the NodeJS App
node app.js
```

## Architecture

![symbiosis_architecture](./symbiosis_infra.drawio.png?raw=true)

## TODO

1. Package all into docker image
2. Run deploy script to pull the image and run as container
3. Setup ELB (public) -> EC2 (private)
4. EC2 should have docker, docker-compose installed

## Database

### Install MySQL

1. [MySQL Server ver. 8](https://dev.mysql.com/downloads/mysql)
2. [MySQL CLI ver. 8](https://dev.mysql.com/downloads/shell/)
3. [MySQL Workbench ver. 8](https://dev.mysql.com/downloads/workbench/)

```
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
mysql --sql --host=localhost --user=root --password

# Connect to localhost as root using SQL Shell
sql> \connect root@localhost

sql> create database test;
sql> use test;

sql> CREATE TABLE users (
    id int(11) NOT NULL auto_increment,
    name varchar(100) NOT NULL,
    age int(3) NOT NULL,
    email varchar(100) NOT NULL,
    PRIMARY KEY (id)
    );
```
