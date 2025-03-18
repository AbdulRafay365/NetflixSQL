-- Q0 Types of Content
-- Retrieve distinct content types available in the dataset.
SELECT 
    DISTINCT(type) AS Content
FROM netflix;

-- Q1 Count the number of Movies vs TV Shows
-- Aggregate the total number of movies and TV shows.
SELECT 
    type AS Content, 
    COUNT(show_id) AS total_shows
FROM netflix 
GROUP BY type; 

-- Q2 Find the most common rating for movies and TV shows

-- Step 1: List all distinct rating types and their occurrences.
SELECT 
    DISTINCT(rating) AS Types_of_rating, 
    COUNT(*) as Shows
FROM netflix
GROUP BY Types_of_rating
ORDER BY Shows DESC
LIMIT 5;

-- Step 2: Use Common Table Expressions (CTEs) to find the most frequent rating for movies and TV shows.
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
FROM netflix
WHERE 
    type = 'Movie' AND release_year = '2020'
LIMIT 5;

-- Q4 Find the top 5 countries with the most content on Netflix
-- STRING_TO_ARRAY splits multiple countries listed in a single column
-- UNNEST expands the array into separate rows for accurate counting
SELECT 
    TRIM(UNNEST(STRING_TO_ARRAY(country, ','))) AS new_country,
    COUNT(show_id) AS content_count
FROM netflix
WHERE country IS NOT NULL 
GROUP BY new_country
ORDER BY content_count DESC
LIMIT 5;

-- Q5 Identifying the longest movie
-- REPLACE removes 'min' from the duration column and converts it into an integer
SELECT 
    title, 
    REPLACE(duration, ' min', '')::INTEGER AS duration_numeric_min
FROM netflix
WHERE type = 'Movie'
ORDER BY duration_numeric_min DESC
LIMIT 5;

-- Q6 Content added in the last 5 years using UNION ALL
WITH contentadded AS (
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
)
SELECT content_type, COUNT(*) AS total
FROM contentadded
GROUP BY content_type
ORDER BY total DESC;

-- Q7 Find all movies/TV shows by director 'Rajiv Chilaka'
-- Using UNNEST to handle multiple director names in a single column
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
WHERE seasons >= 5
ORDER BY seasons DESC
LIMIT 5;

-- Q9 Count the number of content items in each genre
-- Uses UNNEST to split multiple genres stored in a single column
SELECT genre, COUNT(*) AS content_count
FROM (
    SELECT TRIM(genre) AS genre
    FROM movies, UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre
    UNION ALL
    SELECT TRIM(genre) AS genre
    FROM shows, UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre
) split_listed_in
GROUP BY genre
ORDER BY content_count DESC
LIMIT 5;

-- Q10 Find the top 5 years with the highest average content release in India
SELECT release_year, COUNT(show_id) AS Average_content_released
FROM shows
WHERE country = 'India'
GROUP BY release_year
ORDER BY Average_content_released DESC
LIMIT 5;

-- Q11 List all movies of type documentaries
SELECT movie_id, title 
FROM movies
WHERE listed_in ILIKE '%documentaries%'
LIMIT 5;

-- Q12 Find all content without a director
-- Uses UNION ALL to combine results from movies and shows
SELECT movie_id, title, type FROM movies
WHERE director = 'Unknown'
UNION ALL
SELECT show_id, title, type FROM shows
WHERE director = 'Unknown'
ORDER BY 3;

-- Q13 Count how many movies actor 'Salman Khan' appeared in over the last 10 years (Previous to 2021 as data is only upto 2021)
SELECT movie_id, title, release_year, actor_name
FROM movies,
     UNNEST(string_to_array(casts, ', ')) AS actor_name
WHERE actor_name ILIKE '%Salman Khan%'
AND release_year >= 2011
ORDER BY release_year DESC;

-- Q14 Find the top 10 actors with the most movie appearances in India
SELECT actor_name, COUNT(movie_id) AS count_of_movies
FROM movies,
    UNNEST(STRING_TO_ARRAY(casts, ', ')) AS actor_name
WHERE country ILIKE '%India%'
GROUP BY actor_name
ORDER BY count_of_movies DESC
LIMIT 10;

-- Q15 Categorize content based on keywords 'kill' and 'violence' in descriptions
-- Uses CASE WHEN to classify content as 'Bad' or 'Good'
SELECT 
    CASE
        WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
        ELSE 'Good'
    END AS score,
    COUNT(movie_id) AS total_content, type
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
