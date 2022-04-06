CREATE DATABASE IF NOT EXISTS app;

USE app;

CREATE TABLE IF NOT EXISTS
    users (
        id INT(11) NOT NULL auto_increment,
        name VARCHAR(100) NOT NULL,
        age INT(3) NOT NULL,
        email VARCHAR(100) NOT NULL,
        PRIMARY KEY (id)
    );

