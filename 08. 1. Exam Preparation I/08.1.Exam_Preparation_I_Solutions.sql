USE exam_db;

# 01. Create Database
DROP DATABASE IF EXISTS exam_db;
CREATE DATABASE exam_db;
USE exam_db;

CREATE TABLE users(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
username VARCHAR(30) NOT NULL UNIQUE,
password VARCHAR(30) NOT NULL,
email VARCHAR(50) NOT NULL
);

CREATE TABLE repositories(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50) NOT NULL
);

CREATE TABLE repositories_contributors(
repository_id INT(11),
contributor_id INT(11)
);

CREATE TABLE issues(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
title VARCHAR(255) NOT NULL,
issue_status VARCHAR(6) NOT NULL,
repository_id INT(11) NOT NULL,
assignee_id INT(11) NOT NULL
);

CREATE TABLE commits(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
message VARCHAR(255) NOT NULL,
issue_id INT(11),
repository_id INT(11) NOT NULL,
contributor_id INT(11) NOT NULL
);


CREATE TABLE files(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(100) NOT NULL,
size DECIMAL(10,2) NOT NULL,
parent_id INT(11),
commit_id INT(11) NOT NULL
);


ALTER TABLE repositories_contributors
ADD CONSTRAINT fk_repositories_contributors_repositories FOREIGN KEY(repository_id)
REFERENCES repositories(id);

ALTER TABLE repositories_contributors
ADD CONSTRAINT fk_repositories_contributors_users FOREIGN KEY(contributor_id)
REFERENCES users(id);

ALTER TABLE issues
ADD CONSTRAINT fk_issues_repositories FOREIGN KEY(repository_id)
REFERENCES repositories(id);

ALTER TABLE issues
ADD CONSTRAINT fk_issues_users FOREIGN KEY(assignee_id)
REFERENCES users(id);

ALTER TABLE commits
ADD CONSTRAINT fk_commits_issues FOREIGN KEY(issue_id)
REFERENCES issues(id);

ALTER TABLE commits
ADD CONSTRAINT fk_commits_repositories FOREIGN KEY(repository_id)
REFERENCES repositories(id);

ALTER TABLE commits
ADD CONSTRAINT fk_commits_users FOREIGN KEY(contributor_id)
REFERENCES users(id);

ALTER TABLE files
ADD CONSTRAINT fk_files_commits FOREIGN KEY(commit_id)
REFERENCES commits(id);

ALTER TABLE files
ADD CONSTRAINT fk_files_files FOREIGN KEY(parent_id)
REFERENCES files(id);

# 02. Data Insertion
INSERT INTO issues(title, issue_status, repository_id, assignee_id)
SELECT 
CONCAT('Critical Problem With ', f.name ,'!'),
'open',
ceil(f.id *2/3),
c.contributor_id
FROM files AS f
JOIN commits AS c
ON  f.commit_id = c.id
WHERE f.id  BETWEEN 46 AND 50;

# 04. Data Deletion
DELETE FROM repositories 
	USING
	repositories 
	LEFT JOIN issues 
	ON issues.repository_id = repositories.id
	WHERE issues.id IS NULL;
    
###########################################################

# 05. Users
SELECT u.id, u.username FROM users AS u
ORDER BY u.id;

# 06. Lucky Numbers
SELECT * FROM repositories_contributors AS rc
WHERE rc.repository_id = rc.contributor_id
ORDER BY rc.repository_id;

# 07. Heavy HTML
SELECT f.id, f.name, f.size  FROM files AS f
WHERE f.size > 1000 AND locate('.html', f.name)  > 0
ORDER BY f.size DESC;

# 08.Issues and Users
SELECT i.id, CONCAT(u.username,' : ',i.title) FROM issues AS i
JOIN users AS u
WHERE i.assignee_id = u.id
ORDER BY i.id DESC;

# 09. Non-Directory Files
SELECT f.id, f.name, concat(f.size,'KB') FROM files AS f
LEFT JOIN files AS d
ON f.id = d.parent_id
WHERE d.parent_id IS NULL
ORDER BY f.id;

# 10. Active Repositories
SELECT r.id, r.name, COUNT(i.repository_id) AS `issues_count` FROM issues AS i
JOIN repositories AS r
ON i.repository_id = r.id
GROUP BY i.repository_id
ORDER BY `issues_count` DESC, r.id
LIMIT 5;

