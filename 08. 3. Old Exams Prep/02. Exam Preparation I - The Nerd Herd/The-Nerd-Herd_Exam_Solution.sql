DROP DATABASE IF EXISTS nerd_herd_db;
CREATE DATABASE nerd_herd_db;
USE nerd_herd_db;

#####################################################
# Section 1: Data Definition Language (DDL) – 30 pts
#####################################################

CREATE TABLE users(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
nickname VARCHAR(25),
gender CHAR(1),
age INT(11),
location_id INT(11),
credential_id INT(11) UNIQUE
);

CREATE TABLE locations(
id INT(11) PRIMARY KEY,
latitude FLOAT,
longitude FLOAT
);

CREATE TABLE credentials(
id INT(11) PRIMARY KEY,
email VARCHAR(30),
password VARCHAR(20)
);

CREATE TABLE chats(
id INT(11) PRIMARY KEY,
title VARCHAR(32),
start_date DATE,
is_active BIT
);

CREATE TABLE messages(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
content VARCHAR(200),
sent_on DATE,
chat_id INT(11),
user_id INT(11)
);

CREATE TABLE users_chats(
user_id INT(11), 
chat_id INT(11)
);

ALTER TABLE users
ADD CONSTRAINT fk_users_locations FOREIGN KEY(location_id)
REFERENCES locations(id);

ALTER TABLE users
ADD CONSTRAINT fk_users_credentials FOREIGN KEY(credential_id)
REFERENCES credentials(id);

ALTER TABLE messages
ADD CONSTRAINT fk_messages_chats FOREIGN KEY(chat_id)
REFERENCES chats(id);

ALTER TABLE messages
ADD CONSTRAINT fk_messages_users FOREIGN KEY(user_id)
REFERENCES users(id);

ALTER TABLE users_chats
ADD CONSTRAINT fk_users_chats_users FOREIGN KEY(user_id)
REFERENCES users(id);

ALTER TABLE users_chats
ADD CONSTRAINT fk_users_chats_chats FOREIGN KEY(chat_id)
REFERENCES chats(id);

ALTER TABLE users_chats
ADD CONSTRAINT pk_users_chats PRIMARY KEY(user_id, chat_id);

######################################################
# Section 2: Data Manipulation Language (DML) – 30 pts
######################################################
USE nerd_herd_db;

# 02. Data Insertion

INSERT INTO messages(content, sent_on, chat_id, user_id)
SELECT 
	concat_ws('-',u.age,u.gender, l.latitude, l.longitude),
	'2016-12-15',
     CASE 
		WHEN u.gender = 'F' THEN ceil(sqrt(u.age * 2))
        WHEN u.gender = 'M' THEN pow((u.age / 18),3)
    END,
	u.id
FROM users AS u
JOIN locations AS l
ON u.location_id = l.id
WHERE u.id BETWEEN 10 AND 20;

# 03. Update
UPDATE chats AS c
INNER JOIN messages AS m
ON c.id = m.chat_id
SET c.start_date = m.sent_on
WHERE c.start_date > m.sent_on;


# 04. Delete
DELETE FROM locations
USING
	locations
	LEFT JOIN users
	ON locations.id = users.location_id
    WHERE users.id IS NULL;

##################################
# Section 3: Querying – 100 pts
##################################

# 05. Age Range
SELECT 
    u.nickname, u.gender, u.age
FROM
    users AS u
WHERE
    u.age BETWEEN 22 AND 37
ORDER BY u.id ASC;

# 06. Messages
SELECT m.content, m.sent_on FROM messages AS m
WHERE m.sent_on > '2014-05-12' AND LOCATE('just', m.content ) > 0
ORDER BY m.id DESC; 

# 07. Chats
SELECT 
    c.title, c.is_active
FROM
    chats AS c
WHERE
    (c.is_active IS FALSE
	AND CHAR_LENGTH(c.title) < 5)
        OR LOCATE('tl', c.title) = 3
ORDER BY c.title DESC;

# 08. Chat Messages
SELECT 
   c.id,  c.title, m.id
FROM
    chats AS c
JOIN messages AS m
ON c.id = m.chat_id
WHERE
  m.sent_on < '2012-03-26' AND c.title LIKE '%x'
ORDER BY c.id ASC, m.id ASC;

# 09. Message Count
SELECT c.id, count(m.id)AS `total_messages` FROM chats AS c
LEFT JOIN messages AS m
ON c.id = m.chat_id
WHERE m.id < 90
GROUP BY c.id
ORDER BY `total_messages` DESC, c.id
LIMIT 5;

# 10. Credentials
SELECT 
    u.nickname, c.email, c.password
FROM
    users AS u
        JOIN
    credentials AS c ON u.credential_id = c.id
WHERE
    c.email LIKE '%co.uk'
ORDER BY c.email ASC;

# 11. Locations
SELECT u.id, u.nickname, u.age FROM users AS u
LEFT JOIN locations AS l
ON u.location_id = l.id
WHERE l.id IS NULL
ORDER BY u.id;

