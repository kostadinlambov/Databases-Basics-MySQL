DROP DATABASE IF EXISTS minions;
CREATE DATABASE minions;

USE minions;

#2. Create Tables
#DROP TABLE IF EXISTS minions;
CREATE TABLE minions(
	id INT PRIMARY KEY,
    name VARCHAR(50),
    age INT
);

#DROP TABLE IF EXISTS towns;
CREATE TABLE towns (
    id INT PRIMARY KEY,
    name VARCHAR(50)
);
    
    
#3.	Alter Minions Table
ALTER TABLE minions
ADD COLUMN town_id INT; 

ALTER TABLE minions
ADD CONSTRAINT fk_town_id FOREIGN KEY(town_id) REFERENCES towns(id);

#4.	Insert Records in Both Tables
INSERT INTO towns(id, name)
VALUES (1, 'Sofia'),
		(2, 'Plovdiv'),
		(3, 'Varna');
        
INSERT INTO minions(id, name, age, town_id)
VALUES (1, 'Kevin', 22, 1),
		(2, 'Bob', 15, 3),
		(3, 'Steward', null, 2);
        
#5. Truncate Table Minions
#TRUNCATE TABLE minions;

#6. Drop All Tables
#DROP TABLE minions;
#DROP TABLE towns;

#7. Create Table People
CREATE TABLE people (
    id INT(10) PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL,
    picture MEDIUMBLOB,
    height FLOAT(6,2),
    weight FLOAT(6,2),
    gender ENUM('m', 'f') NOT NULL,
    birthdate DATE NOT NULL,
    biography TEXT
);

INSERT INTO people(name, picture, height, weight, gender, birthdate, biography)
VALUES ('Pesho', null, 158.25, 245.86, 'm', "2012-03-26", ''),
       ('Gosho', null, 158.25, 245.86, 'm', "2012-03-26", ''),
       ('Maria', null, 158.25, 245.86, 'f', "2012-03-26", ''),
       ('Stamat', null, 158.25, 245.86, 'm', "2012-03-26", ''),
       ('Kiro', null, 158.25, 245.86, 'm', "2012-03-26", '');



#8. Create Table Users
#DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT UNIQUE,
    username VARCHAR(30) NOT NULL,
    password NVARCHAR(26) NOT NULL,
    profile_picture VARBINARY(8000),
    last_login_time TIMESTAMP,
    is_deleted BOOL
);

ALTER TABLE users
ADD CONSTRAINT pk_id
PRIMARY KEY (id);
    
INSERT INTO users(username, password, last_login_time, is_deleted)
VALUES ('Pesho', '123456', "2012-03-26" , FALSE),
	   ('Kiro', '12345', "2012-03-26" , FALSE),
	   ('Gosho', '1234', "2012-03-26" , FALSE),
	   ('Stamat', '123',  "2012-03-26" , TRUE),
	   ('Maria', '12', "2012-03-26" , FALSE);
     
#9. Change Primary Key
ALTER TABLE users
DROP PRIMARY KEY,
ADD CONSTRAINT pk_users PRIMARY KEY (id, username);

#10. Set Default Value of a Field
ALTER TABLE users
MODIFY COLUMN last_login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

#11. Set Unique Field
ALTER TABLE users
DROP PRIMARY KEY,
ADD CONSTRAINT pk_id PRIMARY KEY (id),
ADD CONSTRAINT UNIQUE(username);


#12. Movies Database
DROP DATABASE IF EXISTS movies;
CREATE DATABASE movies;

USE movies;

CREATE TABLE directors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    director_name VARCHAR(30) not null,
    notes BLOB
);
insert into directors(id,director_name)
values(1,'dasdasd'),(2,'dasdasd'),(3,'dasdasd'),(4,'dasdasd'),(5,'dasdasd');

CREATE TABLE genres (
    id INT AUTO_INCREMENT PRIMARY KEY,
    genre_name VARCHAR(30) not null not null,
    notes BLOB
);
insert into genres(id,genre_name)
values(2,'dasdad'),(1,'dasdad'),(3,'dasdad'),(4,'dasdad'),(5,'dasdad');


CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(30) not null,
    notes BLOB
);
insert into categories(id,category_name)
values (1,'wi-fi')
,(2,'wi-fi')
,(3,'wi-fi')
,(4,'wi-fi')
,(5,'wi-fi');

CREATE TABLE movies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(30) not null,
    director_id INT,
    copyright_year DATETIME not null,
    length INT not null,
    genre_id INT not null,
    category_id INT not null,
    rating INT,
    notes BLOB
);
 insert into movies(id,title,copyright_year,`length`,genre_id,category_id)
 values(11,'dasdasda','2016-12-12',23,1,2),
(10,'dasdasda','2016-12-12',23,1,2),
(13,'dasdasda','2016-12-12',23,1,2),
(14,'dasdasda','2016-12-12',23,1,2),
(15,'dasdasda','2016-12-12',23,1,2);

#13. Car Rental Database

DROP DATABASE IF EXISTS car_rental;
CREATE DATABASE car_rental;
USE car_rental;

CREATE TABLE `categories`(
   id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
   category varchar(50) not null,
   daily_rate decimal(5,2),
   weekly_rate decimal(5,2),
   monthly_rate decimal(5,2),
   weekend_rate decimal(5,2)
);
insert into categories(category)
values('dasdads'),('dasdads'),('dasdads'),('dasdads'),('dasdads');

create table `cars`(
   id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
   plate_number int not null,
   make varchar(10) not null,
   car_year datetime,
   category_id int,
   doors INT,
   picture blob,
   car_condition varchar(20),
   available bit
);
insert into `cars`(plate_number,make) values(4,'dasd'),(4,'dasd'),(4,'dasd'),(4,'dasd'),(4,'dasd');

create table `employees`(
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    first_name varchar(50) not null,
    last_name varchar(50),
    title varchar(50),
    notes TEXT
);
insert into `employees`(first_name) values('dasdads'),('dasdads'),('dasdads'),('dasdads'),('dasdads');

create table`customers`(
  id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  driver_licence_number varchar(20),
  full_name varchar(50),
  address varchar(50),
  city varchar(50) not null,
  zip_code varchar(50),
  notes TEXT
);
insert into `customers`(city) values('dasdads'),('dasdads'),('dasdads'),('dasdads'),('dasdads');

create table`rental_orders`(
   id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
   employee_id int,
   customer_id int,
   car_id int,
   car_condition varchar(50), 
   tank_level decimal (20,2),
   kilometrage_start int,
   kilometrage_end int,
   total_kilometrage int,
   start_date datetime,
   end_date datetime,
   total_days int,
   rate_applied varchar(50),
   tax_rate int,
   order_status VARCHAR(30),
   notes TEXT
);
insert into `rental_orders`(employee_id,customer_id,car_id) values(1,2,1),(2,2,1),(3,2,1),(4,2,1),(5,2,1);

#14. Hotel Database

DROP DATABASE IF EXISTS hotel;
CREATE DATABASE hotel;
USE hotel;

create table employees(
   id INT,
  first_name varchar(50) not null,
  last_name varchar(50),
  title varchar(50),
  notes blob
  ,PRIMARY KEY (id)
);
insert into employees(id,first_name)
values(1,'dasd'),(2,'dasd'),(3,'dasd');

create table customers (
   account_number int not null,
   first_name varchar(50) not null, 
	last_name varchar(50),
	phone_number varchar(10),
	emergency_name varchar(50),
	emergency_number varchar(10),
	notes blob,
	primary key(account_number)
);
insert into customers(account_number,first_name)
values(1,'dasd'),(2,'dasd'),(3,'dasd');

create table room_status (
   room_status int not null,
   notes blob,
   primary key(room_status)
);
insert into room_status(room_status)
values(1),(2),(3);

create table room_types(
   room_type INT not null,
   notes blob not null,
   primary key(room_type)
);
insert into room_types(room_type,notes)
values(1,'sasas'),(2,'sasas'),(3,'sasasa');

create table bed_types(
  bed_type INT not null,
  notes blob not null,
  primary key(bed_type)
);
insert into bed_types(bed_type,notes)
values(1,'sasas'),(2,'sasas'),(3,'sasasa');

