USE soft_uni;

#Problem 2.	Find All Information About Departments
SELECT * FROM `departments`;

#Problem 3.	Find all Department Names
SELECT `name` FROM `departments`;

#Problem 4.	Find salary of Each Employee
SELECT `first_name`, `last_name`, `salary` FROM `employees`;

#Problem 5.	Find Full Name of Each Employee
SELECT `first_name`, `middle_name`, `last_name` FROM `employees`;

#Problem 6.	Find Email Address of Each Employee
SELECT concat(`first_name`, '.', `last_name`,'@softuni.bg') AS 'full_ email_address' FROM `employees`;

#Problem 7.	Find All Different Employee’s Salaries
SELECT DISTINCT `salary` FROM `employees`;

#Problem 8.	Find all Information About Employees
SELECT * FROM `employees`
WHERE `job_title` = 'Sales Representative';

#Problem 9.	Find Names of All Employees by salary in Range
SELECT `first_name`, `last_name`, `job_title` FROM `employees`
WHERE `salary`>= 20000 AND `salary`<= 30000;

#Problem 10. Find Names of All Employees 
SELECT concat_ws(' ', `first_name`, `middle_name`, `last_name`) AS 'full_name' FROM `employees`
WHERE `salary` IN (25000, 14000, 12500, 23600);

#Problem 11. Find All Employees Without Manager
SELECT `first_name`, `last_name` FROM `employees`
WHERE `manager_id` IS NULL;

#Problem 12. Find All Employees with salary More Than 50000
SELECT `first_name`, `last_name`, `salary` FROM `employees`
WHERE `salary` > 50000
ORDER BY `salary` DESC;

#Problem 13. Find 5 Best Paid Employees
SELECT `first_name`, `last_name` FROM `employees`
ORDER BY `salary` DESC
LIMIT 5;

#Problem 14. Find All Employees Except Marketing
SELECT `first_name`, `last_name` FROM `employees`
WHERE `department_id` != 4;

#Problem 15. Sort Employees Table
SELECT * FROM `employees`
ORDER BY `salary` DESC, `first_name` ASC, `last_name` DESC, `middle_name` ASC;

#Problem 16. Create View Employees with Salaries
CREATE VIEW `v_employees_salaries` AS 
SELECT `first_name`, `last_name`, `salary` FROM `employees`;

SELECT * FROM `v_employees_salaries`;

#Problem 17. Create View Employees with Job Titles
CREATE TABLE `custom_table` AS SELECT `first_name`, `middle_name`, `last_name`, `job_title` FROM
    `employees`;

UPDATE `custom_table`
SET `middle_name` = ''
WHERE `middle_name` IS NULL;

DROP VIEW IF EXISTS `v_employees_job_titles`;

CREATE VIEW `v_employees_job_titles` AS
SELECT 
	concat_ws(' ',`first_name`, `middle_name`,`last_name`) AS 'full_name', 
    `job_title`
    FROM 
    `custom_table`;
    
SELECT * FROM `v_employees_job_titles`;  

#Problem 18. Distinct Job Titles
SELECT DISTINCT `job_title` FROM `employees`
ORDER BY `job_title`;

#Problem 19. Find First 10 Started Projects
SELECT * FROM `projects`
ORDER BY `start_date`, `name`
LIMIT 10;

#Problem 20. Last 7 Hired Employees
SELECT `first_name`,`last_name`, `hire_date` FROM `employees`
ORDER BY `hire_date` DESC
LIMIT 7;

#Problem 21. Increase Salaries
UPDATE `employees`
SET `salary` = 1.12 * `salary`
WHERE `department_id`= 1 OR `department_id`= 2 OR `department_id`= 4 OR `department_id`= 11;

SELECT `salary` FROM `employees`;

##################################
USE geography;

#Problem 22. All Mountain Peaks
SELECT `peak_name` FROM `peaks`
ORDER BY `peak_name` ASC;

#Problem 23. Biggest Countries by Population
SELECT `country_name`, `population` FROM `countries`
WHERE `continent_code` = 'EU'
ORDER BY `population` DESC, `country_name`
LIMIT 30;

#Problem 24. Countries and Currency (Euro / Not Euro)
DROP TABLE IF EXISTS `currency_code_table`;

CREATE TABLE `currency_code_table` AS
SELECT `country_name`, `country_code`, `currency_code` AS `currency`
FROM  `countries`;

ALTER TABLE `currency_code_table`
MODIFY COLUMN `currency` CHAR(8);

UPDATE `currency_code_table`
SET `currency` = 'Euro'
WHERE `currency` = 'EUR';

UPDATE `currency_code_table`
SET `currency` = 'Not Euro'
WHERE `currency` != 'Euro' AND `currency` IS NOT NULL;

SELECT `country_name`, `country_code`, `currency` FROM `currency_code_table`
WHERE `currency` IS NOT NULL
ORDER BY `country_name` ASC;

##########################################################
USE diablo;

#Problem 25. All Diablo Characters
SELECT `name` FROM `characters`
ORDER BY `name` ASC;





