select*from netflix;
select*from genre;
-- What are the average IMDb scores for each genre of Netflix Originals?
select g.genre,avg(n.IMDBScore) as average_IMDB from netflix n
join genre g on n.GenreID=g.GenreID
group by g.Genre;
-- Which genres have an average IMDb score higher than 7.5?
select g.genre,avg(n.IMDBScore) as average_IMDB from netflix n
join genre g on n.GenreID=g.GenreID
group by g.Genre
having average_IMDB>7.5;
-- List Netflix Original titles in descending order of their IMDb scores.
select Title,IMDBScore from netflix
order by IMDBScore desc;
-- Retrieve the top 10 longest Netflix Originals by runtime.
select Title,Runtime from netflix
order by Runtime desc
limit 10;
-- Retrieve the titles of Netflix Originals along with their respective genres.
select n.Title,g.Genre from netflix n
join genre g on n.GenreID=g.GenreID;
-- Rank Netflix Originals based on their IMDb scores within each genre.
select Title,GenreID,IMDBScore,
dense_rank() over(partition by GenreID order by IMDBScore desc) as rnk from netflix;
-- Which Netflix Originals have IMDb scores higher than the average IMDb score of all titles?
select Title,IMDBScore from netflix
where IMDBScore>(select avg(IMDBScore) from netflix);
-- How many Netflix Originals are there in each genre?
select g.Genre,count(n.title) as num_originals from genre g
left join netflix n on g.GenreID=n.GenreID
group by g.Genre;
-- Which genres have more than 5 Netflix Originals with an IMDb score higher than 8?
select g.Genre from genre g
left join netflix n on n.GenreID=g.GenreID
where n.IMDBScore>8
group by g.Genre
having count(n.Title)>5;
-- What are the top 3 genres with the highest average IMDb scores, and how many Netflix Originals do they have
SELECT 
  genre, 
  AVG(IMDBScore) AS avg_imdb_score, 
  COUNT(title) AS num_originals
FROM (
  SELECT 
    g.genre, 
    n.title, 
    n.IMDBScore,
    ROW_NUMBER() OVER(PARTITION BY g.genre ORDER BY n.IMDBScore DESC) AS genre_rank
  FROM genre AS g
  LEFT JOIN netflix AS n ON g.GenreID = n.GenreID
) AS ranked
WHERE genre_rank <= 3
GROUP BY genre
ORDER BY avg_imdb_score DESC

