DROP DATABASE IF EXISTS `table_relations_exercise_Sept_2018`;
CREATE DATABASE `table_relations_exercise_Sept_2018`;
USE `table_relations_exercise_Sept_2018`;

#1.	One-To-One Relationship
CREATE TABLE `passports`(
passport_id INT(11) PRIMARY KEY,
passport_number CHAR(8) NOT NULL
);

CREATE TABLE `persons`(
person_id INT(11) PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
salary DECIMAL(19,2) NOT NULL,
passport_id INT(11) UNIQUE,
CONSTRAINT `fk_persons_passports` FOREIGN KEY(`passport_id`)
REFERENCES `passports`(`passport_id`)
);

INSERT INTO `passports` (passport_id, passport_number)
VALUES(101,'N34FG21B'),(102,'K65LO4R7'),(103,'ZE657QP2');
INSERT INTO `persons` (person_id, first_name, salary, passport_id)
VALUES(1,'Roberto',43300,102),(2,'Tom',56100,103),(3,'Yana',60200,101);

#2.One-To-Many Relationship
DROP TABLE IF EXISTS `manufacturers`;
DROP TABLE IF EXISTS `models`;

CREATE TABLE `manufacturers`(
manufacturer_id INT(11) PRIMARY KEY,
name VARCHAR(50) NOT NULL,
established_on VARCHAR(50)
);

INSERT INTO `manufacturers`(manufacturer_id, name, established_on)
VALUES (1,'BMW','1916-03-01'),
	   (2,'Tesla','2003-01-01'),
	   (3,'Lada','1966-05-01');

CREATE TABLE `models`(
model_id INT(11) PRIMARY KEY,
name VARCHAR(50) NOT NULL,
manufacturer_id INT(11),
CONSTRAINT `fk_models_manufacturers` FOREIGN KEY(`manufacturer_id`)
REFERENCES `manufacturers`(`manufacturer_id`)
);
INSERT INTO `models`(model_id, name, manufacturer_id)
VALUES (101,'X1', 1),(102,'i6', 1),(103,'Model S', 2),
	   (104,'Model X', 2),(105,'Model 3', 2),(106,'Nova', 3);

#3. Many-To-Many Relationship
DROP TABLE IF EXISTS `students`;
DROP TABLE IF EXISTS `models`;

CREATE TABLE `students`(
student_id INT(11) PRIMARY KEY,
name VARCHAR(50) NOT NULL
);

INSERT INTO students(student_id, name) 
VALUES (1,'Mila'),(2,'Toni'),(3,'Ron');

CREATE TABLE `exams`(
exam_id INT(11) PRIMARY KEY,
name VARCHAR(50) NOT NULL
);

INSERT INTO exams(exam_id, name) 
VALUES (101,'Spring MVC'),(102,'Neo4j'),(103,'Oracle 11g');

CREATE TABLE `students_exams`(
student_id INT(11),
exam_id INT(11),
CONSTRAINT `pk_students_exams`
PRIMARY KEY (`student_id`,`exam_id`),
CONSTRAINT `fk_students_exams_students` FOREIGN KEY(`student_id`)
REFERENCES `students`(`student_id`),
CONSTRAINT `fk_students_exams_exams` FOREIGN KEY(`exam_id`)
REFERENCES `exams`(`exam_id`)
);

INSERT INTO students_exams
VALUES (1, 101),(1, 102),(2,101), (3, 103),(2, 102),(2,103);

#4. Self-Referencing
DROP TABLE IF EXISTS `teachers`;

CREATE TABLE `teachers`(
teacher_id INT(11) PRIMARY KEY,
name VARCHAR(50) NOT NULL,
manager_id INT(11),
CONSTRAINT `fk_teachers_teachers` FOREIGN KEY (manager_id)
REFERENCES `teachers`(teacher_id)
);

#INSERT INTO teachers (teacher_id, name) VALUE (101, 'John');
INSERT INTO teachers (teacher_id, name, manager_id)
VALUE (101, 'John', NULL),(105, 'Mark', 101),(106, 'Greta', 101),
(102, 'Maya', 106),(103, 'Silvia', 106),(104, 'Ted', 105);


#5.	Online Store Database
DROP DATABASE IF EXISTS online_store;
CREATE DATABASE online_store;
USE online_store;

create table cities (
  city_id int(11),
  name varchar(50),
  CONSTRAINT pk_cities primary key (city_id)
);

create table customers (
  customer_id INT(11),
  name VARCHAR(50),
  birthday DATE,
  city_id INT(11),
  constraint pk_customers primary key (customer_id),
  constraint fk_customers_cities foreign key (city_id) references cities (city_id) 
);

create table orders(
  order_id int(11),  
  customer_id int(11),
  constraint pk_orders primary key(order_id),
  constraint fk_orders_customers foreign key(customer_id) references customers (customer_id) 
);

create table item_types(
   item_type_id int(11),
   name varchar(50),
   constraint pk_item_types primary key (item_type_id)
);

create table items(
  item_id int(11),
  name varchar(50),
  item_type_id int(11),
  CONSTRAINT pk_items primary key (item_id),
  CONSTRAINT fk_items_item_types FOREIGN KEY (item_type_id) REFERENCES item_types(item_type_id)
);

create table order_items(
  order_id int(11),
  item_id int(11),
  constraint pk_order_items primary key (order_id,item_id),
  constraint fk_order_items_orders foreign key(order_id) references orders(order_id),
  constraint fk_order_items_items foreign key(item_id) references items(item_id)
);

#6. University Database
DROP DATABASE IF EXISTS university;
CREATE DATABASE university;
USE university;

CREATE TABLE subjects (
    subject_id INT(11) NOT NULL PRIMARY KEY,
    subject_name VARCHAR(50)
);


CREATE TABLE majors (
    major_id INT(11) NOT NULL PRIMARY KEY,
    name VARCHAR(50)
);


CREATE TABLE students (
    student_id INT(11) NOT NULL PRIMARY KEY,
    student_number VARCHAR(12),
    student_name VARCHAR(50),
    major_id INT(11),
    CONSTRAINT fk_students_majors FOREIGN KEY (major_id)
        REFERENCES majors (major_id)
);


CREATE TABLE payments (
    payment_id INT(11) NOT NULL PRIMARY KEY,
    payment_date DATE,
    payment_amount DECIMAL(8 , 2 ),
    student_id INT(11),
    CONSTRAINT fk_payments_students FOREIGN KEY (student_id)
        REFERENCES students (student_id)
);

CREATE TABLE agenda (
    student_id INT(11),
    subject_id INT(11),
    CONSTRAINT pk_agenda PRIMARY KEY (student_id , subject_id),
    CONSTRAINT fk_agenda_students FOREIGN KEY (student_id)
        REFERENCES students (student_id),
    CONSTRAINT fk_agenda_subjects FOREIGN KEY (subject_id)
        REFERENCES subjects (subject_id)
);

#9.	Peaks in Rila
#####################
USE geography;
###################
SELECT 
    m.mountain_range, p.peak_name, p.elevation AS `peak_elevation`
FROM
    mountains AS m
    JOIN 
    peaks AS p
    ON m.id = p.mountain_id
    WHERE m.mountain_range = 'Rila'
    ORDER BY p.elevation DESC;









