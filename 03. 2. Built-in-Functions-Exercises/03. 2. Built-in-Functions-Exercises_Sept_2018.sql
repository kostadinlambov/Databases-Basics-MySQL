USE soft_uni;

#1.	Find Names of All Employees by First Name
SELECT e.first_name, e.last_name FROM employees AS e
WHERE e.first_name LIKE 'Sa%'
ORDER BY e.employee_id;

#2.	Find Names of All employees by Last Name
SELECT e.first_name, e.last_name FROM employees AS e
WHERE e.last_name LIKE '%ei%'
ORDER BY e.employee_id;

#3.	Find First Names of All Employees
SELECT e.first_name FROM employees AS e
WHERE e.department_id IN (3, 10) AND YEAR(hire_date) BETWEEN 1995 AND 2005
ORDER BY e.employee_id;

#4.	Find All Employees Except Engineers
SELECT e.first_name, e.last_name FROM employees AS e
WHERE e.job_title NOT LIKE '%engineer%'
ORDER BY e.employee_id;

#5.	Find Towns with Name Length
SELECT t.name FROM towns AS t
WHERE CHAR_LENGTH(t.name) = 5 OR CHAR_LENGTH(t.name)=6
ORDER BY t.name ASC;

#6 (First Version). Find Towns Starting With
SELECT * FROM towns AS t
WHERE t.name REGEXP '^[M,K,B,E]'
ORDER BY t.name;

#6 (Second Version). Find Towns Starting With
SELECT `town_id`, `name` FROM `towns`
WHERE  LOWER(`name`) LIKE 'm%' OR
 LOWER(`name`) LIKE 'k%' OR
 LOWER(`name`) LIKE 'b%' OR
 LOWER(`name`) LIKE 'e%'
ORDER BY `name`;

#7 (First Version). Find Towns Not Starting With
SELECT * FROM towns AS t
WHERE t.name REGEXP '^[^R,^B,^D]'
ORDER BY t.name;

#7 (Second Version). Find Towns Not Starting With
SELECT `town_id`, `name` FROM `towns`
WHERE  LEFT(LOWER(`name`),1) !=  'b' AND
	   LEFT(LOWER(`name`),1) !=  'r' AND
	   LEFT(LOWER(`name`),1) !=  'd'
ORDER BY `name`;

#8.	Create View Employees Hired After 2000 Year
DROP VIEW IF EXISTS v_employees_hired_after_2000;

CREATE VIEW v_employees_hired_after_2000 AS
	SELECT e.first_name, e.last_name FROM employees AS e
    WHERE YEAR(e.hire_date) > 2000;
    
SELECT * FROM v_employees_hired_after_2000;

#9.	Length of Last Name
SELECT e.first_name, e.last_name FROM employees AS e
WHERE CHAR_LENGTH(e.last_name) = 5; 



#################################
USE geography;

#10. Countries Holding ‘A’ 3 or More Times
SELECT c.country_name, c.iso_code FROM countries AS c
WHERE c.country_name LIKE '%a%a%a%'
ORDER BY c.iso_code;

#11. Mix of Peak and River Names
SELECT 
	p.peak_name, 
	r.river_name, 
	LOWER(
		CONCAT(
			SUBSTRING(
				p.peak_name, 1, 
				CHAR_LENGTH(p.peak_name)-1), 
				LOWER(r.river_name))) 
				AS 'mix' 
FROM peaks AS p, rivers AS r
WHERE RIGHT(p.peak_name, 1) = LEFT(r.river_name, 1)
ORDER BY mix;

#################################
USE diablo;

#12. Games from 2011 and 2012 year
SELECT g.name, DATE_FORMAT(g.start, '%Y-%m-%d') FROM games AS g
WHERE YEAR(g.start) IN (2011, 2012)
ORDER BY g.start
LIMIT 50;

#13. User Email Providers
SELECT 
	u.user_name, 
    SUBSTRING(u.email, LOCATE('@', u.email) + 1) AS `Email Provider`
    FROM users AS u
ORDER BY `Email Provider` ASC, u.user_name ASC;

#14. Get Users with IP Address Like Pattern
SELECT u.user_name, u.ip_address FROM users AS u
WHERE u.ip_address LIKE '___.1%.%.___'
ORDER BY u.user_name;

#15. Show All Games with Duration and Part of the Day
SELECT 
	g.name AS `game`,
    CASE 
		WHEN HOUR(g.start) BETWEEN 0 AND 11 THEN 'Morning'
        WHEN HOUR(g.start) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN HOUR(g.start) BETWEEN 18 AND 24 THEN 'Evening'
	END AS `Part of the Day`,
	CASE 
		WHEN g.duration <= 3 THEN 'Extra Short'
        WHEN g.duration BETWEEN 4 AND 6 THEN 'Short'
        WHEN g.duration BETWEEN 7 AND 10 THEN 'Long'
        ELSE 'Extra Long'
	END AS `Duration`
FROM games AS g;

##############################
USE orders;

#16. Orders Table
SELECT 
	o.product_name, 
    o.order_date, 
    DATE_ADD(o.order_date, INTERVAL 3 DAY) AS `pay_due`, 
    DATE_ADD(o.order_date, INTERVAL 1 MONTH) AS `deliver_due` 
FROM orders AS o;




