USE soft_uni;

#Problem 1: Employee Address
SELECT 
    e.employee_id, e.job_title, e.address_id, a.address_text
FROM
    employees AS e
    JOIN addresses AS a
    ON e.address_id = a.address_id
    ORDER BY a.address_id
    LIMIT 5;
    
#Problem 2: Addresses with Towns
SELECT 
    e.first_name, e.last_name, t.name AS `town`, a.address_text
FROM
    employees AS e
    JOIN addresses AS a
    ON e.address_id = a.address_id
    JOIN towns AS t
    ON a.town_id = t.town_id
    ORDER BY e.first_name ASC, e.last_name ASC
    LIMIT 5;
   
#Problem 3: Sales Employee
SELECT 
    e.employee_id, e.first_name, e.last_name, d.name AS `department_name`
FROM
    employees AS e
    JOIN departments AS d
    ON e.department_id = d.department_id
    WHERE d.name = 'Sales'
    ORDER BY e.employee_id DESC;
    
#Problem 4:	Employee Departments
SELECT 
    e.employee_id, e.first_name, e.salary, d.name AS `department_name`
FROM
    employees AS e
    JOIN departments AS d
    ON e.department_id = d.department_id
    WHERE e.salary > 15000
    ORDER BY d.department_id DESC
    LIMIT 5;

#Problem 5:	Employees Without Project
SELECT 
    e.employee_id, e.first_name
FROM
    employees AS e
    LEFT JOIN employees_projects AS ep
    ON e.employee_id = ep.employee_id
    WHERE ep.project_id IS NULL
    ORDER BY e.employee_id DESC
    LIMIT 3;

#Problem 6:	Employees Hired After
SELECT 
    e.first_name, e.last_name, e.hire_date, d.name AS `dept_name`
FROM
    employees AS e
    JOIN departments AS d
    ON e.department_id = d.department_id
    WHERE DATE(e.hire_date) > '1999/1/1' AND d.name IN ('Sales', 'Finance')
	ORDER BY e.hire_date ASC;


#Problem 7: Employees with Project
SELECT 
    e.employee_id, e.first_name, p.name AS `project_name`
FROM
    employees AS e
    JOIN employees_projects AS ep
    ON e.employee_id = ep.employee_id
    JOIN projects AS p
    ON ep.project_id = p.project_id
    WHERE DATE(p.start_date) > '2002-08-13' AND p.end_date IS NULL
    ORDER BY e.first_name ASC, `project_name` ASC
    LIMIT 5;
    
#Problem 8:	Employee 24  
SELECT 
    e.employee_id,
    e.first_name,
    IF(EXTRACT(YEAR FROM p.start_date) < 2005,
        p.name,
        NULL) AS `project_name`
FROM
    employees AS e
        JOIN
    employees_projects AS ep ON e.employee_id = ep.employee_id
        JOIN
    projects AS p ON ep.project_id = p.project_id
WHERE
    e.employee_id = 24
    ORDER BY `project_name`;
   
#Problem 9:	Employee Manager
SELECT 
    e.employee_id, e.first_name, e.manager_id, e2.first_name AS `manager_name`
FROM
    employees AS e
    JOIN employees AS e2
    ON e.manager_id = e2.employee_id
    WHERE e.manager_id IN (3, 7)
    ORDER BY e.first_name ASC;
    

#Problem 10: Employee Summary
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS `employee_name`,
    CONCAT(e2.first_name, ' ', e2.last_name) AS `manager_name`,
    d.name AS `department_name`
FROM
    employees AS e
    JOIN employees AS e2
    ON e.manager_id = e2.employee_id
    JOIN departments AS d
    ON e.department_id = d.department_id
    ORDER BY e.employee_id
    LIMIT 5;
    
#Problem 11: Min Average Salary
SELECT 
    MIN(`average`.`average_ssalary`) AS `min_average_salary`
FROM
    employees AS e,
    (SELECT 
        AVG(e2.salary) AS `average_ssalary`
    FROM
        employees AS e2
    GROUP BY e2.department_id) AS `average`;

#######################
USE geography;

#Problem 12: Highest Peaks in Bulgaria
SELECT 
    c.country_code, m.mountain_range, p.peak_name, p.elevation
FROM
    countries AS c
    JOIN mountains_countries AS mc
    ON c.country_code = mc.country_code
    JOIN mountains AS m
    ON mc.mountain_id = m.id
    JOIN peaks AS p
    ON m.id = p.mountain_id
    WHERE c.country_code = 'BG'  AND p.elevation > 2835
    ORDER BY p.elevation DESC;

#Problem 13: Count Mountain Ranges
SELECT 
    c.country_code, COUNT(*) AS `mountain_range`
FROM
    countries AS c
    JOIN mountains_countries AS mc
    ON c.country_code = mc.country_code
    JOIN mountains AS m
    ON mc.mountain_id = m.id
    WHERE c.country_code IN ('BG', 'RU', 'US')
    GROUP BY c.country_code
    ORDER BY `mountain_range` DESC;

#Problem 14. Countries with Rivers
SELECT 
    c.country_name, r.river_name
FROM
    countries AS c
    LEFT JOIN countries_rivers AS cr
    ON c.country_code = cr.country_code
    LEFT JOIN rivers AS r
    ON cr.river_id = r.id
    WHERE c.continent_code IN ('AF')
    ORDER BY c.country_name ASC
    LIMIT 5;

#Problem 15. Countries without any Mountains
SELECT d1.continent_code, d1.currency_code, d1.currency_usage FROM
    (SELECT `c`.`continent_code`, `c`.`currency_code`,
    COUNT(`c`.`currency_code`) AS `currency_usage` FROM countries as c
    GROUP BY c.currency_code, c.continent_code HAVING currency_usage > 1) as d1
LEFT JOIN
    (SELECT `c`.`continent_code`,`c`.`currency_code`,
    COUNT(`c`.`currency_code`) AS `currency_usage` FROM countries as c
     GROUP BY c.currency_code, c.continent_code HAVING currency_usage > 1) as d2
ON d1.continent_code = d2.continent_code AND d2.currency_usage > d1.currency_usage
 
WHERE d2.currency_usage IS NULL
ORDER BY d1.continent_code, d1.currency_code;

#Problem 16. Countries without any Mountains
SELECT 
    COUNT(*)
FROM
    countries AS c
    LEFT JOIN mountains_countries AS mc
    ON c.country_code = mc.country_code
    WHERE mc.mountain_id IS NULL;

#Problem 17: Highest Peak and Longest River by Country
SELECT 
    c.country_name,
    MAX(p.elevation) AS `highest_peak_elevetion`,
    MAX(r.length) AS `longest_river_length`
FROM
    countries AS c
        JOIN
    mountains_countries AS mc ON c.country_code = mc.country_code
        JOIN
    mountains AS m ON mc.mountain_id = m.id
        JOIN
    peaks AS p ON m.id = p.mountain_id
        JOIN
    countries_rivers AS cr ON c.country_code = cr.country_code
        JOIN
    rivers AS r ON cr.river_id = r.id
GROUP BY c.country_code
ORDER BY `highest_peak_elevetion` DESC , `longest_river_length` DESC , c.country_name ASC
LIMIT 5;




