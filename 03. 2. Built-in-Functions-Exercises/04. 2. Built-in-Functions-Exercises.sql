USE soft_uni;

#Problem 1.	Find Names of All Employees by First Name
SELECT `first_name`, `last_name` FROM `employees`
WHERE LOWER(`first_name`) LIKE 'sa%';

#Problem 2. Find Names of All employees by Last Name 
SELECT `first_name`, `last_name` FROM `employees`
WHERE LOWER(`last_name`) LIKE '%ei%';

#Problem 3.	Find First Names of All Employees
SELECT `first_name` FROM `employees`
WHERE (`department_id` = 3 OR `department_id` = 10) AND
DATE_FORMAT(`hire_date`, '%Y') BETWEEN 1995 AND 2005;

#Problem 4.	Find All Employees Except Engineers
SELECT `first_name`, `last_name` FROM `employees`
WHERE `job_title` NOT LIKE '%engineer%';

#Problem 5.	Find Towns with Name Length
SELECT `name` FROM `towns`
WHERE char_length(`name`) = 5 OR char_length(`name`) = 6
ORDER BY `name`;

#Problem 6. Find Towns Starting With
SELECT `town_id`, `name` FROM `towns`
WHERE  LOWER(`name`) LIKE 'm%' OR
 LOWER(`name`) LIKE 'k%' OR
 LOWER(`name`) LIKE 'b%' OR
 LOWER(`name`) LIKE 'e%'
ORDER BY `name`;

#Problem 7. Find Towns Not Starting With
SELECT `town_id`, `name` FROM `towns`
WHERE  LEFT(LOWER(`name`),1) !=  'b' AND
	   LEFT(LOWER(`name`),1) !=  'r' AND
	   LEFT(LOWER(`name`),1) !=  'd'
ORDER BY `name`;

SELECT `town_id`, `name` FROM `towns`
WHERE  LOWER(`name`) NOT LIKE 'b%'  AND
	   LOWER(`name`) NOT LIKE 'r%'  AND
	   LOWER(`name`) NOT LIKE 'd%' 
ORDER BY `name`;

#Problem 8. Create View Employees Hired After 2000 Year
DROP VIEW IF EXISTS `v_employees_hired_after_2000`;

CREATE VIEW `v_employees_hired_after_2000` AS
SELECT `first_name`, `last_name`FROM `employees`
WHERE EXTRACT(year FROM `hire_date`) > 2000
ORDER BY EXTRACT(year FROM `hire_date`);

SELECT * FROM `v_employees_hired_after_2000`;

CREATE VIEW `v_employees_hired_after_2000` AS
SELECT `first_name`, `last_name` FROM `employees`
WHERE year(`hire_date`) > 2000
ORDER BY year(`hire_date`);

SELECT * FROM `v_employees_hired_after_2000`;

#Problem 9.	Length of Last Name
SELECT `first_name`, `last_name` FROM `employees`
WHERE CHAR_LENGTH(`last_name`) = 5;

############################
USE geography;

#Problem 10. Countries Holding ‘A’ 3 or More Times
SELECT `country_name`, `iso_code` FROM `countries`
WHERE LOWER(`country_name`) LIKE '%a%a%a%'
ORDER BY `iso_code`;

#Problem 11. Mix of Peak and River Names
SELECT p.peak_name, r.river_name, 
	LOWER(CONCAT(p.peak_name,SUBSTRING(r.river_name, 2))) AS 'mix'  
		FROM `peaks` as p, `rivers` as r
WHERE LOWER(RIGHT(p.peak_name,1)) = LOWER(LEFT(r.river_name,1))
ORDER BY mix;


############################
USE diablo;

#Problem 12. Games from 2011 and 2012 year
SELECT `name`, DATE_FORMAT(`start`, '%Y-%m-%d') FROM `games`
WHERE EXTRACT(year FROM `start`) = 2011 OR EXTRACT(year FROM `start`) = 2012
ORDER BY `start`, `name`
LIMIT 50;

#Problem 13. User Email Providers
SELECT `user_name`,
	SUBSTRING(`email`,LOCATE('@',`email`)+1) AS `Email Provider`
    FROM users
ORDER BY `Email Provider`, `user_name`;

#Problem 14. Get Users with IPAdress Like Pattern
SELECT `user_name`, `ip_address` FROM `users`
WHERE `ip_address` LIKE '___.1%.%.___'
ORDER BY `user_name`;

#Problem 15. Show All Games with Duration and Part of the Day
SELECT `name` AS `game` , 
	CASE WHEN (EXTRACT(HOUR FROM `start`) >= 0 AND EXTRACT(HOUR FROM `start`) < 12) THEN 'Morning' 
	 WHEN (EXTRACT(HOUR FROM `start`) >= 12 AND EXTRACT(HOUR FROM `start`) < 18) THEN 'Afternoon' 
	 WHEN (EXTRACT(HOUR FROM `start`) >= 18 AND EXTRACT(HOUR FROM `start`) < 24) THEN 'Evening' 
    END AS 'Part of the Day',
    CASE WHEN `duration` <= 3 THEN 'Extra Short' 
     WHEN `duration` > 3 AND `duration` <= 6 THEN 'Short' 
     WHEN `duration` > 6 AND `duration` <= 10 THEN 'Long' 
     ELSE 'Extra Long' 
    END AS 'Duration'
    FROM `games`
    ORDER BY `name`;
    
    
############################
USE `orders`;

#Problem 16. Orders Table
SELECT `product_name`, `order_date`,  
	DATE_ADD(`order_date`, INTERVAL 3 DAY) AS `pay_due`,
	DATE_ADD(`order_date`, INTERVAL 1 MONTH) AS `deliver_due`
FROM `orders`;

#Problem 17. People Table
SELECT `product_name` , 
	TIMESTAMPDIFF(YEAR, `order_date`, NOW()) AS `age_in_years`,
	TIMESTAMPDIFF(MONTH, `order_date`, NOW()) AS `age_in_months`,
	TIMESTAMPDIFF(DAY, `order_date`, NOW()) AS `age_in_days`,
	TIMESTAMPDIFF(MINUTE, `order_date`, NOW()) AS `age_in_minutes`
FROM `orders`;


