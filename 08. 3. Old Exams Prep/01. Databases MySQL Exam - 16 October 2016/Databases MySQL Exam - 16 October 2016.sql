
DROP DATABASE IF EXISTS airport_ms_db;
CREATE DATABASE airport_ms_db;
USE airport_ms_db;

#####################################################
# Section 1: Data Definition Language (DDL) – 40 pts
#####################################################

CREATE TABLE towns(
town_id INT(11) PRIMARY KEY,
town_name VARCHAR(30) NOT NULL
);

CREATE TABLE airports(
airport_id INT(11) PRIMARY KEY,
airport_name VARCHAR(50) NOT NULL,
town_id INT(11)
);

CREATE TABLE airlines(
airline_id INT(11) PRIMARY KEY,
airline_name VARCHAR(30) NOT NULL,
nationality VARCHAR(30) NOT NULL,
rating INT(11) DEFAULT 0
);

CREATE TABLE customers(
customer_id INT(11) PRIMARY KEY,
first_name VARCHAR(20) NOT NULL,
last_name VARCHAR(20) NOT NULL,
date_of_birth DATE NOT NULL,
gender VARCHAR(1),
#gender ENUM('M','F'),
home_town_id INT(11)
);

CREATE TABLE flights(
flight_id INT(11) PRIMARY KEY AUTO_INCREMENT,
departure_time DATETIME NOT NULL,
arrival_time DATETIME NOT NULL,
status VARCHAR(9),
#status ENUM('Departing','Delayed','Arrived', 'Cancelled'),
origin_airport_id INT(11),
destination_airport_id INT(11),
airline_id INT(11)
);

CREATE TABLE tickets(
ticket_id INT(11) PRIMARY KEY AUTO_INCREMENT,
price DECIMAL(8,2) NOT NULL,
class VARCHAR(6),
#class ENUM('First','Second','Third'),
seat VARCHAR(5) NOT NULL,
customer_id INT(11),
flight_id INT(11)
);

ALTER TABLE airports
ADD CONSTRAINT fk_airports_towns FOREIGN KEY(town_id)
REFERENCES towns(town_id);

ALTER TABLE customers
ADD CONSTRAINT fk_customers_towns FOREIGN KEY(home_town_id)
REFERENCES towns(town_id);

ALTER TABLE flights
ADD CONSTRAINT fk_flights_airports FOREIGN KEY(origin_airport_id)
REFERENCES airports(airport_id);

ALTER TABLE flights
ADD CONSTRAINT fk_flights_airports_destination FOREIGN KEY(destination_airport_id)
REFERENCES airports(airport_id);

ALTER TABLE flights
ADD CONSTRAINT fk_flights_airlines FOREIGN KEY(airline_id)
REFERENCES airlines(airline_id);

ALTER TABLE tickets
ADD CONSTRAINT fk_tickets_customers FOREIGN KEY(customer_id)
REFERENCES customers(customer_id);

ALTER TABLE tickets
ADD CONSTRAINT fk_tickets_flights FOREIGN KEY(flight_id)
REFERENCES flights(flight_id);

######################################################
# Section 4 and Section 5: Tables
######################################################

