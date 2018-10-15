USE soft_uni;

#Problem 1:	Count Employees by Town
DELIMITER $$
CREATE FUNCTION  ufn_count_employees_by_town(town_name VARCHAR(45))
RETURNS INT
BEGIN
DECLARE e_count INT;
SET e_count := (SELECT 
    COUNT(*)
FROM
    employees AS e
    JOIN addresses AS a
    ON e.address_id = a.address_id
    JOIN towns AS t
    ON a.town_id = t.town_id
    WHERE t.name = town_name);
RETURN e_count;

END $$

DELIMITER ;

SELECT ufn_count_employees_by_town('Sofia') AS `count`;
 
#Problem 2: Employees Promotion
DELIMITER $$
CREATE PROCEDURE usp_raise_salaries(department_name VARCHAR(45))
BEGIN 
	UPDATE employees AS e
	JOIN departments AS d
	ON e.department_id = d.department_id
	SET e.salary = e.salary * 1.05
	WHERE d.name = department_name;
END $$ 

DELIMITER ;

CALL  usp_raise_salaries('Engineering');

SELECT 
    e.employee_id, e.first_name, e.salary, d.name
FROM
    employees AS e
        JOIN
    departments AS d 
    ON e.department_id = d.department_id;

# Problem 3: Employees Promotion By ID
DELIMITER $$
CREATE PROCEDURE usp_raise_salary_by_id(id INT)
BEGIN
UPDATE employees AS e
SET e.salary = e.salary * 1.05
WHERE e.employee_id = id;
END $$

DELIMITER ;

CALL usp_raise_salary_by_id(1);

SELECT e.employee_id, e.salary FROM employees AS e
WHERE e.employee_id = 1;

#Problem 4. Triggered
CREATE TABLE deleted_employees(
employee_id INT(11) PRIMARY KEY AUTO_INCREMENT, 
first_name VARCHAR(20),
last_name VARCHAR(20),
middle_name VARCHAR(20),
job_title VARCHAR(50),
department_id INT(3),
salary DECIMAL(19, 2)
);

DELIMITER $$
CREATE TRIGGER tr_delete_records
AFTER DELETE
ON employees
FOR EACH ROW
BEGIN
INSERT INTO deleted_employees (first_name, last_name, middle_name, job_title, department_id, salary)
VALUES(OLD.first_name, OLD.last_name, OLD.middle_name, OLD.job_title, OLD.department_id, OLD.salary);
END $$

DELIMITER ;

SELECT * FROM deleted_employees AS d;

DELETE FROM employees
WHERE employee_id IN (1, 2 , 3);



 
 
 
