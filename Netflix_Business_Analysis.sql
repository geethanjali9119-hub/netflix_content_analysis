-- ================================================================
-- Q 1:
-- How many total titles are available on Netflix,
-- and how are they distributed between Movies and TV Shows?
-- ================================================================

select 
	count(distinct show_id) as total_titles,
	count(distinct case when type = 'Movie' then show_id end) as total_movies,
	count(distinct case when type = 'TV Show' then show_id end) as total_tv_shows
from netflix_content_cleaned;

-------------------------------------------------------------------
-- Answer:
-- Netflix has 8,809 total titles: 6,132 Movies and 2,677 TV Shows.
--------------------------------------------------------------------

-- =================================================================
-- Q 2:
-- What percentage of Netflix's content consists of 
-- Movies versus TV Shows?
-- =================================================================

select
	type,
	count(*) as total_titles,
	round(
		count(*) * 100.0 / sum(count(*)) over(),
		2
	) as percentage_of_content
from netflix_content_cleaned
group by type;

--------------------------------------------------------------------
-- Answer:
-- Movies make up approximately 69.61% of Netflix's content,
-- while TV Shows make up approximately 30.39%.
--------------------------------------------------------------------

-- =================================================================
-- Q 3:
-- Which content rating has the highest number of titles on Netflix?
-- =================================================================

select Top 1
	rating,
	count(*) as total_titles
from netflix_content_cleaned
where rating is not null
group by rating
order by count(*) desc;

--------------------------------------------------------------------
-- Answer:
-- TV-MA has the highest number of titles on Netflix,
-- with 3,208 titles
--------------------------------------------------------------------

-- =================================================================
-- Q 4:
-- How has the number of titles added to Netflix 
-- changed year by year?
-- =================================================================

select
	year(date_added) as added_year,
	count(*) as total_titles_added
from netflix_content_cleaned
where date_added is not null
group by year(date_added)
order by added_year;

---------------------------------------------------------------------
-- Answer:
-- The number of titles added to Netflix changed year by year, 
-- increasing during the earlier years, reaching its highest level in
-- 2019 with 2,016 titles, and then declining in the following years.
---------------------------------------------------------------------

-- ==================================================================
-- Q 5:
-- Which year had the highest number of titles added to Netflix?
-- ==================================================================

select Top 1
	year(date_added) as added_year,
	count(*) as total_titles_added
from netflix_content_cleaned
where date_added is not null
group by year(date_added)
order by count(*) desc;

---------------------------------------------------------------------
-- Answer:
-- 2019 had the highest number of titles added to Netflix,
-- with 2,016 titles.
---------------------------------------------------------------------

-- ==================================================================
-- Q 6:
-- Which months have the highest number of titles added to Netflix?
-- ==================================================================

select
	datename(month,date_added) as added_month,
	count(*) as total_titles_added
from netflix_content_cleaned
where date_added is not null
group by datename(month,date_added)
order by count(*) desc;

---------------------------------------------------------------------
-- Answer:
-- July had the highest number of titles added to Netflix,
-- with 827 titles
---------------------------------------------------------------------

-- ==================================================================
-- Q 7:
-- How has Netflix's content mix (Movies and TV Shows) 
-- changed over the years?
-- ==================================================================

select
	year(date_added) as added_year,
	type,
	count(*) as total_titles
from netflix_content_cleaned
where year(date_added) is not null
group by 
	year(date_added),
	type
order by 
	year(date_added),
	type;

------------------------------------------------------------------------
-- Answer:
-- Movies were added in greater numbers than TV Shows across most years,
-- while the number of TV Shows added generally increased over time.
------------------------------------------------------------------------

-- =====================================================================
-- Q 8:
-- Which countries contribute the highest number of titles to Netflix?
-- =====================================================================

select
	trim(value) as country,
	count(distinct show_id) as total_titles
from netflix_content_cleaned
cross apply string_split(country, ',')
where country is not null
	and trim(value) <> ''
group by trim(value)
order by total_titles desc;

------------------------------------------------------------------------
-- Answer:
-- The United States contributes the highest number of titles,
-- to Netflix, followed by India and the United Kingdom.
------------------------------------------------------------------------

-- =====================================================================
-- Q 9:
-- Which countries have the highest number of Movies and 
-- which have the highest number of TV Shows?
-- =====================================================================

select
	trim(value) as country,
	type,
	count(distinct show_id) as total_titles
from netflix_content_cleaned
cross apply string_split(country, ',')
where country is not null
	and trim(value) <> ''
group by trim(value), type
order by type, total_titles desc;

--------------------------------------------------------------------------
-- Answer:
-- United States has the highest number of Movies with 2,753,
-- while United States has the highest number of TV Shows with 938.
--------------------------------------------------------------------------

