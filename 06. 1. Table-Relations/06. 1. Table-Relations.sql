
USE camp;

SELECT * FROM camp;

#Problem 1: Mountains and Peaks
DROP TABLE IF EXISTS mountains;

CREATE TABLE mountains(
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(50)
);

DROP TABLE IF EXISTS peaks;

CREATE TABLE peaks(
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(45),
mountain_id INT,
CONSTRAINT fk_peaks_mountains FOREIGN KEY(id)
REFERENCES mountains(id)
);

SELECT 
     p.name, m.name
FROM
    peaks AS p
        JOIN
    mountains AS m ON m.id = p.mountain_id
ORDER BY p.id DESC;

#Problem 2: Books and Authors
#DROP TABLE IF EXISTS authors;
CREATE TABLE authors(
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(50)
);

#DROP TABLE IF EXISTS books;
CREATE TABLE books(
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(45),
author_id INT,
CONSTRAINT fk_books_authors FOREIGN KEY(id)
REFERENCES authors(id) ON DELETE CASCADE
);

#Problem 3: Trip Organization
USE camp;

SELECT 
   v.driver_id, v.vehicle_type, CONCAT(c.first_name, ' ', c.last_name)
FROM
    campers AS c
    JOIN
    vehicles AS v 
    ON c.id = v.driver_id;

#4. SoftUni Hiking
SELECT 
    r.starting_point AS `route_starting_point`,
    r.end_point AS `route_ending_point`,
    r.leader_id,
    CONCAT(c.first_name, ' ', c.last_name) AS `leader_name`
FROM
    routes AS r
    JOIN
    campers AS c
    WHERE r.leader_id = c.id;


#5 Project Management DB

CREATE TABLE employees(
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(30),
last_name VARCHAR(30),
project_id INT(11),
CONSTRAINT fk_employees_projects FOREIGN KEY(project_id)
REFERENCES projects(id)
);

CREATE TABLE employees(
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
client_id INT(11),
project_lead_id INT(11),
CONSTRAINT fk_projects_employees FOREIGN KEY(project_lead_id)
REFERENCES employees(id),
CONSTRAINT fk_projects_clients FOREIGN KEY(client_id)
REFERENCES clients(id)
);

CREATE TABLE clients(
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
client_name VARCHAR(100),
project_id INT(11),
CONSTRAINT fk_clients_projects FOREIGN KEY(project_id)
REFERENCES projects(id)
);


