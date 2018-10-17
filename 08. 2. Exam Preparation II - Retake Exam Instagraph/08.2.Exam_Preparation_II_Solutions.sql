DROP DATABASE IF EXISTS exam_prep_2;
CREATE DATABASE exam_prep_2;
USE exam_prep_2;


####################################################
# Section 1: Data Definition Language (DDL) – 40 pts
####################################################

# 01. Table Design

CREATE TABLE pictures(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
path VARCHAR(255) NOT NULL,
size DECIMAL(10, 2) NOT NULL
);

CREATE TABLE users(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
username VARCHAR(30) NOT NULL UNIQUE,
password VARCHAR(30) NOT NULL,
profile_picture_id INT(11)
);

CREATE TABLE posts(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
caption VARCHAR(255) NOT NULL,
user_id INT(11) NOT NULL,
picture_id INT(11) NOT NULL
);

CREATE TABLE comments(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
content VARCHAR(255) NOT NULL,
user_id INT(11) NOT NULL,
post_id INT(11) NOT NULL
);

CREATE TABLE users_followers(
user_id INT(11),
follower_id INT(11)
);

ALTER TABLE users
ADD CONSTRAINT fk_users_pictures FOREIGN KEY(profile_picture_id)
REFERENCES pictures(id);

ALTER TABLE posts
ADD CONSTRAINT fk_posts_users FOREIGN KEY(user_id)
REFERENCES users(id);

ALTER TABLE posts
ADD CONSTRAINT fk_posts_pictures FOREIGN KEY(picture_id)
REFERENCES pictures(id);

ALTER TABLE comments
ADD CONSTRAINT fk_comments_users FOREIGN KEY(user_id)
REFERENCES users(id);

ALTER TABLE comments
ADD CONSTRAINT fk_comments_posts FOREIGN KEY(post_id)
REFERENCES posts(id);


ALTER TABLE users_followers
ADD CONSTRAINT fk_users_followers_users FOREIGN KEY(user_id)
REFERENCES users(id);

ALTER TABLE users_followers
ADD CONSTRAINT fk_users_followers_followers FOREIGN KEY(follower_id)
REFERENCES users(id);

######################################################
# Section 2: Data Manipulation Language (DML) – 30 pts
######################################################

# 02. Data Insertion

INSERT INTO comments (content, user_id, post_id)
SELECT 
	concat('Omg!', u.username ,'!This is so cool!'),
	ceil(p.id*3/2),
	p.id
 FROM users AS u
 JOIN posts AS p
 ON u.id = p.user_id
 WHERE p.id BETWEEN 1 AND 10;

# 03. Data Update
UPDATE users AS u
JOIN  users_followers AS uf
ON u.id = uf.user_id
	JOIN 
		(SELECT uf.user_id, count(uf.follower_id) AS `folowers_count` FROM  users_followers AS uf
		GROUP BY uf.user_id
		ORDER BY uf.user_id) AS `folowers`
		ON u.id = `folowers`.user_id
	SET u.profile_picture_id = CASE WHEN `folowers`.`folowers_count`= 0 THEN u.id
	ELSE `folowers`.`folowers_count`
	END
WHERE u.profile_picture_id IS NULL;

# 04. Data Deletion
DELETE FROM users
USING 
	users
    LEFT JOIN users_followers
    ON users.id = users_followers.user_id
    WHERE users_followers.follower_id IS NULL;

##################################
# Section 3: Querying – 100 pts
##################################

# 05. Users
SELECT u.id, u.username FROM users AS u
ORDER BY u.id ASC;

# 06. Cheaters
SELECT u.id, u.username FROM users_followers AS uf
JOIN users AS u
ON uf.user_id = u.id
WHERE uf.user_id = uf.follower_id
ORDER BY user_id;

# 07. High Quality Pictures
SELECT * FROM pictures AS pic
WHERE pic.size > 50000 AND  (LOCATE('jpeg', pic.path) > 0 OR LOCATE('png', pic.path) > 0)
ORDER BY pic.size DESC;

# 08. Comments and Users
SELECT c.id, concat(u.username,' : ',c.content) AS `full_comment`  FROM comments AS c
JOIN users AS u
ON c.user_id = u.id
ORDER BY c.id DESC;

# 09. Profile Pictures
SELECT u.id, u.username, CONCAT(p.size,'KB')
	FROM users AS u
    JOIN
	(
		SELECT u.profile_picture_id AS `pic_id`,  count(u.id) AS `count` FROM users AS u
		GROUP BY u.profile_picture_id
		HAVING `count` > 1
	) AS `pics_count`
    ON u.profile_picture_id = `pics_count`.`pic_id`
    JOIN pictures AS p
    ON u.profile_picture_id = p.id
    ORDER BY u.id ASC;
	

# 10. Spam Posts
SELECT p.id, p.caption AS `caption`, count(c.id) AS `comments` FROM posts AS p
LEFT JOIN comments AS c
ON p.id = c.post_id
GROUP BY p.id
ORDER BY `comments` DESC, p.id
LIMIT 5;

