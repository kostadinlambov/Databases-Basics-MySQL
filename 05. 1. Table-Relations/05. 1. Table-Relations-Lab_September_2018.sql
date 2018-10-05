#1. Mountains and Peaks
DROP DATABASE IF EXISTS `camp_test_db`;
CREATE DATABASE `camp_test_db`;
USE `camp_test_db`;

CREATE TABLE mountains(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50) NOT NULL
);

CREATE TABLE peaks(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50) NOT NULL,
mountain_id INT(11),
CONSTRAINT fk_peaks_mountains FOREIGN KEY(mountain_id)
REFERENCES `mountains`(id)
);

###############################
USE camp;
###############################

#2. Trip Organization
SELECT 
    v.driver_id,
    v.vehicle_type,
    CONCAT(c.first_name, ' ', c.last_name) AS `driver_name`
FROM
    vehicles AS v
        JOIN
    campers AS c ON v.driver_id = c.id;

#3. SoftUni Hiking
SELECT 
    r.starting_point AS `route_starting_point`,
    r.end_point AS `route_ending_point`,
    r.leader_id,
    CONCAT(c.first_name, ' ', c.last_name) AS `leader_name`
FROM
    routes AS r
        JOIN
    campers AS c ON r.leader_id = c.id;
    
#4. Delete Mountains
###############################
USE `camp_test_db`;
###############################

DROP TABLES IF EXISTS mountains, peaks;

#ALTER TABLE `peaks`
#DROP FOREIGN KEY `fk_peaks_mountains`;

#ALTER TABLE `peaks`
#ADD CONSTRAINT `fk_peaks_mountains`
#FOREIGN KEY(`mountain_id`)
#REFERENCES mountains(`id`)
#ON DELETE CASCADE;

CREATE TABLE `mountains`(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50) NOT NULL
);

CREATE TABLE `peaks`(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50) NOT NULL,
mountain_id INT(11),
CONSTRAINT `fk_peaks_mountains`
FOREIGN KEY (`mountain_id`) REFERENCES mountains(`id`)
ON DELETE CASCADE
);

#5. Project Management DB
DROP DATABASE IF EXISTS `project_management_db`;
CREATE DATABASE `project_management_db`;

CREATE TABLE `employees`(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(30),
last_name VARCHAR(30),
project_id INT(11) UNIQUE
);

CREATE TABLE `clients`(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
client_name VARCHAR(100),
project_id INT(11)
);

CREATE TABLE `projects`(
id 	INT(11) PRIMARY KEY AUTO_INCREMENT,
client_id INT(11),
project_lead_id INT(11)
);

ALTER TABLE `clients`
ADD CONSTRAINT `fk_amployees_projects` FOREIGN KEY(`project_id`)
REFERENCES `projects` (id);

ALTER TABLE `employees`
ADD CONSTRAINT `fk_clients_projects` FOREIGN KEY(`project_id`)
REFERENCES `projects` (id);

ALTER TABLE `projects`
ADD CONSTRAINT `fk_projects_employees` FOREIGN KEY(`project_lead_id`)
REFERENCES employees(id),
ADD CONSTRAINT `fk_projects_clients` FOREIGN KEY(`client_id`)
REFERENCES clients(id);
