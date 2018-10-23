DROP DATABASE IF EXISTS mysql_exam_db;
CREATE DATABASE mysql_exam_db;
USE mysql_exam_db;

####################################################
# Section 1: Data Definition Language (DDL) – 40 pts
####################################################

# 01. Create Database
CREATE TABLE planets(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(30) NOT NULL 
);

CREATE TABLE spaceports(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50) NOT NULL,
planet_id  INT(11)
);

CREATE TABLE spaceships(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50) NOT NULL,
manufacturer VARCHAR(30) NOT NULL,
light_speed_rate INT(11) DEFAULT 0
);

CREATE TABLE colonists(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(20) NOT NULL,
last_name VARCHAR(20) NOT NULL,
ucn CHAR(10) NOT NULL UNIQUE,
birth_date DATE NOT NULL
);

CREATE TABLE journeys(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
journey_start DATETIME NOT NULL,
journey_end DATETIME NOT NULL,
purpose ENUM('Medical','Technical','Educational','Military'),
destination_spaceport_id INT(11),
spaceship_id INT(11)
);

CREATE TABLE travel_cards(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
card_number CHAR(10) NOT NULL UNIQUE,
job_during_journey ENUM('Pilot','Engineer','Trooper','Cleaner','Cook'),
colonist_id INT(11),
journey_id INT(11)
);

ALTER TABLE spaceports
ADD CONSTRAINT fk_spaceports_planets FOREIGN KEY(planet_id)
REFERENCES planets(id);

ALTER TABLE journeys
ADD CONSTRAINT fk_journeys_spaceports FOREIGN KEY(destination_spaceport_id)
REFERENCES spaceports(id);

ALTER TABLE journeys
ADD CONSTRAINT fk_journeys_spaceships FOREIGN KEY(spaceship_id)
REFERENCES spaceships(id);

ALTER TABLE travel_cards
ADD CONSTRAINT fk_travel_cards_colonists FOREIGN KEY(colonist_id)
REFERENCES colonists(id);

ALTER TABLE travel_cards
ADD CONSTRAINT fk_travel_cards_journeys FOREIGN KEY(journey_id)
REFERENCES journeys(id);



######################################################
# Section 2: Data Manipulation Language (DML) – 30 pts
######################################################


#01. Data Insertion
INSERT INTO travel_cards (card_number, job_during_journey, colonist_id, journey_id)
SELECT 
IF(c.birth_date > '1980-01-01', 
	CONCAT(YEAR(c.birth_date),DAY(c.birth_date),LEFT(c.ucn, 4)),
    CONCAT(YEAR(c.birth_date),month(c.birth_date),RIGHT(c.ucn, 4 ))),
CASE WHEN c.id % 2 = 0 THEN 'Pilot'
	WHEN c.id % 3 = 0 THEN  'Cook'
    ELSE  'Engineer'
    END,
	c.id,
    LEFT(c.ucn, 1)
FROM colonists AS c
WHERE c.id  BETWEEN 96 AND 100;


# 02. Data Update
UPDATE journeys AS j
SET purpose = 
   CASE 
		WHEN j.id % 2 = 0 THEN 'Medical'
        WHEN j.id % 3 = 0 THEN 'Technical'
        WHEN j.id % 5 = 0 THEN 'Educational'
        WHEN j.id % 7 = 0 THEN 'Military'
 END
 WHERE j.id % 2 = 0 OR j.id % 3 = 0 OR j.id % 5 = 0 OR j.id % 7 = 0;



# 3. Delete
SELECT * FROM colonists AS c
LEFT JOIN travel_cards AS tc
ON c.id = tc.colonist_id

RIGHT JOIN journeys AS j
ON tc.journey_id = j.id;

DELETE FROM colonists
USING
	journeys 
	RIGHT JOIN travel_cards 
	ON journeys.id = travel_cards.colonist_id
	RIGHT JOIN colonists
	ON travel_cards.colonist_id = colonists.id
    WHERE journeys.id IS NULL;

SELECT * FROM journeys 
	RIGHT JOIN travel_cards 
	ON journeys.id = travel_cards.journey_id
	RIGHT JOIN colonists
	ON travel_cards.colonist_id = colonists.id;
   

SELECT * FROM colonists AS c
LEFT JOIN travel_cards AS tc
ON c.id = tc.colonist_id
RIGHT JOIN journeys AS j
ON tc.journey_id = j.id
ORDER BY c.id;

