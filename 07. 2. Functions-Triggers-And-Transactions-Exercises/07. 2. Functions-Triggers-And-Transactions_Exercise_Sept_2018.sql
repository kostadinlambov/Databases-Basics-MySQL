USE soft_uni;

# Problem 1:	Employees with Salary Above 35000
DROP PROCEDURE IF EXISTS usp_get_employees_salary_above_35000,

DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above_35000() 
BEGIN
SELECT e.first_name, e.last_name FROM employees AS e
WHERE e.salary > 35000
ORDER BY e.first_name, e.last_name, e.employee_id; 
END $$

DELIMITER ;

CALL usp_get_employees_salary_above_35000();

SELECT e.first_name, e.last_name FROM employees AS e
WHERE e.salary > 3500
ORDER BY e.first_name, e.last_name ASC, e.employee_id ASC; 

# Problem 2:	Employees with Salary Above Number
DROP PROCEDURE IF EXISTS usp_get_employees_salary_above;

DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above(limit_salary DECIMAL(19, 4))
BEGIN
SELECT e.first_name, e.last_name FROM employees AS e
WHERE e.salary >= limit_salary
ORDER BY e.first_name ASC, e.last_name ASC;
END $$

DELIMITER ;

CALL usp_get_employees_salary_above(48100);

# Problem 3:	Town Names Starting With
DROP PROCEDURE IF EXISTS usp_get_towns_starting_with;
DROP PROCEDURE IF EXISTS usp_get_towns_starting_with2;

DELIMITER $$
CREATE PROCEDURE usp_get_towns_starting_with(starts_with_string VARCHAR(50))
BEGIN
  SELECT t.name FROM towns AS t
  WHERE t.name LIKE CONCAT(starts_with_string, '%')
  ORDER BY t.name;
END$$

DELIMITER $$
CREATE PROCEDURE usp_get_towns_starting_with2(str CHAR(10))
BEGIN
	SELECT t.name FROM towns AS t
	WHERE SUBSTRING(t.name, 1, char_length(str)) = str
    ORDER BY t.name;
END$$


DELIMITER ;

CALL usp_get_towns_starting_with('b');
CALL usp_get_towns_starting_with2('b');

 SELECT t.name FROM towns AS t
  WHERE t.name LIKE CONCAT('b', '%')
  ORDER BY t.name;

# Problem 4:	Employees from Town
DROP PROCEDURE IF EXISTS usp_get_employees_from_town;

DELIMITER $$
CREATE PROCEDURE usp_get_employees_from_town(town_name VARCHAR(50))
BEGIN
SELECT e.first_name, e.last_name FROM employees AS e
JOIN addresses AS a
ON e.address_id = a.address_id
JOIN towns AS t
ON a.town_id= t.town_id
WHERE t.name = town_name
ORDER BY e.first_name, e.last_name;
END $$

DELIMITER ;
CALL usp_get_employees_from_town('Sofia');

# Problem 5:	Salary Level Function
DROP FUNCTION IF EXISTS ufn_get_salary_level;

DELIMITER $$
CREATE FUNCTION ufn_get_salary_level(empl_salary DECIMAL(19, 4))
RETURNS VARCHAR(10) 
BEGIN
	DECLARE result VARCHAR(10);
    IF empl_salary < 30000 THEN
    SET result := 'Low';
    ELSEIF empl_salary BETWEEN 30000 AND 50000 THEN
    SET result := 'Average';
    ELSEIF  empl_salary > 50000 THEN
    SET result := 'High';
    END IF;
	RETURN result;
END $$

DELIMITER ;

SELECT 
    e.first_name,
    e.last_name,
    e.salary,
    UFN_GET_SALARY_LEVEL(e.salary) AS `salary_level`
FROM
    employees AS e;

# Problem 6:	Employees by Salary Level
DROP PROCEDURE IF EXISTS usp_get_employees_by_salary_level;

DELIMITER $$
CREATE PROCEDURE usp_get_employees_by_salary_level(level_of_salary VARCHAR(10))
BEGIN
SELECT 
    e.first_name, e.last_name
FROM
    employees AS e
        JOIN
    (SELECT 
        e.employee_id, 
        e.salary,
        (CASE 
        WHEN e.salary < 30000 THEN 'low'
        WHEN e.salary BETWEEN 30000 AND 50000 THEN 'average'
        WHEN e.salary > 50000 THEN 'high'
        END) AS `salary_level`
		FROM employees AS e) AS `sl`
	ON e.employee_id = `sl`.employee_id
    WHERE level_of_salary = `sl`.`salary_level`
    ORDER BY e.first_name DESC, e.last_name DESC;
END $$

DELIMITER ;

CALL usp_get_employees_by_salary_level('low');
CALL usp_get_employees_by_salary_level('Average');
CALL usp_get_employees_by_salary_level('high');

