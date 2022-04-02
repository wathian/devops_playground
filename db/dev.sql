CREATE database app;

use app;

CREATE TABLE
    users (
        id INT(11) NOT NULL auto_increment,
        name VARCHAR(100) NOT NULL,
        age INT(3) NOT NULL,
        email VARCHAR(100) NOT NULL,
        PRIMARY KEY (id)
    );