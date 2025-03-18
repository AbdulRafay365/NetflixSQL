# NetflixSQL: Analyzing Netflix Content with SQL
A repository showcasing advanced SQL queries to solve 15 business problems using a Netflix dataset, covering content trends, ratings, genres, and more.

<p align="center">
  <img src="https://github.com/AbdulRafay365/NetflixSQL/blob/main/logo.png" alt="netflix_logo" width="400">
</p>

## Overview
This project utilizes a comprehensive dataset of Netflix’s movies and TV shows, sourced from Kaggle and covering data up until 2021. Using advanced SQL queries, the objective is to extract valuable insights and answer key business questions related to content trends, ratings, viewer preferences, and other factors. By analyzing this dataset, the project aims to provide actionable insights that can inform content strategy and improve the user experience. The following README details the project’s goals, business problems, solutions, findings, and conclusions.

All queries are available in the "All Solutions.SQL" file.

## Tasks
* Analyze the distribution of content types by comparing the number of movies versus TV shows.
* Identify the most prevalent ratings for both movies and TV shows.
* Examine and analyze content based on factors such as release years, countries of origin, and durations.
* Classify and categorize content according to specific criteria and keywords, uncovering unique patterns.

---

## Dataset
Kaggle Link: https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download

## Data Preparation

### 1. Handling Anomalies in Rating and Duration Columns
- Identified cases where **movie durations were mistakenly placed in the rating column**, leaving the duration column **NULL**.
- Corrected anomalies by moving durations to the appropriate column and updating incorrect ratings (e.g., **‘74 min’ → TV-MA**).

### 2. Handling NULL Values
- **Ratings**: Replaced NULL values with **‘Unknown’**.
- **Director Names**: Updated missing values to **‘Unknown’** to maintain data integrity.

### 3. Table Normalization
- **Separated Movies and TV Shows** into two tables:
  - **Movies**: Contains duration in **minutes** (converted to TIME format).
  - **Shows**: Stores **seasons** instead of minutes.

### 4. Converting Data Types
- **Converted `duration` in movies** from VARCHAR to **TIME format**.
- **Converted `seasons` in shows** from text to **INTEGER**.
- **Formatted `date_added` column** from text to **DATE format** to allow proper time-based analysis.

### 5. Further Normalization Considerations
- The `listed_in` column (genres) could be further normalized into a separate **genre table** for better categorization.

## 15 Business Problems & Solutions

---

## Content Overview

1.	What types of content are available?
Identify all unique types of content available on Netflix.

3.	Count the number of Movies vs TV Shows.
Compare the distribution of Movies and TV Shows in the dataset.

---

## Content Details & Trends
### 3. Find the most common rating for Movies and TV Shows.
- Determine the rating that appears most frequently for each content type.

### 4. List all movies released in a specific year (e.g., 2020).
- Retrieve a list of movies based on the year they were released.

### 5. Find the top 5 countries with the most content on Netflix.
- Identify which countries contribute the most content to Netflix.

### 6. Identify the longest movie.
- Locate the movie with the longest runtime on Netflix.

### 7. Find content added in the last 5 years.
- Query to discover content added to Netflix within the most recent 5 years.

---

## Creator & Genre Insights
### 8. Find all Movies/TV Shows by director ‘Rajiv Chilaka’.
- Retrieve all content directed by Rajiv Chilaka.

### 9. List all TV Shows with more than 5 seasons.
- Identify TV Shows that have a runtime exceeding five seasons.

### 10. Count the number of content items in each genre.
- Group content by genre and calculate the total for each.

---

## Country-Specific Content Analysis
### 11. Find the top 5 years with the highest average content release in India.
- Analyze and return the years with the highest average Netflix releases in India.

### 12. List all Movies that are Documentaries.
- Query to identify movies categorized as documentaries.

---

## Data Completeness & Actor Insights
### 13. Find all content without a director.
- Identify records missing a director’s name in the dataset.

### 14. Count how many movies actor ‘Salman Khan’ appeared in over the last 10 years.
- Retrieve the total number of movies featuring Salman Khan in the last decade.

### 15. Find the top 10 actors who have appeared in the highest number of movies produced in India.
- Determine the most frequent collaborators in Indian Netflix content.

