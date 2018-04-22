USE hospital;
SELECT * FROM `employees`;

#Problem 1: Select Employee Information
SELECT `id`, `first_name`, `last_name`, `job_title` FROM `employees`
ORDER BY `id` ASC;


#Problem 2: Select Employees with Filter
SELECT `id`, concat_ws(' ',`first_name`, `last_name`) as 'full_name', `job_title`, `salary` FROM `employees`
WHERE  `salary` >= 1000
ORDER BY `id`;

#Problem 3: Update Employees Salary
UPDATE `employees`
SET `salary` = `salary`* 1.1
WHERE `job_title` = 'Therapist';

SELECT `salary` FROM `employees`
ORDER BY `salary` ASC;

#Problem 4: Top Paid Employee
SELECT * FROM `employees`
ORDER BY `salary` DESC
LIMIT 1;

#Problem 5: Select Employees by Multiple Filters
SELECT * FROM `employees`
WHERE `department_id`= 4 AND `salary` >= 1600
ORDER BY `id` ASC;

#Problem 6: Delete from Table
DELETE FROM `employees`
WHERE `department_id`= 2 OR `department_id`= 1;

SELECT * FROM `employees`
ORDER BY `id` ASC;