-- =======================================================================
-- Q 10:
-- What percentage of Netflix's titles come 
-- from top 10 content-producing countries?
-- =======================================================================

with CountryCounts as
(
    select
        ltrim(rtrim(c.value)) as country,
        count(distinct n.show_id) as total_titles
    from netflix_content_cleaned n
    cross apply string_split(n.country, ',') c
    where n.country is not null
      and ltrim(rtrim(c.value)) <> ''
    group by ltrim(rtrim(c.value))
),
Top10Countries as
(
    select top 10
        country
    from CountryCounts
    order by total_titles desc
),
Top10TitleCount as
(
    select
        count(distinct n.show_id) as top_10_titles
    from netflix_content_cleaned n
    cross apply string_split(n.country, ',') c
    inner join Top10Countries t
        on ltrim(rtrim(c.value)) = t.country
),
TotalTitleCount as
(
    select count(distinct show_id) as total_titles
    from netflix_content_cleaned
)
select
    t.top_10_titles,
    total.total_titles,
    round(
        t.top_10_titles * 100.0 / total.total_titles,
        2
    ) as percentage_of_titles
from Top10TitleCount t
cross join TotalTitleCount total;

--------------------------------------------------------------------------
-- Answer: 
-- The top 10 countries collectively account for approximately,
-- 73.75% of Netflix's total titles.
--------------------------------------------------------------------------

-- =======================================================================
-- Q 11:
-- Which genres contain the highest number of Netflix titles?
-- =======================================================================

with genretitles as
(
	select
		trim(value) as genre,
		count(DISTINCT show_id) as total_titles
	from netflix_content_cleaned
	cross apply string_split(listed_in, ',')
	where listed_in is not null
		and trim(value) <> ''
	group by trim(value)
)
select
	genre,
	total_titles
from genretitles
order by total_titles desc;

--------------------------------------------------------------------------
-- Answer:
-- International Movies contains the highest number of titles,
-- followed by Dramas.
--------------------------------------------------------------------------

-- =======================================================================
-- Q 12:
-- Which Genres are most popular within movies compared with TV Shows?
-- =======================================================================

with genretype as
(
	select
		trim(value) as genre,
		type,
		count(distinct show_id) as total_titles
	from netflix_content_cleaned
	cross apply string_split(listed_in, ',')
	where listed_in is not null
		and trim(value) <> ''
	group by trim(value), type
)

select	
	genre,
	sum(case
		when type = 'Movie'
		then total_titles
		else 0
		End) as movie_titles,
	sum(case
		when type = 'TV Show'
		then total_titles
		else 0
		End) as tv_show_titles,
	sum(case
		when type = 'Movie'
		then total_titles
		else 0
		end) 
	-
	sum(case
		when type = 'TV Show'
		then total_titles
		else 0 
		end) as difference
from genretype
group by genre
order by difference desc;

--------------------------------------------------------------------------
-- Answer:
-- International Movies show the largest Movie-TV Show title difference.
--------------------------------------------------------------------------

-- =======================================================================
-- Q 13:
-- Which genres have shown the strongest growth in 
-- the number of titles added over time?
-- =======================================================================

with genreyear as
(
	select
		trim(value) as genre,
		year(date_added) as added_year,
		count(distinct show_id) as total_titles
	from netflix_content_cleaned
	cross apply string_split(listed_in, ',')
	where listed_in is not null
		and trim(value) <> ''
		and year(date_added) is not null
	group by trim(value), year(date_added)
),
GenreGrowth as
(
	select
		genre,
		added_year,
		total_titles,
		lag(total_titles) over
		(
			partition by genre
			order by added_year
		) as previous_year_titles
	from genreyear
)

select 
	genre,
	added_year,
	total_titles,
	previous_year_titles,
	total_titles - previous_year_titles as growth
from GenreGrowth
where previous_year_titles is not null
order by growth desc;

--------------------------------------------------------------------------
-- Answer:
-- International Movies showed the strongest year-over-year growth, 
-- with 313 more titles added compared with the previous year.
--------------------------------------------------------------------------

-- =======================================================================
-- Q 14:
-- Which directors have the highest number of titles on Netflix?
-- =======================================================================

select 
	trim(value) as director,
	count(distinct show_id) as total_titles
from netflix_content_cleaned
cross apply string_split(director, ',')
where director is not null
	and trim(value) <> ''
group by trim(value)
order by total_titles desc;

--------------------------------------------------------------------------
-- Answer: 
-- Rajiv Chilaka has the highest number of Netflix titles 
-- with 22 titles followed by Jan Suter with 21 titles.
--------------------------------------------------------------------------