---

## Content Categorization
### 16. Categorize content based on keywords (‘kill’ and ‘violence’).
- Label content containing the keywords as “Bad” and all others as “Good.” Count how many items fall into each category.

---

# **Insights from Netflix Content Analysis**  

## **1. Content Distribution: Movies vs. TV Shows**  
- Netflix primarily features movies, with **6,131 movies** compared to **2,676 TV shows**.  
- Movies account for nearly **70% of the content**, suggesting a stronger focus on films rather than long-format series.  

## **2. Content Ratings & Audience Demographics**  
- The most common rating for both **movies and TV shows** is **TV-MA**, with **3,210 titles**, indicating that Netflix leans heavily toward **mature audience content**.  
- **Other common ratings include:**  
  - TV-14: 2,160 titles  
  - TV-PG: 863 titles  
  - R: 799 titles  
  - PG-13: 490 titles  
- Family-friendly content like **TV-Y (307) and TV-G (220)** has a smaller presence.  

## **3. Geographical Content Distribution**  
- **The U.S. dominates Netflix content**, contributing **3,690 titles**, nearly **3.5 times more** than the next country, India (**1,046 titles**).  
- Other significant contributors include:  
  - United Kingdom: 806 titles  
  - Canada: 445 titles  
  - France: 393 titles  
- This indicates Netflix’s **strong English-language content focus** while also expanding in global markets like **India and Europe**.  

## **4. Longest Movies on Netflix**  
- The longest movie, **"Black Mirror: Bandersnatch,"** runs for **312 minutes**, reflecting Netflix’s experimentation with **interactive storytelling**.  
- Other long movies:  
  - **"Headspace: Unwind Your Mind"** – 273 minutes  
  - **"The School of Mischief"** – 253 minutes  
  - **"No Longer Kids"** – 237 minutes  
  - **"Lock Your Girls In"** – 233 minutes  

## **5. Recent Content Additions (Last 5 Years)**  
- **6,030 movies** and **2,552 TV shows** were added in the last five years, reinforcing Netflix’s **aggressive content expansion strategy**.  
- Movies continue to outpace TV shows in new additions, aligning with Netflix’s **licensing and production model**.  

## **6. Genre Popularity**  
- The top five genres are:  
  1. **International Movies** – 2,752 titles  
  2. **Dramas** – 2,427 titles  
  3. **Comedies** – 1,674 titles  
  4. **International TV Shows** – 1,351 titles  
  5. **Documentaries** – 869 titles  
- This suggests Netflix’s **strong focus on global storytelling and factual content**.  

## **7. Netflix Content Trends in India**  
- The top five years with the **highest average content releases** in India were:  
  - **2017** – 98 movies  
  - **2018** – 81 movies  
  - **2019** – 74 movies  
  - **2020** – 59 movies  
  - **2021** – 22 movies  
- **TV Shows followed a similar trend**, with peaks in **2018 and 2019** before slowing down.  

## **8. Most Prolific Bollywood Actors on Netflix**  
- **Top 10 Bollywood actors with the most movies on Netflix:**  
  1. **Anupam Kher** – 40 movies  
  2. **Shah Rukh Khan** – 34 movies  
  3. **Naseeruddin Shah** – 31 movies  
  4. **Akshay Kumar** – 29 movies  
  5. **Om Puri** – 29 movies  
  6. **Amitabh Bachchan** – 28 movies  
  7. **Paresh Rawal** – 28 movies  
  8. **Boman Irani** – 27 movies  
  9. **Kareena Kapoor** – 25 movies  
  10. **Ajay Devgn** – 21 movies  

## **Conclusion & Business Implications**  
- **Netflix’s catalog is dominated by movies (70%)**, with a primary focus on **mature-rated content (TV-MA)**.  
- **The U.S. leads content production**, but **India and the U.K. are key international markets**.  
- **Dramas, international movies, and comedies are the most popular genres**, showcasing Netflix’s efforts to balance **entertainment, global storytelling, and factual content**.  
- **Peak content additions in India were in 2017-2019**, reflecting Netflix’s strategy to grow in **regional markets**.  
- The presence of Bollywood superstars suggests that **Netflix is strategically using established talent to capture the Indian audience**.  