create table rooms(
   room_number int not null, 
   room_type varchar(50),
   bed_type varchar(50),
   rate varchar(50), 
   room_status varchar(50), 
   notes blob not null, 
   primary key(room_number)
);
insert into rooms(room_number,notes)
values(1,'sasas'),(2,'sasas'),(3,'sasasa');

create table payments(
   id INT not null,
   employee_id int,
   payment_date datetime, 
   account_number varchar(10), 
   first_date_occupied datetime, 
   last_date_occupied datetime, 
   total_days INT, 
   amount_charged double(10,2), 
   tax_rate double(10,2), 
   tax_amount double(10,2), 
   payment_total double(10,2), 
   notes blob not null, 
   primary key(id)
);
insert into payments(id,notes)
values(1,'sasas'),(2,'sasas'),(3,'sasasa');

create table occupancies(
  id int, 
  employee_id int ,
  date_occupied datetime,
  account_number varchar(10),
  room_number int,
  rate_applied varchar(10), 
  phone_charge varchar(10), 
  notes blob not null, 
  primary key(id)
);
insert into occupancies(id,notes)
values(1,'sasas'),(2,'sasas'),(3,'sasasa');

#15. Create SoftUni Database

DROP DATABASE IF EXISTS soft_unii;
CREATE DATABASE soft_unii;
use soft_unii;
create table towns(
   id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
   name varchar(30)
);
create table addresses(
   id  INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
   address_text  varchar(50),
   town_id INT,
   CONSTRAINT fk_addresses_towns FOREIGN KEY (town_id)
   REFERENCES towns(id) 
);
create table `departments`(
   id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
   name varchar(30)
);

create table employees(
   id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
   first_name varchar(10),
   middle_name varchar(10),
   last_name varchar(10),
   job_title varchar(15),
   department_id INT,
   hire_date datetime,
   salary double (10,2),
   address_id INT,
   CONSTRAINT FK_address_id FOREIGN KEY (address_id)
   REFERENCES addresses(id),
   CONSTRAINT FK_department_id FOREIGN KEY (department_id)
   REFERENCES  departments (id)  
);

#17. Basic Insert

INSERT INTO towns(name)
VALUES('Sofia'),('Plovdiv'),('Varna'),('Burgas');

INSERT INTO departments(name)
VALUES('Engineering'),('Sales'),('Marketing'),('Software Development'),('Quality Assurance');

INSERT INTO employees(first_name,middle_name, last_name, job_title, department_id, hire_date, salary)
VALUES('Ivan', 'Ivanov', 'Ivanov', '.NET Developer',4,'2013-02-01', 3500 ),
	 ('Petar','Petrov','Petrov','Senior Engineer',1,'2004-03-02','4000.00'),
	 ('Maria','Petrova','Ivanova','Intern',5,'2016-08-28','525.25'),
	 ('Georgi','Terziev','Ivanov','CEO',2,'2007-12-09','3000.00'),
	 ('Peter','Pan','Pan','Intern',3,'2016-08-28','599.88');
     
#18. Basic Select All Fields

use soft_unii;

SELECT * FROM towns;
SELECT * FROM departments;
SELECT * FROM employees;

#19. Basic Select All Fields and Order Them

SELECT*FROM towns AS t ORDER BY t.name ;
#SELECT*FROM towns ORDER BY name ;
#SELECT*FROM towns ORDER BY name ASC;
#SELECT*FROM towns ORDER BY name DESC;

SELECT*FROM departments AS d ORDER BY d.name ;
SELECT*FROM employees ORDER BY salary DESC;

#20. Basic Select Some Fields

SELECT name FROM towns AS t ORDER BY t.name;
SELECT name FROM departments AS d ORDER BY d.name;
SELECT first_name, last_name, job_title, salary FROM employees ORDER BY salary DESC;

#21. Increase Employees Salary

UPDATE employees
SET salary= salary*1.1;
SELECT salary FROM employees;

#22. Decrease Tax Rate
USE hotel;

UPDATE payments
SET tax_rate= 0.97*tax_rate;
SELECT tax_rate FROM payments;

#23. Delete All Records
USE hotel;

TRUNCATE TABLE occupancies;
#DELETE FROM occupancies;
SELECT * FROM occupancies;