# 12. Left Users
SELECT m.id, c.id AS `chat_id`, m.user_id
FROM messages AS m
JOIN chats AS c
ON m.chat_id = c.id
JOIN users AS u
ON m.user_id = u.id
WHERE c.id = 17  AND u.id NOT IN 
		(SELECT u.id AS `user_id` FROM users AS u
		RIGHT JOIN users_chats uc
		ON u.id = uc.user_id
        WHERE uc.chat_id = 17)
ORDER BY m.id DESC;

# 13. Users in Bulgaria
SELECT  u.nickname, c.title, l.latitude, l.longitude 
FROM users AS u
JOIN locations AS l
ON u.location_id = l.id
JOIN users_chats AS uc
ON u.id = uc.user_id
JOIN chats AS c
ON uc.chat_id = c.id
WHERE  l.latitude >= 41.139999 AND  l.latitude <= 44.129999  AND
		l.longitude BETWEEN 22.209999 AND 28.359999
ORDER BY c.title; 

# 14. Last Chat 
SELECT c.title, m.content FROM chats AS c
Left JOIN messages AS m
ON m.chat_id = c.id
WHERE c.start_date = (SELECT max(c.start_date) FROM chats AS c)
ORDER BY  m.sent_on, m.id;

######################################
# Section 4: Programmability – 40 pts
######################################

# 16. Radians
DROP FUNCTION IF EXISTS udf_get_radians;

DELIMITER $$
CREATE FUNCTION udf_get_radians(degrees FLOAT)
RETURNS FLOAT
BEGIN
	DECLARE result FLOAT;
    SET result :=  (degrees * pi())/ 180; 
    RETURN result;
END $$

DELIMITER ;

SELECT udf_get_radians(22.12) AS radians;

# 16. Change Password
DROP PROCEDURE IF EXISTS udp_change_password;

DELIMITER $$
CREATE PROCEDURE udp_change_password(email VARCHAR(50), password VARCHAR(50))
BEGIN
    IF 1 != (SELECT COUNT(*) FROM credentials WHERE credentials.email = email) THEN
     SIGNAL SQLSTATE '45000'
	 SET MESSAGE_TEXT = "The email does't exist!";
    END IF;

    UPDATE credentials
    SET credentials.password = password
    WHERE credentials.email = email;
END $$

DELIMITER ;

CALL udp_change_password('abarnes0@sogou.com', 'new_pass');

# 17. Send Message 
DROP PROCEDURE IF EXISTS udp_send_message;

DELIMITER $$
CREATE PROCEDURE udp_send_message (
		user_id int(11), 
        chat_id int(11), 
        content  VARCHAR(255))
BEGIN
    IF 1 > (SELECT count(*) FROM users AS u
				JOIN users_chats AS uc
				ON u.id = uc.user_id
                WHERE user_id = u.id
				GROUP BY u.id) 
		 THEN
		 SIGNAL SQLSTATE '45000'
		 SET MESSAGE_TEXT = 'There is no chat with that user!';
    END IF;

    INSERT INTO messages(content, sent_on, chat_id, user_id)
    VALUES(content, '2016-12-15', chat_id, user_id);
    
END $$

DELIMITER ;

CALL udp_send_message(
 19,
 17,
 'Awesome' 
 );

# 18. Log Messages
DROP TABLE IF EXISTS messages_log;

CREATE TABLE messages_log(
message_id INT(11) NOT NULL,
content VARCHAR(200),
sent_on DATE,
chat_id INT(11),
user_id INT(11)
);

DROP TRIGGER IF EXISTS delete_trigger;
DELIMITER $$

CREATE TRIGGER delete_trigger
AFTER DELETE
ON messages
FOR EACH ROW
BEGIN
	INSERT INTO messages_log(id, content, sent_on, chat_id, user_id)
	VALUES(OLD.id, OLD.content, OLD.sent_on, OLD.chat_id, OLD.user_id);
END $$

DELIMITER ;

DELETE FROM messages
WHERE id = 35;

SELECT * FROM messages_log;

# 19. Delete Users
DROP TABLE IF EXISTS delete_user_log;

CREATE TABLE delete_user_log(
id INT(11),
nickname VARCHAR(25),
gender CHAR(1),
age INT(11),
location_id INT(11),
credential_id INT(11) UNIQUE
);

DROP TRIGGER IF EXISTS delete_user_trigger;
DELIMITER $$

CREATE TRIGGER delete_user_trigger
BEFORE DELETE
ON users
FOR EACH ROW
BEGIN
	DELETE FROM messages WHERE messages.user_id = OLD.id;
    DELETE FROM messages_log WHERE messages_log.user_id = OLD.id;
    DELETE FROM users_chats WHERE users_chats.user_id = OLD.id;
END $$

	
DELIMITER ;

DELETE FROM users
WHERE users.id = 1;

####################################

SELECT * FROM users AS u;
SELECT * FROM users_chats AS u;  
SELECT * FROM chats AS c;
SELECT * FROM credentials AS c; 
SELECT * FROM locations AS l; 
SELECT * FROM messages AS m; 