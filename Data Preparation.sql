-- Data Preparation

-- Identified anomalies where some shows had their duration entered in the rating column, leaving the duration column null.
-- Fixing anomaly 1
SELECT * FROM netflix; WHERE rating = '74 min';

-- updating the rating
UPDATE netflix 
	SET rating = 'TV-MA'
	WHERE show_id = 's5542';

-- updating the duration
UPDATE netflix 
	SET duration = '74 min'
	WHERE show_id = 's5542';

-- Fixing anomaly 2
SELECT * FROM netflix WHERE rating = '66 min';

-- updating the rating
UPDATE netflix 
	SET rating = 'TV-MA'
	WHERE show_id = 's5814';

-- updating the duration
UPDATE netflix 
	SET duration = '66 min'
	WHERE show_id = 's5814';

-- Fixing anomaly 3
SELECT * FROM netflix WHERE rating = '84 min';

-- updating the rating
UPDATE netflix 
	SET rating = 'TV-MA'
	WHERE show_id = 's5795';

-- updating the duration
UPDATE netflix 
	SET duration = '82 min'
	WHERE show_id = 's5795';
	
-- Checking NULL ratings value
SELECT * FROM netflix WHERE rating IS NULL;

-- Updating to unknown
UPDATE netflix 
	SET rating = 'Unknown'
	WHERE rating IS NULL;
	
-- Checking NULL values in director column
SELECT 
	director 
FROM netflix
WHERE director IS NULL;

-- Updating NULL values to 'Unknown'
UPDATE netflix 
SET director = 'Unknown'
WHERE director IS NULL;


-- Normalized the Netflix table into movies and shows: movies have duration in minutes but in VARCHAR, 
-- and shows in seasons. Addressing null durations and correcting incorrect data types.

-- Making two new tables from original table

CREATE TABLE movies AS
SELECT show_id, type, title, director, casts, country, date_added, release_year, rating, duration, listed_in, description
FROM netflix
WHERE type = 'Movie';

CREATE TABLE shows AS
SELECT show_id, type, title, director, casts, country, date_added, release_year, rating, seasons, listed_in, description
FROM netflix
WHERE type = 'shows';

-- Adding new coloumn and changing duration to TIME format
ALTER TABLE movies
	ADD COLUMN duration_in_min TIME;

UPDATE movies
SET duration_in_min = 
    TO_CHAR(
        (INTERVAL '1 minute' * CAST(SUBSTRING(duration FROM '^[0-9]+') AS INT)), 
        'HH24:MI:SS'
    )::TIME;

-- Replacing old with new
alter table movies
DROP COLUMN duration;


-- Adding new coloumn and changing duration to seasons
ALTER TABLE shows
ADD COLUMN seasons INT;

UPDATE shows
SET seasons = CAST(REGEXP_REPLACE(duration, '[^\d]', '', 'g') AS INT);

ALTER TABLE shows
drop column duration;

-- Converting date_added to datetime 
-- movies

SELECT * FROM movies;

SELECT DISTINCT(date_added)
FROM movies;

-- converting string written as dd-mmm-yy

ALTER TABLE movies
ADD COLUMN date_added_datetime DATE;

UPDATE movies
SET date_added_datetime = TO_DATE(date_added, 'DD-Mon-YY');

ALTER TABLE movies
DROP column date_added;

ALTER TABLE movies
RENAME COLUMN date_added_datetime TO date_added;

-- Converting date_added to datetime 
-- shows

SELECT * FROM shows;

SELECT DISTINCT(date_added_datetime)
FROM shows;

-- converting string written as dd-mmm-yy

ALTER TABLE shows
ADD COLUMN date_added_datetime DATE;

UPDATE shows
SET date_added_datetime = CASE
    WHEN date_added ~ '^[A-Za-z]+ [0-9]{1,2}, [0-9]{4}$' THEN 
        TO_DATE(date_added, 'Month DD, YYYY')
    WHEN date_added ~ '^[0-9]{1,2}-[A-Za-z]{3}-[0-9]{2}$' THEN 
        TO_DATE(date_added, 'DD-Mon-YY')
    ELSE
        NULL
END;

ALTER TABLE shows
DROP column date_added;

ALTER TABLE shows
RENAME COLUMN date_added_datetime TO date_added;

CREATE TABLE shows2 AS
SELECT show_id, type, title, director, casts, country, date_added, release_year, rating, seasons, listed_in, description
FROM shows;


-- Additional considerations: Could further normalize by splitting the listed_in column into a separate genre table 
-- for movies and shows.

