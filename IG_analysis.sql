use mysql;

create table IG_analysis (
ranking int,
brand  varchar(255),
CATEGORIES1 varchar(255),
CATEGORIES2 varchar(255),
followers   decimal,
er           decimal,
posts_on_hashtag int,
media_posted    int);


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/most_followed_ig2.csv'
INTO TABLE IG_analysis
character set latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(ranking, brand, CATEGORIES1, CATEGORIES2, followers, er, 
posts_on_hashtag, media_posted);

SELECT COUNT(*) FROM IG_analysis WHERE followers  IS NULL OR followers = 0;

SELECT brand, COUNT(*) FROM IG_analysis GROUP BY brand HAVING COUNT(*) > 1;



/* identify most popular category*/
select CATEGORIES1, sum(followers) as total_followers
 from IG_analysis 
group by CATEGORIES1
order by total_followers desc;

/* finding top 5 brands with  the highest engagement*/
select brand, avg(er) as average_engagement_rate 
from IG_analysis
group by brand
order by average_engagement_rate desc limit 5;

/* finding which brands are most active in terms of numbers of post*/
select brand, sum(posts_on_hashtag) as total_posts
from IG_analysis
group by brand
order by total_posts desc limit 10;

/* finding top 5 brands need to boost their presence due to low actiity*/
select brand 
from IG_analysis where 
media_posted < (select avg(media_posted) from IG_analysis)
order by media_posted limit 5;



/*select the brands whose engagement rank is higher than what would be expected based on their number of followers*/
SELECT brand, followers, er, engagement_rank, followers_rank
FROM (
    SELECT 
        brand, 
        followers, 
        er,
        RANK() OVER (ORDER BY er DESC) AS engagement_rank,
        RANK() OVER (ORDER BY followers) AS followers_rank
    FROM IG_analysis
    WHERE followers < (SELECT AVG(followers) FROM IG_analysis)
) AS subquery
WHERE engagement_rank < followers_rank;




