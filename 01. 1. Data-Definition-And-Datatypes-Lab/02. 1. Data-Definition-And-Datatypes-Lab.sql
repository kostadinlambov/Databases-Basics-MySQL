#1. Create New Database
DROP DATABASE IF EXISTS gamebar;
CREATE DATABASE gamebar;

#2. Create Tables
USE gamebar;

DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL
);
    

DROP TABLE IF EXISTS categories;
CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);

DROP TABLE IF EXISTS products;
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    category_id INT NOT NULL
);

SELECT * FROM employees;

#3. Insert Data in Tables
INSERT INTO employees(first_name, last_name)
VALUES ('Test', 'Test'), ('Test2', 'Test2'), ('Test3', 'Test3');  

#4. Altering Tables
ALTER TABLE employees
ADD COLUMN middle_name VARCHAR(50) NOT NULL;

#5. Adding Constraints
ALTER TABLE products
ADD CONSTRAINT fk_category_id FOREIGN KEY(category_id) REFERENCES categories (id);

#6. Modifying Columns
ALTER TABLE employees
MODIFY COLUMN middle_name VARCHAR(100);

#7. Drop Database
#DROP DATABASE gamebar;