-- Q0 Types of Content

SELECT 
	DISTINCT(type) AS Content
FROM netflix;



-- Q1 Count the number of Movies vs TV Shows

SELECT 
	DISTINCT(type) AS Content, 
	COUNT(show_id) AS total_shows
FROM netflix 
GROUP BY type;



-- Q2 Find the most common rating for movies and TV shows

-- Types of Ratings
SELECT 
	DISTINCT(rating) AS Types_of_rating, COUNT(*) as Shows
FROM netflix
GROUP BY Types_of_rating
ORDER BY Shows ASC;

-- Most common rating for movies and TV shows

WITH RatingCounts AS (
    SELECT 
        type,
        rating,
        COUNT(*) AS rating_count
    FROM netflix
    GROUP BY type, rating
),
RankedRatings AS (
    SELECT 
        type,
        rating,
        rating_count,
        RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rank
    FROM RatingCounts
)
SELECT 
    type,
    rating AS most_frequent_rating
FROM RankedRatings
WHERE rank = 1;



-- Q3 List all movies released in a specific year (e.g., 2020)

SELECT 
	title,
	type, 
	release_year
from netflix
WHERE 
	type = 'Movie' AND release_year = '2020';


	
-- Q4 Find the top 5 countries with the most content on Netflix

SELECT 
    TRIM(UNNEST(STRING_TO_ARRAY(country, ','))) AS new_country,
    COUNT(show_id) AS content_count
FROM netflix
WHERE country IS NOT NULL 
GROUP BY new_country
ORDER BY content_count DESC
LIMIT 5;



-- Q5 Indentifying the longest movie

SELECT
    title, duration
FROM netflix
WHERE
    type = 'Movie';
	


-- Q6 Content added in the last 5 years

-- UNION ALL join on movies and shows and viewing data between 2016 and 2021

SELECT 
    title, 
    date_added, 
    'Movie' AS content_type 
FROM movies
WHERE date_added BETWEEN '2016-01-01' AND '2021-12-31'

UNION ALL

SELECT 
    title, 
    date_added, 
    'Show' AS content_type 
FROM shows
WHERE date_added BETWEEN '2016-01-01' AND '2021-12-31'
ORDER BY date_added DESC;



-- Q7 Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT title, director
FROM movies
WHERE director = 'Rajiv Chilaka';



SELECT * 
FROM (
    SELECT 
        *, 
        UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
    FROM 
        netflix
) AS directors_split
WHERE 
    director_name = 'Rajiv Chilaka';
	


-- Q8 List all TV shows with more than 5 seasons

SELECT title, seasons
FROM shows
WHERE seasons >= 5;



-- Q9 Count the number of content items in each genre

SELECT genre, COUNT(*) AS content_count
FROM (
    -- Combine genres from both tables
    SELECT TRIM(genre) AS genre
    FROM movies, UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre
UNION ALL
    SELECT TRIM(genre) AS genre
    FROM shows, UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre
) split_listed_in
GROUP BY genre
ORDER BY content_count DESC;



-- Q10 Find each year and the average numbers of content release in India on netflix. 
-- Return top 5 year with highest avg content release!

SELECT release_year, COUNT(show_id) AS Average_content_released
FROM movies
WHERE country = 'India'
GROUP BY release_year
ORDER BY release_year DESC;

SELECT release_year, COUNT(show_id) AS Average_content_released
FROM shows
WHERE country = 'India'
GROUP BY release_year
ORDER BY release_year DESC;



-- Q11 List all movies of type documentaries

SELECT show_id, title 
FROM movies
WHERE listed_in ILIKE '%documentaries%';



-- Q12 All Content without director

SELECT show_id, title, type FROM movies
WHERE director = 'Unknown'
UNION ALL
SELECT show_id, title, type FROM shows
WHERE director = 'Unknown'
ORDER BY 3;



-- Q13 Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT show_id, title, release_year, actor_name
FROM movies,
     UNNEST(string_to_array(casts, ', ')) AS actor_name
WHERE actor_name ILIKE '%Salman Khan%'
AND release_year >= 2011
ORDER BY release_year desc;



-- Q14 Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT actor_name, COUNT(show_id) AS count_Of_movies
FROM movies,
	UNNEST(STRING_TO_ARRAY(casts, ', ')) AS actor_name
WHERE country ILIKE '%India%'
GROUP BY actor_name
ORDER BY count_Of_movies DESC
LIMIT 10;



-- Q15  Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field.
--  Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.

SELECT 
    CASE
        WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
        ELSE 'Good'
    END AS score,
    COUNT(show_id) AS total_content, type
FROM movies
GROUP BY score, type
UNION ALL
SELECT 
    CASE
        WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
        ELSE 'Good'
    END AS score,
    COUNT(show_id) AS total_content, type
FROM shows
GROUP BY score, type;





    




