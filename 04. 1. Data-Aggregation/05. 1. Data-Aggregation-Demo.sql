USE soft_uni;

SELECT e.`department_id` 
  FROM `employees` AS e
GROUP BY e.`department_id`;

SELECT DISTINCT e.`department_id`
  FROM `employees` AS e;
  
  
  
SELECT  e.`department_id`, SUM(e.`salary`) AS 'TotalSalary'
  FROM `employees` AS e
 GROUP BY e.`department_id`
 ORDER BY e.`department_id` DESC;

SELECT e.`first_name`, e.`last_name` FROM employees AS e
GROUP BY e.first_name;


SELECT e.`department_id`, 
 MIN(e.`salary`) AS 'MinSalary'
FROM `employees` AS e
GROUP BY e.`department_id`;

SET sql_mode='ONLY_FULL_GROUP_BY';

SELECT e.`first_name`, e.`last_name`, 
 MIN(e.`salary`) AS 'MinSalary'
FROM `employees` AS e
GROUP BY e.`first_name`, e.`last_name`
ORDER BY `MinSalary`;

####################################
#Aggregate Functions

SELECT e.department_id, count(e.salary) AS 'SalaryCount' 
FROM employees AS e
GROUP BY e.department_id
ORDER BY `SalaryCount`;

SELECT e.department_id FROM employees as e
WHERE e.salary IS NOT NULL;

SELECT * FROM employees as e
WHERE e.department_id=2;

SELECT COUNT(*) FROM employees as e;

#Sum

SELECT e.`department_id`, SUM(e.`salary`) AS 'TotalSalary'
FROM `employees` AS e
GROUP BY e.`department_id`;


SELECT e.`department_id`, 
	(SUM(e.`salary`) + department_id) AS 'TotalSalary'
FROM `employees` AS e
GROUP BY e.`department_id`;

######Max

SELECT e.`department_id`,  
MAX(e.`salary`) AS 'MaxSalary'
FROM `employees` AS e
 GROUP BY e.`department_id`;


SELECT SUM(p.department_id) 
FROM
	(SELECT 
		e.`department_id`,  MAX(e.`salary`) AS 'abv'
	FROM 
		`employees` AS e
 GROUP BY e.`department_id`) as p;
 
 ########AVG
 
 SELECT  
  AVG(e.`salary`) AS 'AvgSalary'
	FROM `employees` AS e
	GROUP BY e.`department_id`;
    
SELECT SUM(e.salary) FROM employees as e;

#####################
##HAVING###############

 SELECT  e.`department_id`,
  AVG(e.`salary`) AS 'AvgSalary'
	FROM `employees` AS e
	GROUP BY e.`department_id`
    HAVING AvgSalary > 18000;


 SELECT  e.`department_id`,
  AVG(e.`salary`) AS 'AvgSalary'
	FROM `employees` AS e
    WHERE e.`department_id` > 7
	GROUP BY e.`department_id`
    HAVING AVG(e.`salary`) > 18000
    ORDER BY AVG(e.`salary`);
    