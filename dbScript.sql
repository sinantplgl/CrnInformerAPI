CREATE DATABASE CrnInformer;

USE CrnInformer;

CREATE TABLE users(
    id int not null auto_increment,
    email nvarchar(30) not null,
    primary key (id)
) ENGINE=InnoDB;

CREATE TABLE crns(
    id int not null auto_increment,
    crn nvarchar(5) not null,
    primary key (id)
) ENGINE=InnoDB;

CREATE TABLE requests(
    id int not null auto_increment,
    user_id int,
    crn_id int,
    is_active boolean,
    primary key (id),
    foreign key (user_id) references users(id),
    foreign key (crn_id) references crns(id)
) ENGINE=InnoDB;
