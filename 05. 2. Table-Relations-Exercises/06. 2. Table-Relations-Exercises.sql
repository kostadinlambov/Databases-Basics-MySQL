DROP DATABASE IF EXISTS table_relations_exercise;
CREATE DATABASE table_relations_exercise;
USE table_relations_exercise;

#Problem 1.	One-To-One Relationship
DROP DATABASE IF EXISTS one_to_one;
CREATE DATABASE one_to_one;
USE one_to_one;

CREATE TABLE passports(
passport_id INT PRIMARY KEY,
passport_number CHAR(8)
);

CREATE TABLE persons(
person_id INT AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(50),
salary DECIMAL(10, 2),
passport_id INT UNIQUE NOT NULL
#CONSTRAINT fk_persons_passports FOREIGN KEY(passport_id)
#REFERENCES passports(passport_id)
);

ALTER TABLE persons
ADD CONSTRAINT fk_persons_passports FOREIGN KEY(passport_id)
REFERENCES passports(passport_id);

INSERT INTO passports 
VALUES(101,'N34FG21B'),(102,'K65LO4R7'),(103,'ZE657QP2');
INSERT INTO persons 
VALUES(1,'Roberto',43300,102),(2,'Tom',56100,103),(3,'Yana',60200,101);

#Problem 2.	One-To-Many Relationship
CREATE TABLE manufacturers(
manufacturer_id INT NOT NULL PRIMARY KEY ,
name VARCHAR(5),
established_on DATE
);

INSERT INTO manufacturers 
VALUES (1,'BMW','1916-03-01'),
	   (2,'Tesla','2003-01-01'),
	   (3,'Lada','1966-05-01');

CREATE TABLE models(
model_id INT NOT NULL PRIMARY KEY ,
name VARCHAR(20),
manufacturer_id INT,
CONSTRAINT fk_models_manufactures FOREIGN KEY(manufacturer_id)
REFERENCES manufacturers(manufacturer_id)
);

INSERT INTO models 
VALUES (101,'X1', 1),(102,'i6', 1),(103,'Model S', 2),
	   (104,'Model X', 2),(105,'Model 3', 2),(106,'Nova', 3);

#Problem 3.	Many-To-Many Relationship
CREATE TABLE students (
    student_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(10)
);

INSERT INTO students(student_id, name) 
VALUES (1,'Mila'),(2,'Toni'),(3,'Ron');


CREATE TABLE exams (
    exam_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(10)
);

INSERT INTO exams(exam_id, name) 
VALUES (101,'Spring MVC'),(102,'Neo4j'),(103,'Oracle 11g');

CREATE TABLE students_exams (
    student_id INT,
    exam_id INT,
    CONSTRAINT pk_students_exams PRIMARY KEY (student_id , exam_id),
    CONSTRAINT fk_students_exams_students FOREIGN KEY (student_id)
        REFERENCES students (student_id),
    CONSTRAINT fk_students_exams_exams FOREIGN KEY (exam_id)
        REFERENCES exams (exam_id)
);

INSERT INTO students_exams
VALUES (1, 101),(1, 102),(2,101), (3, 103),(2, 102),(2,103);


# Problem 4. Self-Referencing
DROP TABLE IF EXISTS teachers;
CREATE TABLE teachers (
    teacher_id INT NOT NULL PRIMARY KEY,
    name VARCHAR(10),
    manager_id INT,
    CONSTRAINT fk_teachers_teachers FOREIGN KEY(manager_id)
    REFERENCES teachers(teacher_id)
);

#INSERT INTO teachers (teacher_id, name) VALUE (101, 'John');
INSERT INTO teachers (teacher_id, name, manager_id)
VALUE (101, 'John', NULL),(105, 'Mark', 101),(106, 'Greta', 101),
(102, 'Maya', 106),(103, 'Silvia', 106),(104, 'Ted', 105);


#Problem 5.	Online Store Database
DROP DATABASE IF EXISTS online_store;
CREATE DATABASE online_store;
USE online_store;


CREATE TABLE cities(
city_id INT(11) NOT NULL PRIMARY KEY,
name VARCHAR(50)
);

CREATE TABLE customers(
customer_id INT(11) NOT NULL PRIMARY KEY,
name VARCHAR(50),
birthday DATE,
city_id INT(11),
CONSTRAINT fk_customers_cities FOREIGN KEY(city_id)
REFERENCES cities(city_id)
);


CREATE TABLE item_types(
item_type_id INT(11) NOT NULL PRIMARY KEY,
name VARCHAR(50)
);

CREATE TABLE items(
item_id INT(11) NOT NULL PRIMARY KEY,
name VARCHAR(50),
item_type_id INT(11),
CONSTRAINT fk_items_item_type FOREIGN KEY(item_type_id)
REFERENCES item_types(item_type_id)
);

CREATE TABLE orders(
order_id INT(11) NOT NULL PRIMARY KEY,
customer_id INT(11),
CONSTRAINT fk_items_customers FOREIGN KEY(customer_id)
REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    item_id INT(11),
    order_id INT(11),
    CONSTRAINT pk_items_orders PRIMARY KEY (item_id , order_id),
    CONSTRAINT fk_order_items_orders FOREIGN KEY (order_id)
        REFERENCES orders (order_id),
    CONSTRAINT fk_order_items_items FOREIGN KEY (item_id)
        REFERENCES items (item_id)
);


#Problem 6. University Database
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


#Problem 9.	Peaks in Rila
USE geography;

SELECT 
    m.mountain_range, p.peak_name, p.elevation
FROM
    peaks AS p
        JOIN
    mountains AS m ON m.id = p.mountain_id
WHERE
    m.mountain_range = 'Rila'
ORDER BY p.elevation DESC;