# Problem 7:	Define Function
DROP FUNCTION IF EXISTS ufn_is_word_comprised;

DELIMITER $$
CREATE FUNCTION ufn_is_word_comprised(set_of_letters VARCHAR(50), word VARCHAR(200))
RETURNS BIT
BEGIN 
	DECLARE word_length INT DEFAULT CHAR_LENGTH(word);
    DECLARE idx INT DEFAULT 1;
    
    WHILE idx <= word_length
    DO
    IF LOCATE(SUBSTRING(word, idx, 1), set_of_letters) < 1
    THEN
    RETURN FALSE;
    END IF;
    SET idx = idx +1;
    END WHILE;
    RETURN TRUE;
END $$

DELIMITER ;

SELECT ufn_is_word_comprised('oistmiahf', 'Sofia');
SELECT ufn_is_word_comprised('oistmiahf', 'halves');
SELECT ufn_is_word_comprised('pppp', 'Guy');
SELECT ufn_is_word_comprised('bobr', 'Rob');
SELECT ufn_is_word_comprised('a', 'abv');


# Problem 7 with Regexp

DELIMITER $$
CREATE FUNCTION ufn_is_word_comprised(set_of_letters varchar(50), word varchar(50))
  RETURNS BIT
  BEGIN
    RETURN word REGEXP (concat('^[', set_of_letters, ']+$'));
  END$$

DELIMITER ;

SELECT * FROM towns;
SELECT * FROM employees AS e;

########################################
USE bank_db;
########################################

# Problem 8: Find Full Name
DROP PROCEDURE IF EXISTS usp_get_holders_full_name;

DELIMITER $$
CREATE PROCEDURE usp_get_holders_full_name()
BEGIN
	SELECT concat(ah.first_name, ' ', ah.last_name) AS `full_name` FROM account_holders AS ah
    ORDER BY `full_name`;
END $$

DELIMITER ;

CALL usp_get_holders_full_name;

# Problem 9:	People with Balance Higher Than
DROP PROCEDURE IF EXISTS usp_get_holders_with_balance_higher_than;

DELIMITER $$

CREATE PROCEDURE usp_get_holders_with_balance_higher_than(limit_salary DECIMAL(19, 4))
BEGIN
	SELECT ah.first_name, ah.last_name FROM account_holders AS ah
	JOIN accounts AS a
	ON ah.id = a.account_holder_id
	GROUP BY ah.id
	HAVING sum(a.balance) > limit_salary
	ORDER BY a.id, ah.first_name, ah.last_name;
END $$

DELIMITER ;

CALL usp_get_holders_with_balance_higher_than(7000);

# Problem 10: Future Value Function
DROP FUNCTION IF EXISTS ufn_calculate_future_value;

DELIMITER $$

CREATE FUNCTION ufn_calculate_future_value(initial_sum DECIMAL(19, 4), yearly_interest_rate DOUBLE , number_of_years INT(11))
RETURNS DOUBLE
BEGIN
	DECLARE fv DOUBLE;
    SET fv := initial_sum * ( POW((1 + yearly_interest_rate), number_of_years));
	RETURN fv;
END $$

DELIMITER ;

SELECT ufn_calculate_future_value(1000, 0.1, 5);

#Problem 11: Calculating Interest
DROP PROCEDURE IF EXISTS usp_calculate_future_value_for_account;

DELIMITER $$

CREATE PROCEDURE usp_calculate_future_value_for_account(account_id INT(11), yearly_interest_rate DECIMAL(19, 4))
BEGIN 

SELECT 
    a.id AS `account_id`,
    ah.first_name, 
    ah.last_name, 
    a.balance AS `current_balance`,
    ufn_calculate_future_value(a.balance, yearly_interest_rate, 5) AS `balance_in_5_years`
FROM
    account_holders AS ah
    JOIN accounts AS a
    ON ah.id = a.account_holder_id
    WHERE a.id = account_id;

END $$

DELIMITER ;

CALL usp_calculate_future_value_for_account(1, 0.1);

SELECT 
    a.id AS `account_id`,
    ah.first_name, 
    ah.last_name, 
    a.balance AS `current_balance`,
    ufn_calculate_future_value(a.balance, 0.1, 5) AS `balance_in_5_years`
FROM
    account_holders AS ah
    JOIN accounts AS a
    ON ah.id = a.account_holder_id;


# Problem 12: Deposit Money
DROP PROCEDURE IF EXISTS usp_deposit_money;

DELIMITER $$
CREATE PROCEDURE usp_deposit_money (account_id INT, money_amount DECIMAL)
BEGIN
    START TRANSACTION;
    UPDATE accounts AS ac
    SET ac.balance = ac.balance + money_amount
    WHERE ac.id = account_id;
    IF (
    SELECT a.balance
    FROM accounts as a
    WHERE a.id = account_id
    ) >= 0 THEN
    COMMIT;
    ELSE
    rollback;
    END IF;