# 11. Most Contributed Repository
SELECT 
	r.id AS `repo_id`, 
	r.name, 
	(
		SELECT  COUNT(c.contributor_id) FROM commits AS c
		WHERE c.id = r.id
	 ) AS `commits`,
	 COUNT(*) AS `contributors`

FROM users AS u
JOIN repositories_contributors AS rc
ON u.id = rc.contributor_id
JOIN repositories AS r
ON rc.repository_id = r.id
GROUP BY  r.name
ORDER BY `contributors` DESC, r.id;

# 12. Fixing My Own Problems
SELECT u.id, u.username, COUNT(c.id) AS `commits` FROM users AS u
LEFT JOIN issues AS i
ON u.id =  i.assignee_id
LEFT JOIN commits as c
ON c.issue_id = i.id AND c.contributor_id = i.assignee_id
GROUP BY i.assignee_id
ORDER BY `commits` DESC, u.id;

# 13. Recursive Commits

# Solution 1 with JOIN
SELECT 
    LEFT(f.name, LOCATE('.', f.name)-1) AS `file`,
    count(c.id)
    FROM files AS f
JOIN files AS pf
ON f.id = pf.parent_id AND f.parent_id = pf.id AND f.id != pf.id
LEFT JOIN commits AS c
ON c.message LIKE concat('%',f.name , '%')
GROUP BY f.id
ORDER BY  f.name;

# Solution 2 with SELECT for the `recursive_count`
SELECT 
    LEFT(f.name, LOCATE('.', f.name)-1) AS `file`,
    (SELECT count(*) FROM commits AS c
		WHERE locate(f.name, c.message) > 0 ) AS `recursive_count` 
    FROM files AS f
JOIN files AS pf
ON f.id = pf.parent_id AND f.parent_id = pf.id AND f.id != pf.id
JOIN commits AS c
ON f.commit_id = c.id
ORDER BY  f.name;

# 14. Repositories and Commits
SELECT  
	r.id, 
    r.name, 
    count(DISTINCT c.contributor_id) AS `users`
FROM repositories AS r
LEFT JOIN commits AS c
ON r.id = c.repository_id
GROUP BY r.id
ORDER BY `users` DESC, r.id;

# 15. Commit
DROP PROCEDURE IF EXISTS udp_commit;

DELIMITER $$
CREATE PROCEDURE udp_commit(username VARCHAR(30), password VARCHAR(30), message VARCHAR(255), issue_id int(11))
BEGIN
	DECLARE user_id INT(11);
    DECLARE repo_id INT(11);

	SET user_id := (SELECT u.id FROM users AS u WHERE u.username = username);
    SET repo_id := (SELECT i.repository_id FROM issues AS i WHERE  i.id = 2);
    
    IF 1 != (SELECT COUNT(*) FROM users WHERE users.id = user_id) THEN
     SIGNAL SQLSTATE '45000'
	 SET MESSAGE_TEXT = 'No such user!';
    END IF;
    
     IF 1 != (SELECT COUNT(*) FROM users WHERE users.id = user_id AND users.password = password) THEN
     SIGNAL SQLSTATE '45000'
	 SET MESSAGE_TEXT = 'Password is incorrect!';
    END IF;
    
	IF 1 != (SELECT COUNT(*) FROM issues WHERE issues.id = issue_id) THEN
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'The issue does not exist!';
    END IF;
    
    INSERT INTO commits(message, issue_id, repository_id, contributor_id)
    VALUES(message, issue_id, repo_id, user_id);
    
    UPDATE issues
    SET issue_status = 'closed'
    WHERE id = issue_id;

END $$

DELIMITER ;

CALL udp_commit(
'WhoDenoteBel',
 'ajmISQi*',
 'Fixed issue: Invalid welcoming message in Read.html',
 2 
 );

# 16. Filter Extensions
DROP PROCEDURE IF EXISTS udp_findbyextension;

DELIMITER $$
CREATE PROCEDURE udp_findbyextension(extension VARCHAR(50))
BEGIN
	SELECT f.id, f.name AS `caption`, concat(f.size, 'KB')  FROM files AS f
	WHERE f.name LIKE concat('%.', extension)
	ORDER BY f.id;
END$$

DELIMITER ;

CALL udp_findbyextension('html');
