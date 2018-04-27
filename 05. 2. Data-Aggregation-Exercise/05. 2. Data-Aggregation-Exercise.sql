USE gringotts;

#Problem 1.	Records’ Count
SELECT COUNT(*) FROM `wizzard_deposits` AS w;

#Problem 2.	Longest Magic Wand
SELECT MAX(w.`magic_wand_size`) AS `longest_magic_wand`
FROM
    `wizzard_deposits` AS w;

#Problem 3.	Longest Magic Wand per Deposit Groups
SELECT 
    w.`deposit_group`, 
    MAX(w.`magic_wand_size`) AS `longest_magic_wand`
FROM
    `wizzard_deposits` AS w
GROUP BY w.`deposit_group`
ORDER BY `longest_magic_wand`;

#Problem 4.	Smallest Deposit Group per Magic Wand Size
SELECT w.`deposit_group`  AS `deposit_group` 
FROM
    `wizzard_deposits` AS w
GROUP BY w.`deposit_group`
ORDER BY AVG(w.`magic_wand_size`)
LIMIT 1;

#Problem 5.	Deposits Sum
SELECT w.`deposit_group`,
		SUM(w.`deposit_amount`) AS `total_sum`
FROM
    `wizzard_deposits` AS w
GROUP BY w.`deposit_group`
ORDER BY `total_sum`;

#Problem 6.	Deposits Sum for Ollivander family
SELECT w.`deposit_group`,
		SUM(w.`deposit_amount`) AS `total_sum`
FROM
    `wizzard_deposits` AS w
WHERE (w.`magic_wand_creator` = 'Ollivander family')
GROUP BY w.`deposit_group`
ORDER BY w.`deposit_group`;

#Problem 7.	Deposits Filter
SELECT w.`deposit_group`,
		SUM(w.`deposit_amount`) AS `total_sum`
FROM
    `wizzard_deposits` AS w
WHERE (w.`magic_wand_creator` = 'Ollivander family')
GROUP BY w.`deposit_group`
HAVING `total_sum` < 150000
ORDER BY `total_sum` DESC;

#Problem 8.	 Deposit charge
SELECT 
    w.`deposit_group`,
    w.`magic_wand_creator`,
    MIN(w.`deposit_charge`) AS `min_deposit_charge`
FROM
    `wizzard_deposits` AS w
GROUP BY w.`magic_wand_creator` , w.`deposit_group`;

#Problem 9.	Age Groups
SELECT 
    CASE
        WHEN w.`age` BETWEEN 0 AND 10 THEN '[0-10]'
        WHEN w.`age` BETWEEN 11 AND 20 THEN '[11-20]'
        WHEN w.`age` BETWEEN 21 AND 30 THEN '[21-30]'
        WHEN w.`age` BETWEEN 31 AND 40 THEN '[31-40]'
        WHEN w.`age` BETWEEN 41 AND 50 THEN '[41-50]'
        WHEN w.`age` BETWEEN 51 AND 60 THEN '[51-60]'
        WHEN w.`age` > 60 THEN '[61+]'
    END AS `age_group`,
    COUNT(*) AS `wizard_count`
FROM
    `wizzard_deposits` AS w
GROUP BY `age_group`
ORDER BY `wizard_count`;

#Problem 10. First Letter
SELECT 
	LEFT(w.`first_name`,1) AS `first_letter`
FROM
    `wizzard_deposits` AS w
WHERE w.`deposit_group` ='Troll Chest' 
GROUP BY `first_letter`
ORDER BY `first_letter`;

#Problem 11. Average Interest 
SELECT 
    w.`deposit_group`, w.`is_deposit_expired`,
    AVG(w.`deposit_interest`) AS `average_interest`
FROM
    `wizzard_deposits` AS w
WHERE w.`deposit_start_date` > '1985-01-01'
GROUP BY w.`deposit_group`,w.`is_deposit_expired`
ORDER BY w.`deposit_group` DESC,  w.`is_deposit_expired`;

#Problem 12. Rich Wizard, Poor Wizard
SELECT * FROM `wizzard_deposits`;

SELECT 
    SUM(w.`host_wizard_deposit` - w.`guest_wizard_deposit`) AS `sum_difference`
