# Netflix Movies & TV Shows Analysis

## 📌 Project Overview

This project analyzes Netflix movies and TV shows to identify trends in content type, genres, ratings, countries, release years, and content additions over time.

The analysis was performed using Excel and Power Query for data cleaning, SQL Server for data analysis, and Power BI for interactive data visualization and dashboard development.

## 🎯 Project Objective

The main objective of this project is to transform Netflix content data into meaningful insights that can help understand:

- Content distribution between Movies and TV Shows
- Content growth over time
- Popular genres and categories
- Content ratings distribution
- Countries contributing the most content
- Release year trends
- Netflix content additions over time

## ❓ Business Questions

The analysis focuses on answering the following questions:

1. How many Movies and TV Shows are available on Netflix?
2. What percentage of Netflix content is Movies and TV Shows?
3. Which countries have the highest number of Netflix titles?
4. Which countries have the highest number of Movies and TV Shows?
5. What are the most common content ratings?
6. Which genres have the highest number of titles?
7. How has Netflix content changed over the years?
8. Which years had the highest number of content additions?
9. How does content distribution vary across countries?
10. Which genres are most popular across different years?
11. How does the distribution of Movies and TV Shows vary by year?
12. What are the major trends in Netflix's content library?

## 🗂️ Dataset

The project uses a cleaned Netflix titles dataset containing **8,809 records**.

### Data File

- `netflix_content_cleaned.csv` – Cleaned Netflix movies and TV shows dataset

The dataset contains information such as:

- Show ID
- Title
- Content Type
- Director
- Cast
- Country
- Date Added
- Release Year
- Rating
- Duration
- Genre
- Description

## 🛠️ Tools & Technologies

- **Excel** – Data preparation and initial cleaning
- **Power Query** – Data cleaning and transformation
- **SQL Server** – Data analysis and business queries
- **Power BI** – Interactive dashboard and data visualization

## 🔍 SQL Analysis

SQL was used to analyze the Netflix dataset and answer the business questions using:

- Aggregations
- Filtering
- Grouping
- Joins
- Subqueries
- Common Table Expressions (CTEs)
- Window Functions
- Ranking and Top-N analysis

The complete SQL queries are available in:

`Netflix_Business_Analysis.sql`

## 📊 Power BI Dashboard

An interactive Power BI dashboard was created to present key findings through KPIs, slicers, and visualizations.

The dashboard includes analysis of:

- Total Netflix Titles
- Movies vs TV Shows
- Content distribution by country
- Top countries
- Content ratings
- Top genres
- Release year trends
- Content additions over time

The Power BI dashboard file is available in:

`Netflix_Content_Dashboard.pbix`

## 📸 Dashboard Screenshots

Dashboard screenshots are available in the `Screenshots` folder.

- `Netflix_Dashboard_Page1.png`
- `Netflix_Dashboard_Page2.png`
- `Netflix_Dashboard_Page3.png`

## 💡 Key Insights

The analysis provides insights into:

- The distribution of Movies and TV Shows on Netflix
- Countries with the highest number of titles
- Popular genres and content categories
- Common content ratings
- Changes in Netflix's content library over time
- Major release year and content addition trends

## 📁 Project Structure

```text
netflix_content_analysis/
│
├── Screenshots/
│   ├── Netflix_Dashboard_Page1.png
│   ├── Netflix_Dashboard_Page2.png
│   └── Netflix_Dashboard_Page3.png
│
├── netflix_content_cleaned.csv
├── Netflix_Business_Analysis.sql
├── Netflix_Content_Dashboard.pbix
├── README.md
└── LICENSE
