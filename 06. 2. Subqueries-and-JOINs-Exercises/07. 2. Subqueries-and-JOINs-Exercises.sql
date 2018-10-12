USE soft_uni;

#Problem 1.	Employee Address
SELECT 
    e.employee_id, e.job_title, e.address_id, a.address_text
FROM
    employees AS e
        JOIN
    addresses AS a 
    ON e.address_id = a.address_id
    ORDER BY e.address_id
    LIMIT 5;
    
#Problem 2.	Addresses with Towns
SELECT 
    e.first_name, e.last_name, t.name AS 'town', a.address_text
FROM
    employees AS e
        INNER JOIN
    addresses AS a ON a.address_id = e.address_id
        INNER JOIN
    towns AS t ON a.town_id = t.town_id
    ORDER BY e.first_name, e.last_name
    LIMIT 5;

#Problem 3.	Sales Employee
SELECT e.employee_id, e.first_name, e.last_name, 
  d.name AS department_name
FROM employees AS e 
  INNER JOIN departments AS d 
    ON e.department_id = d.department_id
WHERE d.name = 'Sales'
ORDER BY e.employee_id DESC;

#Problem 4.	Employee Departments
SELECT 
    e.employee_id, e.first_name, e.salary, d.name AS depatrment_name
FROM
    employees AS e
    JOIN departments as d
    ON e.department_id = d.department_id
    WHERE e.salary > 15000
    ORDER BY e.department_id DESC
    LIMIT 5;

#Problem 5.	Employees Without Project
SELECT 
    e.employee_id, e.first_name
FROM
    employees AS e
    LEFT OUTER JOIN employees_projects as ep
    ON e.employee_id = ep.employee_id
    WHERE ep.employee_id IS NULL
    ORDER BY e.employee_id DESC
    LIMIT 3;

#Problem 6.	Employees Hired After
SELECT 
    e.first_name,
    e.last_name,
    e.hire_date,
    d.name AS department_name
FROM
    employees AS e
        INNER JOIN
    departments AS d ON e.department_id = d.department_id
WHERE
    DATE(e.hire_date) > '1999/1/1'
        AND d.name IN ('Sales' , 'Finance')
ORDER BY e.hire_date;
	
#Problem 7.	Employees with Project
SELECT 
    e.employee_id,
    e.first_name,
    p.name AS project_name
FROM
    employees AS e
    INNER JOIN employees_projects AS ep
    USING (employee_id)
	INNER JOIN projects AS p
    USING (project_id)
    WHERE DATE(p.start_date) > '2002.08.13'
    AND p.end_date IS NULL
    ORDER BY e.first_name, p.name
    LIMIT 5;

#Problem 8.	Employee 24
SELECT 
    e.employee_id,
    e.first_name,
    IF(DATE(p.start_date) < '2005/01/01',  p.name, NULL) AS project_name
FROM
    employees AS e
    INNER JOIN employees_projects AS ep
    USING (employee_id)
	INNER JOIN projects AS p
    USING (project_id)
    WHERE e.employee_id = 24
    ORDER BY project_name;

#Problem 9.	Employee Manager
SELECT 
    e.employee_id,
    e.first_name,
    e.manager_id,
    e2.first_name AS manger_name
FROM
    employees AS e
    INNER JOIN employees AS e2
    ON e.manager_id = e2.employee_id
    WHERE e.manager_id  IN (3, 7)
    ORDER BY e.first_name;


#Problem 10. Employee Summary
SELECT 
    e.employee_id,
    CONCAT_WS(' ', e.first_name, e.last_name) AS employee_name,
    CONCAT_WS(' ', e2.first_name, e2.last_name) AS manager_name,
    d.name AS deartment_name
FROM
    employees AS e
    INNER JOIN employees AS e2
	ON e.manager_id = e2.employee_id
    INNER JOIN departments AS d
	ON e.department_id = d.department_id
	WHERE e.manager_id IS NOT NULL
    ORDER BY e.employee_id
    LIMIT 5;
    
#Problem 11. Min Average Salary 
SELECT 
    MIN(avg_salary_by_dep_id.avg_salary) as min_average_salary
FROM
    (SELECT 
        AVG(e.salary) AS avg_salary
    FROM
        employees AS e
    GROUP BY e.department_id) AS avg_salary_by_dep_id;

################################################
USE geography;

#Problem 12. Highest Peaks in Bulgaria 
SELECT 
   c.country_code, m.mountain_range, p.peak_name, p.elevation
FROM
    countries AS c
	INNER JOIN mountains_countries AS mc
    USING (country_code)
    INNER JOIN mountains AS m
    ON mc.mountain_id = m.id
	INNER JOIN peaks AS p
    USING (mountain_id)	
    WHERE c.country_code = 'BG'
    AND p.elevation > 2835
    ORDER BY p.elevation DESC;

	
#Problem 13. Count Mountain Ranges
SELECT 
   mc.country_code, COUNT(m.id) as mountain_range
FROM
	mountains_countries AS mc
    INNER JOIN mountains AS m
    ON mc.mountain_id = m.id
    WHERE mc.country_code IN ('BG', 'US', 'RU')
    GROUP BY mc.country_code
    HAVING mountain_range > 0
    ORDER BY mountain_range DESC;

#Problem 14. Countries with Rivers
SELECT 
   c.country_name, r.river_name
FROM
    countries AS c
	LEFT OUTER JOIN countries_rivers AS cr
    USING (country_code)
    LEFT OUTER JOIN rivers AS r
    ON cr.river_id = r.id
    WHERE c.continent_code = 'AF'
    ORDER BY c.country_name
    LIMIT 5;
    
#Problem 15. Continents and Currencies
SELECT cu2.continent_code, cu2.currency_code , cu2.currency_usage
	FROM (SELECT continent_code, currency_code ,count(currency_code) AS 'currency_usage'
	        FROM countries
			GROUP BY continent_code, currency_code
			HAVING count(currency_code) > 1
           ) AS cu2
	JOIN
		(SELECT cu.continent_code, max(currency_usage) AS 'max_currency_usage'
			FROM
		(SELECT continent_code, currency_code ,count(currency_code) AS 'currency_usage'
			FROM countries
			GROUP BY continent_code, currency_code
			HAVING count(currency_code) > 1) AS cu
			GROUP BY cu.continent_code) AS max_cu
ON cu2.continent_code = max_cu.continent_code
AND cu2.currency_usage = max_cu.max_currency_usage
ORDER BY cu2.continent_code, cu2.currency_code;

#Problem 16. Countries without any Mountains
SELECT 
	COUNT(*) AS country_count  
FROM 	
	countries AS c
LEFT JOIN mountains_countries AS mc
ON c.country_code = mc.country_code
WHERE mc.mountain_id IS NULL;

#Problem 17. Highest Peak and Longest River by Country
SELECT 
   c.country_name, 
   MAX(p.elevation) AS highest_peak_elevation,
   MAX(r.length) AS longest_river_length
FROM
    countries AS c
	LEFT OUTER JOIN mountains_countries AS mc
    USING (country_code)
    LEFT OUTER JOIN mountains AS m
    ON mc.mountain_id = m.id
	LEFT OUTER JOIN peaks AS p
    USING (mountain_id)	
    LEFT OUTER JOIN countries_rivers AS cr
    USING (country_code)
    LEFT OUTER JOIN rivers AS r
    ON cr.river_id = r.id
    GROUP BY c.country_name
    ORDER BY highest_peak_elevation DESC, longest_river_length DESC
    LIMIT 5;