FROM
    (SELECT 
    w1.`first_name`AS `host_wizard`, w1.`deposit_amount` AS `host_wizard_deposit`,
    w2.`first_name` AS `guest_wizard`, w2.`deposit_amount` AS `guest_wizard_deposit`
FROM
    `wizzard_deposits` AS w1, `wizzard_deposits` AS w2
WHERE w1.`id` + 1 = w2.`id`) AS w;

############################
#SOLUTION WITH VIEW
##########################

DROP VIEW IF EXISTS `rw_pw`;

CREATE VIEW `rw_pw` AS 
SELECT 
    w1.`first_name`AS `host_wizard`, w1.`deposit_amount` AS `host_wizard_deposit`,
    w2.`first_name` AS `guest_wizard`, w2.`deposit_amount` AS `guest_wizard_deposit`
FROM
    `wizzard_deposits` AS w1, `wizzard_deposits` AS w2
WHERE w1.`id` + 1 = w2.`id`;


SELECT 
    SUM(`host_wizard_deposit` - `guest_wizard_deposit`) AS `sum_difference`
FROM
    `rw_pw`;

#################
USE soft_uni;

#Problem 13. Employees Minimum Salaries
SELECT 
    e.`department_id`, MIN(e.`salary`) AS `minimum_salary`
FROM
    `employees` AS e
WHERE
    e.`hire_date` > '2000-01-01'
GROUP BY e.`department_id`
HAVING e.`department_id` IN (2,5,7)
ORDER BY e.`department_id`;

#Problem 14. Employees Average Salaries
DROP TABLE IF EXISTS `new_table`;

CREATE TABLE `new_table`
AS SELECT * FROM `employees`
WHERE `salary` > 30000;

DELETE FROM `new_table`
WHERE `manager_id` = 42;

UPDATE `new_table`
SET `salary`= (`salary` + 5000)
WHERE `department_id` = 1;

SELECT 
    n.`department_id`, AVG(n.`salary`) AS `avg_salary`
FROM
    `new_table` AS n
GROUP BY  n.`department_id`
ORDER BY  n.`department_id`;

#Problem 15. Employees Maximum Salaries
SELECT 
    e.`department_id`, MAX(e.`salary`) as `max_salary`
FROM
    `employees` AS e
GROUP BY e.`department_id`
HAVING NOT `max_salary` BETWEEN 30000 AND 70000
ORDER BY e.`department_id`;

#Problem 16. Employees Count Salaries
SELECT COUNT(*) FROM `employees` AS e
WHERE `manager_id` IS NULL;

#Problem 17. 3rd Highest Salary
SELECT 
    e.`department_id`, MAX(e.`salary`) AS `third_highest_salary`
FROM
    `employees` AS e,
    (SELECT 
        e.`department_id`, MAX(e.`salary`) AS `second_highest_salary`
    FROM
        `employees` AS e, (SELECT 
        e.`department_id`, MAX(e.`salary`) AS `max_salary`
    FROM
        `employees` AS e
    GROUP BY e.`department_id`) AS `max_salary_by_dep`
    WHERE
        e.`department_id` = `max_salary_by_dep`.`department_id`
            AND e.`salary` < `max_salary_by_dep`.`max_salary`
    GROUP BY e.`department_id`) AS `second_max_salary_by_dep`
 WHERE
        e.`department_id` = `second_max_salary_by_dep`.`department_id`
            AND e.`salary` < `second_max_salary_by_dep`.`second_highest_salary`
		GROUP BY e.`department_id`
        ORDER BY e.`department_id`;

#Problem 18. Salary Challenge
USE soft_uni;

SELECT 
    e1.`first_name`, e1.`last_name`, e1.`department_id`
FROM
    employees AS e1,
    (SELECT 
        e2.`department_id`, AVG(e2.`salary`) AS `avg_salary`
    FROM
        `employees` AS e2
    GROUP BY e2.`department_id`) AS `avg_salary_by_department`
WHERE
    e1.`department_id` = `avg_salary_by_department`.`department_id`
        AND e1.`salary` > `avg_salary_by_department`.`avg_salary`
ORDER BY e1.`department_id`
LIMIT 10;

#Problem 19. Departments Total Salaries
SELECT 
    e.`department_id`, SUM(e.`salary`) as `total_salary`
FROM
    `employees` AS e
GROUP BY e.`department_id`
ORDER BY  e.`department_id`;

DROP DATABASE soft_uni;
