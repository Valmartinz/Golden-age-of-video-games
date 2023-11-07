--Task1
--Let's find the ten best-selling video games in game_sales.
SELECT *
FROM game_sales
ORDER BY games_sold DESC
LIMIT 10;

--Task2
--Let's determine how many games in the game_sales table are missing both a user_score and a critic_score.
SELECT COUNT(g.game)
FROM game_sales as g
LEFT JOIN reviews as r
ON g.game = r.game
WHERE critic_score IS NULL AND user_score IS NULL;

--Task3
--Find the years with the highest average critic_score.
SELECT year,ROUND(AVG(critic_score),2) AS avg_critic_score
FROM game_sales as g
LEFT JOIN reviews as r
ON g.game = r.game
GROUP BY year
ORDER BY avg_critic_score DESC
LIMIT 10;

--Task4
--Find game critics' ten favorite years, this time with the stipulation that a year must have more than four games released in order to be considered.
SELECT g.year, COUNT(g.game) AS num_games, ROUND(AVG(r.critic_score),2) AS avg_critic_score
FROM game_sales as g
INNER JOIN reviews as r
ON g.game = r.game
GROUP BY g.year
HAVING COUNT(g.game) > 4
ORDER BY avg_critic_score DESC
LIMIT 10;

--Task5
--Find the years that were on our first critics' favorite list but not the second
SELECT year, avg_critic_score
FROM top_critic_years
EXCEPT
SELECT year, avg_critic_score
FROM top_critic_years_more_than_four_games
ORDER BY avg_critic_score DESC; 

--Task6
--Returns years with ten highest avg_user_score values.
SELECT g.year, COUNT(g.game) AS num_games, ROUND(AVG(r.user_score),2) AS avg_user_score
FROM game_sales as g
INNER JOIN reviews as r
ON g.game = r.game
GROUP BY g.year
HAVING COUNT(g.game) > 4
ORDER BY avg_user_score DESC
LIMIT 10;

--Task7
--Create a list of years that appear on both the top_critic_years_more_than_four_games table and the top_user_years_more_than_four_games table.
SELECT year
FROM top_critic_years_more_than_four_games
INTERSECT
SELECT year
FROM top_user_years_more_than_four_games;

--Task7
--Add a column showing total games_sold in each year to the table you created in the previous task.
SELECT g.year, SUM(g.games_sold) AS total_games_sold
FROM game_sales as g
WHERE g.year IN (SELECT year
FROM top_critic_years_more_than_four_games
INTERSECT
SELECT year
FROM top_user_years_more_than_four_games)
GROUP BY g.year
ORDER BY total_games_sold DESC;