DELETE FROM colonists 
USING
	colonists 
	LEFT JOIN travel_cards 
	ON colonists.id = travel_cards.colonist_id
	LEFT JOIN journeys 
	ON travel_cards.journey_id = journeys.id
	WHERE journeys.id IS NULL;


SELECT * FROM colonists AS c
LEFT JOIN travel_cards AS tc
ON c.id = tc.colonist_id
LEFT JOIN journeys AS j
ON tc.journey_id = j.id;


SELECT * FROM travel_cards AS tc
ORDER BY colonist_id;
SELECT * FROM colonists AS c;
SELECT * FROM journeys AS j;
SELECT * FROM planets AS p;
SELECT * FROM spaceports AS sp;
SELECT * FROM spaceships AS ss;

##################################
# Section 4: Querying – 100 pts
##################################

# 04. Extract all travel cards
SELECT 
    t.card_number, t.job_during_journey
FROM
    travel_cards AS t
ORDER BY t.card_number ASC;

# 05. Extract all travel cards
SELECT 
    c.id,
    CONCAT(c.first_name, ' ', c.last_name) AS `full_name`,
    c.ucn
FROM
    colonists AS c
ORDER BY c.first_name, c.last_name, c.id;

# 06. Extract all military journeys
SELECT 
    j.id, j.journey_start, j.journey_end
FROM
    journeys AS j
WHERE
    j.purpose = 'Military'
ORDER BY j.journey_start ASC;

# 07. Extract all pilots
SELECT c.id, concat(c.first_name, ' ', c.last_name) AS `full_name` FROM colonists AS c
JOIN travel_cards AS tc
ON c.id = tc.colonist_id
WHERE tc.job_during_journey = 'Pilot'
ORDER BY c.id;

# 08. Count all colonists that are on technical journey
SELECT count(c.id) FROM colonists AS c
JOIN travel_cards AS tc
ON c.id = tc.colonist_id
JOIN journeys AS j
ON tc.journey_id = j.id
WHERE j.purpose = 'Technical'
ORDER BY c.id;


# 09. Extract the fastest spaceship
SELECT ss.name, sp.name FROM spaceships AS ss
JOIN journeys AS j
ON ss.id = j.spaceship_id
JOIN spaceports AS sp
ON j.destination_spaceport_id = sp.id
ORDER BY ss.light_speed_rate DESC
LIMIT 1;

# 10. Extract spaceships with pilots younger than 30 years
SELECT ss.name, ss.manufacturer FROM spaceships AS ss
JOIN journeys AS j
ON ss.id = j.spaceship_id
JOIN travel_cards AS tc
ON j.id = tc.journey_id
JOIN colonists AS c
ON tc.colonist_id = c.id
WHERE tc.job_during_journey = 'Pilot'
AND timestampdiff(YEAR, c.birth_date , '2019-01-01' ) < 30
ORDER BY ss.name;

# 11. Extract all educational mission planets and spaceports 
SELECT p.name AS `planet_name`, sp.name AS `spaceport_name` FROM planets AS p
JOIN spaceports AS sp
ON p.id = sp.planet_id
JOIN journeys AS j
ON sp.id = j.destination_spaceport_id
WHERE j.purpose = 'Educational'
ORDER BY `spaceport_name` DESC;

# 12. Extract all planets and their journey count
SELECT p.name, count(j.id) AS `journeys_count` FROM planets AS p
JOIN spaceports AS sp
ON p.id = sp.planet_id
JOIN journeys AS j
ON sp.id = j.destination_spaceport_id
GROUP BY p.id
ORDER BY `journeys_count` DESC, p.name ASC;

# 13. Extract the shortest journey
SELECT 
    j.id,
    p.name AS `planet_name`,
    sp.name AS `spaceport_name`,
    j.purpose AS `journey_purpose`
FROM
    journeys AS j
        JOIN
    spaceports AS sp ON j.destination_spaceport_id = sp.id
        JOIN
    planets AS p ON sp.planet_id = p.id
        JOIN
    (SELECT 
        j.id,
            TIMESTAMPDIFF(SECOND, j.journey_start, j.journey_end) AS `time`
    FROM
        journeys AS j
    ORDER BY `time` ASC
    LIMIT 1) AS `shortest journey` ON `shortest journey`.id = j.id;

# 14. Extract the less popular job
SELECT 
    `longest journey`.`job_name`