-- =======================================================================
-- Q 15:
-- Which actors appear in the highest number of Netflix titles?
-- =======================================================================

select
	trim(value) as actor,
	count(distinct show_id) as total_titles
from netflix_content_cleaned
cross apply string_split(cast, ',')
where cast is not null
	and trim(value) <> ''
group by trim(value)
order by total_titles desc;

--------------------------------------------------------------------------
-- Answer:
-- Anupam Kher appeared in the highest number of Netflix titles,
-- with 43 titles.
--------------------------------------------------------------------------

-- =======================================================================
-- Q 16:
-- What is the average number of seasons for TV Shows, 
-- and which shows have the highest number of seasons?
-- =======================================================================

select
	Avg(
		cast(
			trim(
				replace(
					replace(duration, 'seasons',''),
					'season',''
				)
			) as decimal(10,2)
		)
	) as average_seasons
from netflix_content_cleaned
where type = 'TV Show'
	and duration is not null
	and duration like '%season%'

select 
	title,
	cast(
		trim(
			replace(
				replace(duration, 'seasons', ''),
				'season',''
			) 
		)as int
	) as season
from netflix_content_cleaned
where type = 'TV Show'
	and duration is not null
	and duration like '%season%'
order by season desc;

--------------------------------------------------------------------------
-- Answer:
-- The average number of seasons for TV Shows is 1.765 seasons.
-- Grey's Anatomy has the highest number of seasons, with 17 seasons.
--------------------------------------------------------------------------

-- =======================================================================
-- Q 17:
-- Which content ratings are most common within Movies compared 
-- with TV Shows?
-- =======================================================================

select
	type,
	rating,
	count(*) as rating_count
from netflix_content_cleaned
where rating is not null
group by type, rating
order by type, rating_count desc;

--------------------------------------------------------------------------
-- Answer:
-- TV-MA is the most common rating for both Movies and TV Shows, 
-- with 2,062 Movie titles and 1,146 TV Show titles.
--------------------------------------------------------------------------

-- =======================================================================
-- Q 18:
-- Which countries have a high volume of Netflix content,
-- but relatively low content diversity across genres?
-- =======================================================================

with CountryGenre as
(
	select
		trim(c.value) as country,
		trim(g.value) as genre,
		count(distinct n.show_id) as total_titles
	from netflix_content_cleaned n
	cross apply string_split(n.country, ',') c
	cross apply string_split(n.listed_in, ',') g
	where n.country is not null 
		and n.listed_in is not null
	Group by
		trim(c.value),
		trim(g.value)
),
CountrySummary as
(
	select
		country,
		sum(total_titles) as total_content,
		count(distinct genre) as genre_diversity
	from CountryGenre
	group by country

)
select
	country,
	total_content,
	genre_diversity
from CountrySummary
where total_content >= 100
order by genre_diversity asc, total_content desc;

--------------------------------------------------------------------------
-- Answer:
-- The United States, India, and the United Kingdom have 
-- high content volume but relatively low genre diversity.
--------------------------------------------------------------------------

-- =======================================================================
-- Q 19:
-- What are the top 10 countries by number of Netflix titles, 
-- and how do they rank against each other?
-- =======================================================================

select top 10
	trim(value) as country,
	count(distinct show_id) as total_titles
from netflix_content_cleaned
cross apply string_split(country,',')
where country is not null
	and trim(value) <> ''
group by trim(value)
order by total_titles desc;

--------------------------------------------------------------------------
-- Answer:
-- The United States ranks first with 3,691 Netflix titles,
-- followed by India, the United Kingdom, Canada, France, Japan,
-- South Korea, Spain, Germany, and Mexico.
--------------------------------------------------------------------------

-- =======================================================================
-- Q 20:
-- For each year, what are the top 3 genres based on the number of titles
-- added to Netflix?
-- =======================================================================

with YearGenreCounts as
(
    select
        year(try_convert(date, date_added)) as added_year,
        trim(value) as genre,
        count(distinct show_id) as total_titles
    from netflix_content_cleaned
    cross apply string_split(listed_in, ',')
    where date_added is not null
      and listed_in is not null
    group by
        year(try_convert(date, date_added)),
        trim(value)
),
RankedGenres as
(
    select
        added_year,
        genre,
        total_titles,
        rank() over
        (
            partition by added_year
            order by total_titles desc
        ) as genre_rank
    from YearGenreCounts
)
select
    added_year,
    genre,
    total_titles,
    genre_rank
from RankedGenres
where genre_rank <= 3
order by
    added_year,
    genre_rank;

-------------------------------------------------------------------------
-- Answer:
-- The top 3 genres varied by year.
-- International Movies, Dramas, and Comedies appeared among
-- the leading genres across multiple years.
-------------------------------------------------------------------------