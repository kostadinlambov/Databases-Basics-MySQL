USE soft_uni;

#Problem 1: Managers
SELECT 
    e.employee_id, CONCAT(e.first_name, ' ', e.last_name), d.department_id, d.name
FROM
    employees AS e
        INNER JOIN
    departments AS d 
    ON e.employee_id = d.manager_id
	ORDER BY e.employee_id
    LIMIT 5;

#Problem 2: Towns Addresses
SELECT 
    t.town_id, t.name AS `town_name`, a.address_text
FROM
    towns AS t
    JOIN addresses AS a
    ON t.town_id = a.town_id
    WHERE t.name IN ('San Francisco', 'Sofia', 'Carnation')
    ORDER BY t.town_id, a.address_id;
    
#Problem 3: Employees Without Managers
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    e.department_id,
    e.salary
FROM
    employees AS e
    WHERE e.manager_id IS NULL;

#Problem 4: Higher Salary
SELECT 
    COUNT(e.salary)
FROM
    employees AS e
WHERE
    e.salary > (SELECT 
            AVG(e.salary) AS `average`
        FROM
            employees AS e);
    