CREATE TABLE customer_reviews(
	review_id INT AUTO_INCREMENT,
	review_content VARCHAR(255) NOT NULL,
	review_grade INT NOT NULL,
	airline_id INT,
	customer_id INT,
	CONSTRAINT pk_customer_reviews PRIMARY KEY(review_id),
	CONSTRAINT fk_customer_reviews_airlines FOREIGN KEY(airline_id) REFERENCES airlines(airline_id),
	CONSTRAINT fk_customer_reviews_customers FOREIGN KEY(customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE customer_bank_accounts(
	account_id INT AUTO_INCREMENT,
	account_number VARCHAR(10) UNIQUE NOT NULL,
	balance DECIMAL(10, 2) NOT NULL,
	customer_id INT,
	CONSTRAINT pk_customer_bank_accounts PRIMARY KEY(account_id),
	CONSTRAINT fk_customer_bank_accounts_customers FOREIGN KEY(customer_id) REFERENCES customers(customer_id)
);


CREATE TABLE arrived_flights(
	flight_id INT,
	arrival_time DATETIME,
	origin VARCHAR(50),
	destination VARCHAR(50),
	passengers INT,
	CONSTRAINT PK_arrived_flights PRIMARY KEY(flight_id)
);


######################################################
# Section 2: Data Manipulation Language (DML) – 30 pts
######################################################
USE airport_ms_db;

# 02. Data Insertion
INSERT INTO flights(departure_time, arrival_time, status, origin_airport_id,destination_airport_id, airline_id )
SELECT 
	'2017-06-19 14:00:00',
    '2017-06-21 11:00:00',
     CASE 
		WHEN mod(al.airline_id,4) = 0 THEN 'Departing'
        WHEN mod(al.airline_id,4) = 1 THEN 'Delayed'
        WHEN mod(al.airline_id,4) = 2 THEN 'Arrived'
        WHEN mod(al.airline_id,4) = 3 THEN 'Canceled'
    END,
    ceil(sqrt(char_length(al.airline_name))),
    ceil(sqrt(char_length(al.nationality))),
    al.airline_id
FROM airlines AS al
WHERE al.airline_id BETWEEN 1 AND 10;

# 03. Update Arrived Flights
UPDATE flights
SET airline_id = 1
WHERE status = 'Arrived';

# 04. Update Tickets
UPDATE flights as f
JOIN airlines as al
	ON  f.airline_id = al.airline_id
JOIN 
	(
    SELECT al.airline_id, MAX(al.rating) AS `max_rating` FROM airlines AS al
    GROUP BY al.airline_id
    ) AS `max_rated_airline`
	ON f.airline_id = `max_rated_airline`.airline_id
JOIN tickets AS t
	ON f.flight_id = t.flight_id
SET t.price = t.price * 1.5
WHERE rating = `max_rated_airline`.`max_rating`;


##################################
# Section 3: Querying – 100 pts
##################################

# 05. Tickets
SELECT t.ticket_id, t.price, t.class, t.seat FROM tickets as t;

# 06. Customers
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS `full_name`,
    c.gender
FROM
    customers AS c
ORDER BY `full_name` ASC, c.customer_id ASC;

# 07. Flights
SELECT 
    f.flight_id, f.departure_time, f.arrival_time
FROM
    flights AS f
WHERE f.status = 'Delayed'
ORDER BY f.flight_id;

# 08. Top 5 Airlines
SELECT 
    al.airline_id, al.airline_name, al.nationality, al.rating
FROM
    airlines AS al
JOIN flights AS f
ON al.airline_id = f.airline_id
GROUP BY airline_id
ORDER BY al.rating DESC, al.airline_id
LIMIT 5;

# 09. ‘First Class’ Tickets
SELECT 
    t.ticket_id,
    ar.airport_name,
    CONCAT(c.first_name, ' ', c.last_name) AS `customer_name`
FROM
    tickets AS t
        JOIN
    customers AS c ON t.customer_id = c.customer_id
        JOIN
    flights AS f ON t.flight_id = f.flight_id
        JOIN
    airports AS ar ON f.destination_airport_id = ar.airport_id
WHERE
    t.price < 5000 AND t.class = 'First'
ORDER BY t.ticket_id;

# 10. Home Town Customers
SELECT 
    c.customer_id, 
    CONCAT(c.first_name, ' ', c.last_name) AS `full_name`, 
    tn.town_name
FROM
    customers AS c
        JOIN
    tickets AS t ON c.customer_id = t.customer_id
        JOIN
	flights AS f ON t.flight_id = f.flight_id
       JOIN  
    airports AS ar ON f.origin_airport_id = ar.airport_id
      JOIN  
    towns AS tn ON c.home_town_id = tn.town_id
     WHERE ar.town_id = c.home_town_id AND f.status = 'Departing'
     GROUP BY tn.town_name
     ORDER BY c.customer_id;

# 11. Flying Customers
SELECT DISTINCT
	c.customer_id, 
	CONCAT(c.first_name, ' ', c.last_name) AS `full_name`,
	TIMESTAMPDIFF(year, c.date_of_birth, '2016-12-31') AS `age`
FROM customers as c
JOIN tickets as t
ON  t.customer_id = c.customer_id
JOIN flights AS f
ON t.flight_id = f.flight_id
WHERE f.status = 'Departing'
ORDER BY `age` ASC, c.customer_id ASC ;

# 12. Delayed Customers
SELECT 
	c.customer_id, 
	CONCAT(c.first_name, ' ', c.last_name) AS `full_name`,
	t.price,
    ap.airport_name
FROM customers as c
JOIN tickets as t
ON  t.customer_id = c.customer_id
JOIN flights AS f
ON t.flight_id = f.flight_id
JOIN airports AS ap
ON f.destination_airport_id = ap.airport_id
JOIN towns AS tn
ON ap.town_id = tn.town_id
WHERE f.status = 'Delayed'
ORDER BY  t.price DESC, c.customer_id ASC
LIMIT 3;

# 13. Last Departing Flights
SELECT * FROM 
		(SELECT 
			f.flight_id, 
			f.departure_time, 
			f.arrival_time, 
			(SELECT ap3.airport_name FROM  airports AS ap3 WHERE ap3.airport_id = f.origin_airport_id )  `origin`,
			(SELECT ap3.airport_name FROM  airports AS ap3 WHERE ap3.airport_id = f.destination_airport_id )  `destination`
		FROM
			flights AS f
		WHERE status = 'Departing'
		ORDER BY f.departure_time DESC, f.flight_id ASC
		LIMIT 5) AS `cq`
ORDER BY `cq`.departure_time;

# 14. Flying Children
SELECT DISTINCT
	c.customer_id, 
	CONCAT(c.first_name, ' ', c.last_name) AS `full_name`,
	TIMESTAMPDIFF(year, c.date_of_birth, '2016-12-31') AS `age`
FROM customers as c
JOIN tickets as t
ON  t.customer_id = c.customer_id
JOIN flights AS f
ON t.flight_id = f.flight_id
WHERE f.status = 'Arrived' AND TIMESTAMPDIFF(year, c.date_of_birth, '2016-12-31') < 21
ORDER BY `age` DESC, c.customer_id ASC;

# 15. Airports and Passengers
SELECT ap.airport_id,  ap.airport_name, COUNT(t.ticket_id) FROM airports as ap
JOIN flights AS f
	ON  f.origin_airport_id  = ap.airport_id
JOIN tickets AS t
	ON t.flight_id = f.flight_id
WHERE f.status = 'Departing'
GROUP BY ap.airport_name
ORDER BY ap.airport_id;


######################################
# Section 4: Programmability – ... pts
######################################

# 16. Submit Review

DROP PROCEDURE IF EXISTS udp_submit_review;

DELIMITER $$
CREATE PROCEDURE udp_submit_review(
		customer_id int(11), 
        review_content VARCHAR(255), 
        review_grade int(11), 
        airline_name VARCHAR(30))
BEGIN
	DECLARE airline_id INT(11);

	SET airline_id := (SELECT a.airline_id FROM airlines AS a WHERE a.airline_name = airline_name);

    IF 1 != (SELECT COUNT(*) FROM airlines WHERE airlines.airline_id = airline_id) THEN
     SIGNAL SQLSTATE '45000'
	 SET MESSAGE_TEXT = 'Airline does not exist.';
    END IF;

    INSERT INTO customer_reviews(review_content, review_grade, airline_id, customer_id)
    VALUES(review_content, review_grade, airline_id, customer_id);
    
END $$

DELIMITER ;

SELECT * FROM customer_reviews as cr;

CALL udp_submit_review(
 1,
 'ajmISQi*',
 20,
 'Putin Air' 
 );

CALL udp_submit_review(
 1,
 'ajmISQi*',
 20,
 'Kebab Air' 
 );

# 17. Purchase Ticket
DROP PROCEDURE IF EXISTS udp_purchase_ticket;

DELIMITER $$

CREATE PROCEDURE udp_purchase_ticket(
		customer_id int(11), 
        flight_id int(11), 
        ticket_price DECIMAL(8, 2), 
        class VARCHAR(6),
        seat VARCHAR(5) )
BEGIN
	DECLARE balance DECIMAL(10, 2);
	SET balance := (SELECT cba.balance FROM customer_bank_accounts as cba WHERE cba.customer_id = customer_id);

	START TRANSACTION;

	IF (ticket_price > balance) THEN
		 SIGNAL SQLSTATE '45000'
		 SET MESSAGE_TEXT = 'Insufficient bank account balance for ticket purchase.';
		 ROLLBACK;
	ELSE 
		INSERT INTO tickets(price, class, seat, customer_id,flight_id )
		VALUES(ticket_price, class, seat, customer_id,flight_id );
		
		UPDATE customer_bank_accounts
		SET balance = balance - ticket_price
		WHERE customer_bank_accounts.customer_id = customer_id;
		COMMIT;
    END IF;
END $$

DELIMITER ;

SELECT * FROM customer_bank_accounts as cba;

#CALL udp_purchase_ticket();

######################################
# Section 5: Bonus – ... pts
######################################
# 18. Update Trigger -  - Pct;
DROP TRIGGER IF EXISTS tr_fligths;

DELIMITER $$
CREATE TRIGGER t_updated_arrivals
BEFORE UPDATE ON flights
FOR EACH ROW
BEGIN
    DECLARE passengers INT;
    DECLARE origin VARCHAR(50);
    DECLARE destination VARCHAR(50);
    SET passengers := (SELECT COUNT(t.ticket_id) FROM tickets AS t
    INNER JOIN flights AS f ON t.flight_id = new.flight_id AND f.flight_id = new.flight_id);
   
    SET origin := (SELECT airport_name FROM airports AS a
        where new.origin_airport_id = a.airport_id);
 
    SET destination := (SELECT airport_name FROM airports AS a
        where new.destination_airport_id = a.airport_id);
 
    IF(old.`status` = 'Departing' OR old.`status` = 'Delayed') THEN
        INSERT INTO arrived_flights(flight_id, arrival_time,origin, destination, passengers) 
        VALUES (new.flight_id, new.arrival_time, origin, destination, passengers);
    END IF;
END $$

DELIMITER ;

UPDATE flights
SET status = 'Arrived'
WHERE flight_id = 2;

TRUNCATE TABLE arrived_flights;
SELECT * FROM arrived_flights as ar;