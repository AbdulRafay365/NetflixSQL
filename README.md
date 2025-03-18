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
    
### 4. Further Normalization to 3NF    
#### 1. Genre Normalization
- A separate `genre` table was created to store unique genres, with `genre_id` as the primary key.
- Junction tables, `movie_genres` and `show_genres`, were created to establish many-to-many relationships between media and genres.

#### 2. Data Insertion & Transformation
- Unique genres were extracted from the `listed_in` column of both `movies` and `shows` tables. These were inserted into the `genre` table after trimming unnecessary spaces.
- The `movie_genres` and `show_genres` tables were populated by mapping `movie_id` and `show_id` to their corresponding `genre_id`.

#### 3. Consolidated Media Table
- A unified media view was generated, merging `movies` and `shows` while maintaining a common structure.
- A query was designed to retrieve all media records, including relevant attributes but excluding duration for better alignment across both categories.

#### 4. Country-Based Normalization
- Countries were extracted as separate entities, and each media entry was assigned its corresponding country, facilitating location-based analysis.

#### 5. Duration Standardization
- The duration attribute was split into two separate fields:
  - `duration_in_min` for movies
  - `seasons` for shows
---

## Entity Relationship Diagram

![ERD](https://github.com/user-attachments/assets/4b2503dd-297d-402e-aeb1-e07fee2439d9)

### 5. Converting Data Types
- **Converted `duration` in movies** from VARCHAR to **TIME format**.
- **Converted `seasons` in shows** from text to **INTEGER**.
- **Formatted `date_added` column** from text to **DATE format** to allow proper time-based analysis.

---
## Technology Stack  

- **Database:** PostgreSQL, Microsoft Excel  
- **Query Tool:** pgAdmin  
- **Version Control:** Git & GitHub  
- **Data Handling:** SQL Queries  

## Operations Used  

- **Data Cleaning & Formatting:** Converting text to lists, trimming spaces, changing data types.  
- **Data Analysis:** Counting, grouping, filtering, and ranking content.  
- **Performance Optimization:** Using CTEs (`WITH` statements) for better query readability and efficiency.  
- **Combining Data:** Merging results from different tables using `UNION ALL`.

---

## 15 Business Problems & Solutions

---

## Content Overview

1.	What types of content are available?
Identify all unique types of content available on Netflix.

<img width="201" alt="0" src="https://github.com/user-attachments/assets/b7123f16-85b3-416d-a3be-85209fbb2653" />

2.	Count the number of Movies vs TV Shows.
Compare the distribution of Movies and TV Shows in the dataset.

<img width="296" alt="1" src="https://github.com/user-attachments/assets/dce0e17f-14d5-4127-9c08-bcedefb7039f" />


---

## Content Details & Trends
### 3. Find the most common rating for Movies and TV Shows.
- Determine the rating that appears most frequently for each content type.
  
<img width="261" alt="2" src="https://github.com/user-attachments/assets/4d3a8798-b170-4b35-81e7-227ff4a17df2" />
<img width="354" alt="2 ex" src="https://github.com/user-attachments/assets/7a231352-52fe-4631-947b-9d67d57b3825" />

### 4. List all movies released in a specific year (e.g., 2020).
- Retrieve a list of movies based on the year they were released.
  
<img width="613" alt="3" src="https://github.com/user-attachments/assets/ffa125b3-7721-485f-86c2-660c9d13f4c8" />

### 5. Find the top 5 countries with the most content on Netflix.
- Identify which countries contribute the most content to Netflix.
  
<img width="264" alt="4" src="https://github.com/user-attachments/assets/27cb3274-6f42-4612-9b9f-b1c76723f5cd" />

### 6. Identify the longest movie.
- Locate the movie with the longest runtime on Netflix.
  
<img width="386" alt="5" src="https://github.com/user-attachments/assets/f4d51e41-9b77-4f51-a1c2-0ca548e36cb4" />

### 7. Find content added in the last 5 years.
- Query to discover content added to Netflix within the most recent 5 years.
  
<img width="650" alt="6" src="https://github.com/user-attachments/assets/b0c5d44a-e270-4b94-85f6-77f55bfcb0db" />

---

## Creator & Genre Insights
### 8. Find all Movies/TV Shows by director ‘Rajiv Chilaka’.
- Retrieve all content directed by Rajiv Chilaka.
  
<img width="1197" alt="7" src="https://github.com/user-attachments/assets/0b8ff70f-6608-4c8b-be5e-0d64d3751f28" />

### 9. List all TV Shows with more than 5 seasons.
- Identify TV Shows that have a runtime exceeding five seasons.
  
<img width="275" alt="8" src="https://github.com/user-attachments/assets/643a76a8-03bd-4eea-89c5-3aed9f6b5e04" />

### 10. Count the number of content items in each genre.
- Group content by genre and calculate the total for each.
  
<img width="304" alt="9" src="https://github.com/user-attachments/assets/cbfe962a-4cad-4301-ae4a-7e123713830a" />

---

## Country-Specific Content Analysis
### 11. Find the top 5 years with the highest average content release in India.
- Analyze and return the years with the highest average Netflix releases in India.
  
<img width="327" alt="10" src="https://github.com/user-attachments/assets/98028666-6f5b-4840-b95f-7480a84f9e19" />

### 12. List all Movies that are Documentaries.
- Query to identify movies categorized as documentaries.
  
<img width="390" alt="11" src="https://github.com/user-attachments/assets/397e1a0b-0178-4f3c-9774-58cc355d0a7e" />

---

## Data Completeness & Actor Insights
### 13. Find all content without a director.
- Identify records missing a director’s name in the dataset.
  
<img width="334" alt="12" src="https://github.com/user-attachments/assets/cff03684-d783-4a7b-958b-ef83c414c035" />

### 14. Count how many movies actor ‘Salman Khan’ appeared in over the last 10 years.
- Retrieve the total number of movies featuring Salman Khan in the last decade.
  
<img width="573" alt="13" src="https://github.com/user-attachments/assets/c385715f-f463-4c00-ad6e-fbc0d641eea2" />

### 15. Find the top 10 actors who have appeared in the highest number of movies produced in India.
- Determine the most frequent collaborators in Indian Netflix content.

<img width="295" alt="14" src="https://github.com/user-attachments/assets/243fc2c9-e8ef-4323-9679-9dbbc2773ee6" />

---

## Content Categorization
### 16. Categorize content based on keywords (‘kill’ and ‘violence’).
- Label content containing the keywords as “Bad” and all others as “Good.” Count how many items fall into each category.
  
<img width="367" alt="15" src="https://github.com/user-attachments/assets/7f747392-2363-47a6-95c7-3759c5f9f09a" />

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

---

## Additional Considerations
- Further data collection is required, as nearly 2,600 movies and TV shows are missing director information, which may hinder the accuracy of our analysis.
- The data is only available up to 2021, so the analysis may not reflect current trends.



