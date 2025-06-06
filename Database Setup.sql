-- NETFLIX Project Begin
CREATE TABLE netflix 
(
	show_id 	VARCHAR (6),
	type		VARCHAR(10),
	title		VARCHAR (150),
	director 	VARCHAR(250),
	casts 		VARCHAR(1000),
	country		VARCHAR(150),
	date_added	VARCHAR(50),
	release_year 		INT,	
	rating 		VARCHAR(10),
	duration	VARCHAR(15),
	listed_in	VARCHAR(100),
	description VARCHAR(250)
);

-- Verifying table
SELECT * FROM netflix;

-- Verifying columns (result: 8807 columns)
SELECT 
	COUNT(*) AS total_content 
FROM netflix;