# 11. Most Popular User
SELECT 
	`followers_count`.`user_id` AS `id`, 
    `followers_count`.username AS `username`,
    `posts_count`.`posts` AS `posts`,
    `followers_count`.`followers` AS `folowers` 
    FROM 
(SELECT u.id AS `user_id`, u.username, COUNT(uf.follower_id) AS `followers` FROM users AS u
JOIN users_followers AS uf
ON u.id = uf.user_id
GROUP BY u.id) AS `followers_count` 
JOIN
(SELECT u.id AS `user_id`, count(p.id) AS `posts` FROM posts AS p
JOIN users AS u
ON p.user_id = u.id
GROUP BY u.id) AS `posts_count` 
ON `followers_count`.`user_id` = `posts_count`.`user_id`
ORDER BY `followers` DESC
LIMIT 1; 

# 12. Commenting Myself
SELECT u.id, u.username, count(`cq`.id) AS `my_comments` FROM users AS u
LEFT JOIN 
	(SELECT p.user_id, c.id FROM posts AS p
	 LEFT JOIN comments AS c
	 ON p.id = c.post_id
	 WHERE c.user_id = p.user_id
	 ORDER BY  p.user_id) AS `cq`
ON u.id = `cq`.user_id
GROUP BY u.id
ORDER BY `my_comments` DESC, u.id;

# Solution 2 with CASE
SELECT 
	u.id, 
    u.username, 
    (CASE WHEN  tb.my_comments IS NULL THEN 0 ELSE tb.my_comments END) as my_comments
FROM users u
LEFT JOIN
	(SELECT p.id, p.user_id, count(p.id) as my_comments
	FROM posts p
	JOIN comments c
	ON p.id = c.post_id
	WHERE p.user_id = c.user_id
	GROUP BY c.user_id) as tb
ON u.id = tb.user_id
ORDER BY tb.my_comments DESC, u.id;

# 13. User Top Posts
SELECT u.id, u.username,`cq2`.`caption` 
FROM users AS u
JOIN 
	(SELECT `cq`.user_id,`cq`.`caption` ,  max(`cq`.`count`) FROM
		(SELECT p.caption AS `caption`, p.id, p.user_id, count(c.id) AS `count` 
			FROM posts AS p
			LEFT JOIN comments AS c
			ON p.id = c.post_id
			GROUP BY p.id
			ORDER BY `count` DESC, p.id) AS `cq`
	GROUP BY `cq`.user_id) AS `cq2`
ON u.id = `cq2`.user_id;

# 14. Posts and Commentators
SELECT 
	p.id, 
    p.caption, 
    COUNT(DISTINCT c.user_id) AS `users` 
FROM posts As p
LEFT JOIN comments AS c
ON p.id = c.post_id
GROUP BY p.id
ORDER BY `users` DESC, p.id;

#####################################
# Section 4: Programmability – 30 pts
#####################################
DROP PROCEDURE IF EXISTS udp_post; 
# 15. Post

DELIMITER $$
CREATE PROCEDURE udp_post(username VARCHAR(30),password VARCHAR(30), caption VARCHAR(255), path VARCHAR(255))
BEGIN
	DECLARE user_id INT(11);
    DECLARE picture_id INT(11);
	SET user_id := (SELECT u.id FROM users AS u WHERE u.username = username);
    SET picture_id := (SELECT p.id FROM users AS u
					JOIN pictures AS p
					ON u.profile_picture_id = p.id
                    WHERE p.path = path);

	IF (SELECT COUNT(*) FROM users AS u WHERE u.id = user_id AND u.password = password) <> 1 
    THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Password is incorrect!' ;
    END IF;

	IF (SELECT count(p.id) FROM users AS u
		JOIN pictures AS p
		ON u.profile_picture_id = p.id
		WHERE p.path = path)<> 1 
	THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'The picture does not exist!' ;
	END IF;
    
    INSERT INTO posts(caption, user_id, picture_id)
    VALUES(caption,user_id, picture_id);

END$$

DELIMITER ;

CALL udp_post(
	'UnderSinduxrein',
    '4l8nYGTKMW',
	'#new #procedure',
    'src/folders/resources/images/story/reformatted/img/hRI3TW31rC.img'
);

SELECT p.id FROM users AS u
		JOIN pictures AS p
		ON u.profile_picture_id = p.id
		WHERE p.path = 'src/folders/resources/images/profile/blocked/bmp/kjOJjKpKh4.bmp';

# 16. Filter
DROP PROCEDURE IF EXISTS udp_filter;

DELIMITER $$
CREATE PROCEDURE udp_filter(hashtag VARCHAR(50))
BEGIN
	SELECT p.id, p.caption, u.username FROM posts AS p
	JOIN users AS u
	ON p.user_id = u.id
	WHERE locate(concat('#',hashtag),p.caption) > 0
	ORDER BY p.id;
END $$

DELIMITER ;

CALL udp_filter('cool');

SELECT p.id, p.caption, u.username FROM posts AS p
JOIN users AS u
ON p.user_id = u.id
WHERE locate(concat('#','cool'),p.caption) > 0
ORDER BY p.id;