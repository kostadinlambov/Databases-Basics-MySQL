USE soft_uni;
SELECT * FROM  employees AS e;

#Problem 1.	Managers
SELECT 
    e.employee_id,
    CONCAT_WS(' ', e.first_name, e.last_name),
    e.department_id,
    d.name AS 'department_name'
FROM
    employees AS e
        INNER JOIN
    departments AS d 
    ON e.manager_id = d.manager_id
ORDER BY e.employee_id
LIMIT 5;


#Problem 2. Towns Adresses
SELECT 
    t.town_id, t.name, a.address_text
FROM
    addresses AS a
    JOIN towns AS t
    ON a.town_id = t.town_id
    #AND t.name IN ('San Francisco', 'Sofia', 'Carnation'))
    WHERE t.name IN ('San Francisco', 'Sofia', 'Carnation')
    ORDER BY t.town_id, a.address_id;


#Problem 3.	Employees Without Managers
SELECT 
    e.employee_id, e.first_name, e.last_name, e.department_id, e.salary
FROM
    employees AS e
    WHERE e.manager_id IS NULL
    ORDER BY e.employee_id;


#Problem 4. Higher Salary
SELECT * FROM employees AS e;

SELECT 
    COUNT(*)
FROM
    employees AS e,
    (SELECT 
        AVG(e.salary) AS average_salary, e.salary AS salary
    FROM
        employees AS e) AS avg1
WHERE
    e.salary > avg1.average_salary;
