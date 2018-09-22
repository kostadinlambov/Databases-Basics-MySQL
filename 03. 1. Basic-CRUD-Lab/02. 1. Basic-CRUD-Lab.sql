USE hospital;

SELECT * FROM employees;

#Problem 1: Select Employee Information
SELECT e.id, e.first_name, e.last_name, e.job_title 
FROM employees as e
ORDER BY id;

#Problem 2: Select Employees with Filter
SELECT e.id, concat(e.first_name, ' ', e.last_name), e.job_title, e.salary
FROM employees as e
WHERE salary > 1000
ORDER BY id;
 
#Problem 3: Update Employees Salary
UPDATE employees
SET salary = salary * 1.1
WHERE job_title='Therapist';
 
SELECT e.salary  FROM employees AS e
ORDER BY e.salary ASC;
 
#Problem 4: Top Paid Employee
CREATE VIEW v_top_payed_employee AS
SELECT * FROM employees AS e
ORDER BY e.salary DESC
LIMIT 1;

SELECT * FROM v_top_payed_employee;
 
#Problem 5: Select Employees by Multiple Filters
SELECT * FROM employees AS e
WHERE e.department_id = 4 AND e.salary >= 1600
ORDER BY e.id ASC;

#Problem 6: Delete from Table
DELETE FROM employees
WHERE department_id IN (1, 2);

SELECT * FROM employees AS e
ORDER BY e.id ASC;

 