FROM
    journeys AS j
        JOIN
    spaceports AS sp ON j.destination_spaceport_id = sp.id
        JOIN
    planets AS p ON sp.planet_id = p.id
        JOIN
    (SELECT 
        j.id, tc.job_during_journey AS `job_name`, count(c.id) AS `jobs_count`,
            TIMESTAMPDIFF(SECOND, j.journey_start, j.journey_end) AS `time`
    FROM
        journeys AS j
        JOIN travel_cards AS tc
		ON j.id = tc.journey_id
        JOIN colonists AS c
        ON c.id = tc.colonist_id
        GROUP BY (j.id)
        ORDER BY `time` DESC, `jobs_count` ASC
        LIMIT 1
    ) AS `longest journey` ON `longest journey`.id = j.id;
    

######################################
# Section 4: Programmability – 30 pts
######################################


# 15. Get colonists count
DROP FUNCTION IF EXISTS udf_count_colonists_by_destination_planet;

DELIMITER $$
CREATE FUNCTION udf_count_colonists_by_destination_planet (planet_name VARCHAR (30))
RETURNS INT(11)
BEGIN
	DECLARE result INT(11);
	SET result := (SELECT count(c.id) FROM planets AS p
			LEFT JOIN spaceports AS sp
			ON p.id = sp.planet_id
			LEFT JOIN journeys AS j
			ON sp.id = j.destination_spaceport_id
			LEFT JOIN travel_cards AS tc
			ON j.id = tc.journey_id
			LEFT JOIN colonists AS c
			ON tc.colonist_id = c.id
            WHERE p.name = planet_name
			GROUP BY p.name);
    RETURN result;
END $$

DELIMITER ;

SELECT p.name,  count(c.id) FROM planets AS p
			LEFT JOIN spaceports AS sp
			ON p.id = sp.planet_id
			LEFT JOIN journeys AS j
			ON sp.id = j.destination_spaceport_id
			LEFT JOIN travel_cards AS tc
			ON j.id = tc.journey_id
			LEFT JOIN colonists AS c
			ON tc.colonist_id = c.id
            #WHERE p.name = 'Otroyphus'
			GROUP BY p.name;

SELECT p.name, udf_count_colonists_by_destination_planet('Otroyphus') AS count
FROM planets AS p
WHERE p.name = 'Otroyphus';

# 16. Modify spaceship
DROP PROCEDURE IF EXISTS udp_modify_spaceship_light_speed_rate;

DELIMITER $$
CREATE PROCEDURE udp_modify_spaceship_light_speed_rate(spaceship_name VARCHAR(50), light_speed_rate_increse INT(11))
BEGIN
	DECLARE result INT(11);
    SET result := (SELECT ss.light_speed_rate FROM spaceships AS ss
WHERE 				ss.name = spaceship_name) + light_speed_rate_increse;
	START TRANSACTION;
    IF 1 != (SELECT COUNT(*) FROM spaceships AS ss
		 WHERE ss.name = spaceship_name) THEN
		 SIGNAL SQLSTATE '45000'
		 SET MESSAGE_TEXT = "Spaceship you are trying to modify does not exists.";
		 ROLLBACK;
     ELSE
		UPDATE spaceships
		SET spaceships.light_speed_rate = result
		WHERE spaceships.name = spaceship_name;
		COMMIT;
    END IF;
END $$

DELIMITER ;

DELIMITER $$
CREATE PROCEDURE udp_modify_spaceship_light_speed_rate(spaceship_name VARCHAR(50), light_speed_rate_increse INT(11))
BEGIN
	DECLARE result INT(11);
    SET result := (SELECT ss.light_speed_rate FROM spaceships AS ss
WHERE 				ss.name = spaceship_name) + light_speed_rate_increse;
    IF 1 != (SELECT COUNT(*) FROM spaceships AS ss
		 WHERE ss.name = spaceship_name) THEN
		 SIGNAL SQLSTATE '45000'
		 SET MESSAGE_TEXT = "Spaceship you are trying to modify does not exists.";
		
     END IF;
		UPDATE spaceships
		SET spaceships.light_speed_rate = result
		WHERE spaceships.name = spaceship_name;
		COMMIT;
    
END $$

DELIMITER ;


CALL udp_modify_spaceship_light_speed_rate ('Na Pesho koraba', 1914);
SELECT name, light_speed_rate FROM spacheships WHERE name = 'Na Pesho koraba';

CALL udp_modify_spaceship_light_speed_rate ('USS Templar', 5);
SELECT name, light_speed_rate FROM spaceships WHERE name = 'USS Templar';


SELECT ss.light_speed_rate FROM spaceships AS ss;
#WHERE ss.name = 'Na Pesho koraba';





















