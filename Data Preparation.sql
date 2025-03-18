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

-- Further Normalization to 3NF
-- Changing name from show_id to movie_id and making primary key

ALTER TABLE movies
ADD PRIMARY KEY (movie_id);

-- Making show_id primary key
ALTER TABLE shows
ADD PRIMARY KEY (show_id);

-- Creating genre table

CREATE TABLE genre (
	genre_id SERIAL PRIMARY KEY,
	genre_name VARCHAR(150)
);

CREATE TABLE movie_genres (
    movie_id VARCHAR(6),  -- Foreign key referencing the movies table (movie_id)
    genre_id INT,  -- Foreign key referencing the genres table (genre_id)
    PRIMARY KEY (movie_id, genre_id),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES genre(genre_id) ON DELETE CASCADE
);

CREATE TABLE show_genres (
    show_id VARCHAR(6),  -- Foreign key referencing the shows table (show_id)
    genre_id INT,  -- Foreign key referencing the genres table (genre_id)
    PRIMARY KEY (show_id, genre_id),
    FOREIGN KEY (show_id) REFERENCES shows(show_id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES genre(genre_id) ON DELETE CASCADE
);

-- Insert unique genres from movies and shows into the genre table
INSERT INTO genre (genre_name)
SELECT DISTINCT TRIM(genre) AS genre_name
FROM (
    SELECT UNNEST(string_to_array(listed_in, ',')) AS genre
    FROM movies
    WHERE listed_in IS NOT NULL
    UNION ALL
    SELECT UNNEST(string_to_array(listed_in, ',')) AS genre
    FROM shows
    WHERE listed_in IS NOT NULL
) AS cleaned_genres
WHERE genre IS NOT NULL AND genre != '';


-- Insert movie-genre associations into the movie_genre junction table
WITH movie_genres AS (
    SELECT movie_id, UNNEST(string_to_array(listed_in, ',')) AS genre
    FROM movies
    WHERE listed_in IS NOT NULL
)
INSERT INTO movie_genres (movie_id, genre_id)
SELECT m.movie_id, g.genre_id
FROM movie_genres m
JOIN genre g ON TRIM(m.genre) = g.genre_name
WHERE TRIM(m.genre) != '';

-- Insert show-genre associations into the show_genre junction table
WITH show_genres AS (
    SELECT show_id, UNNEST(string_to_array(listed_in, ',')) AS genre
    FROM shows
    WHERE listed_in IS NOT NULL
)
INSERT INTO show_genres (show_id, genre_id)
SELECT s.show_id, g.genre_id
FROM show_genres s
JOIN genre g ON TRIM(s.genre) = g.genre_name
WHERE TRIM(s.genre) != '';

-- Final content_with_genre table
SELECT s.show_id AS media_id, s.title AS media_title, sg.genre_id, g.genre_name, s.type AS media_type
FROM show_genres sg
JOIN genre g ON sg.genre_id = g.genre_id
JOIN shows s ON sg.show_id = s.show_id
UNION ALL
SELECT m.movie_id AS media_id, m.title AS media_title, mg.genre_id, g.genre_name, m.type AS media_type
FROM movie_genres mg
JOIN genre g ON mg.genre_id = g.genre_id
JOIN movies m ON mg.movie_id = m.movie_id;

SELECT * FROM movie_genres
ORDER BY 1;

SELECT * FROM shows;

-- media without duration
SELECT
    -- Common media_id for both movies and shows
    COALESCE(m.movie_id, s.show_id) AS media_id,
    
    -- Include the necessary columns, excluding the duration column
    COALESCE(m.title, s.title) AS title,
    COALESCE(m.director, s.director) AS director,
    COALESCE(m.casts, s.casts) AS casts,
    COALESCE(m.country, s.country) AS country,
    COALESCE(m.date_added, s.date_added) AS date_added,
    COALESCE(m.release_year, s.release_year) AS release_year,
    COALESCE(m.rating, s.rating) AS rating,
    COALESCE(m.listed_in, s.listed_in) AS listed_in,
    COALESCE(m.description, s.description) AS description,
    
    -- Specify the type (movie or show)
    CASE 
        WHEN m.movie_id IS NOT NULL THEN 'movie'
        WHEN s.show_id IS NOT NULL THEN 'show'
    END AS media_type
FROM 
    movies m
FULL OUTER JOIN 
    shows s
    ON m.movie_id = s.show_id;  -- Joining on media_id (movie_id or show_id)

-- media by country
SELECT movie_id AS media_id, TRIM(UNNEST(string_to_array(country, ','))) AS country
FROM movies
UNION 
SELECT show_id AS media_id, TRIM(UNNEST(string_to_array(country, ','))) AS country
FROM shows;

-- media by duration
SELECT movie_id AS media_id, duration_in_min
FROM movies;

SELECT show_id AS media_id, seasons
FROM shows;
---------------------------------------------
-- Check movies table
SELECT * FROM movies;

-- Check shows table
SELECT * FROM shows;

-- Check genre table
SELECT * FROM genre;

-- Check movie-genre relationships
SELECT * FROM movie_genres ORDER BY movie_id;

-- Check show-genre relationships
SELECT * FROM show_genres ORDER BY show_id;