END$$

DELIMITER ;

CALL usp_deposit_money(1, 10.00);


# Problem 13:	Withdraw Money
DROP PROCEDURE IF EXISTS usp_withdraw_money;

DELIMITER $$

CREATE PROCEDURE usp_withdraw_money(account_id INT(11), money_amount DECIMAL(19, 4))
BEGIN

	DECLARE new_balance DECIMAL(19, 4);
	IF money_amount > 0 THEN
		START TRANSACTION;
		
		UPDATE accounts
		SET balance = balance - money_amount
		WHERE id = account_id;
		

		SET new_balance := (SELECT a.balance FROM accounts AS a
							WHERE id = account_id);
		
		IF(new_balance < 0) THEN 
			ROLLBACK;
		ELSE
			COMMIT;
		END IF;
    END IF;
END $$

DELIMITER ;

CALL usp_withdraw_money(1, 10);



# Problem 14: Money Transfer

DROP PROCEDURE IF EXISTS usp_transfer_money;

DELIMITER $$
CREATE PROCEDURE usp_transfer_money(from_account_id INT(11), to_account_id INT(11), amount DECIMAL(19, 4))
BEGIN
	DECLARE first_account_id_check BIT;
    DECLARE second_account_id_check BIT;
	DECLARE outgoing_balance_from DECIMAL(19, 4);
    DECLARE outgoing_balance_to DECIMAL(19, 4);
    IF amount > 0 THEN
		START TRANSACTION;
        
        UPDATE accounts
        SET balance = balance - amount
        WHERE id = from_account_id;
        
        UPDATE accounts
        SET balance = balance + amount
        WHERE id = to_account_id;
        
        SET outgoing_balance_from := (SELECT a.balance FROM accounts AS a WHERE id = from_account_id);
		SET outgoing_balance_to := (SELECT a.balance FROM accounts AS a WHERE id = to_account_id);
        SET first_account_id_check := ((SELECT count(*) FROM accounts AS a WHERE id = from_account_id) <> 1);
        SET second_account_id_check := ((SELECT count(*) FROM accounts AS a WHERE id = to_account_id) <> 1);
        
		IF( outgoing_balance_from < 0 OR outgoing_balance_to < 0 OR first_account_id_check OR second_account_id_check)
		THEN
			ROLLBACK;
        ELSE 
			COMMIT;
		END IF;
	END IF;
END $$

DELIMITER ;

CALL usp_transfer_money(1, 2, 150);

SELECT * FROM account_holders AS ah;
SELECT * FROM accounts AS a;

# Problem 15. Log Accounts Trigger
DROP TABLE IF EXISTS logs;

CREATE TABLE logs(
log_id int(11) PRIMARY KEY AUTO_INCREMENT,
account_id INT(11),
old_sum DECIMAL (19, 4),
new_sum DECIMAL (19, 4)
);

DROP TRIGGER IF EXISTS tr_logs;

DELIMITER $$

CREATE TRIGGER tr_logs
AFTER UPDATE
ON accounts
FOR EACH ROW
BEGIN
	INSERT INTO logs(account_id, old_sum, new_sum)
    VALUES (OLD.id, OLD.balance, NEW.balance);
END $$

DELIMITER ;

UPDATE accounts
SET balance = balance - 10
WHERE id = 1;

SELECT * FROM logs;

# Problem 16: Emails Trigger
DROP TABLE IF EXISTS logs;
DROP TABLE IF EXISTS notification_emails;
DROP TRIGGER IF EXISTS tr_emails;

CREATE TABLE logs(
	log_id INT AUTO_INCREMENT PRIMARY KEY,
	account_id INT,
	old_sum DECIMAL(19, 4),
	new_sum DECIMAL(19, 4)
);
CREATE TABLE notification_emails(
	id INT AUTO_INCREMENT PRIMARY KEY,
	recipient INT,
	subject VARCHAR(50),
	body TEXT
);

DELIMITER $$
CREATE TRIGGER tr_emails
AFTER UPDATE
ON accounts
FOR EACH ROW 
BEGIN
	INSERT INTO logs(account_id, old_sum, new_sum)
	VALUES(old.id, old.balance, new.balance);
	INSERT INTO notification_emails(recipient, subject, body)
	VALUES(
		old.id,
		CONCAT_WS(': ', 'Balance change for account', old.id),
		CONCAT('On ', NOW(), ' your balance was changed from ', old.balance, ' to ', new.balance, '.' ));
END$$

DELIMITER ;
 
UPDATE accounts
SET balance = balance + 10
WHERE id = 1;

SELECT * FROM logs;
SELECT *FROM notification_emails;





