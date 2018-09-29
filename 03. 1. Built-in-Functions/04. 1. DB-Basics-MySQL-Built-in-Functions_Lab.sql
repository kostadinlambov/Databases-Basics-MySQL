USE book_library;

#Problem 1.	Find Book Titles
SELECT `title` FROM `books`
WHERE `title` LIKE 'The%'
ORDER BY `id`;

#Problem 2.	Replace Titles
SELECT REPLACE (`title`, 'The', '***') FROM `books`
WHERE `title` LIKE 'The%' 
ORDER BY `id`;

#Problem 3.	Sum Cost of All Books
SELECT ROUND(SUM(`cost`), 2) AS 'Total Sum' FROM `books`;

#Problem 4.	Days Lived
SELECT 
	CONCAT_WS(' ', `first_name`, `last_name`) AS 'Full Name',
	TIMESTAMPDIFF(day, `born`, `died`) AS 'Days Lived'
FROM `authors`;

#Problem 5.	Harry Potter Books
SELECT `title` FROM `books`
WHERE `title` LIKE '%Harry Potter%'
ORDER BY `id` ASC;

