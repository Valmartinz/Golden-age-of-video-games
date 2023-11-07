# Golden-age-of-video-games
This project analyzes critic and user ratings data, along with sales data, for the top 400 video games released since 1977. Our mission is to find a possible 'golden age' of video games, exploring the years when both critics and players were most satisfied. We will use data analysis skills, such as data set union and set theory, to achieve this.

## Requirements
- Postgresql 15
- pgAdmin 4

## Databases
ER Model

![ER](Img/ER_model.png)

## Queries
- ## The ten best-selling video games
```
SELECT *
FROM game_sales
ORDER BY games_sold DESC
LIMIT 10;
```
![TASK1](Img/Task1.png)

- ## Missing review scores
```
SELECT COUNT(g.game)
FROM game_sales as g
LEFT JOIN reviews as r
ON g.game = r.game
WHERE critic_score IS NULL AND user_score IS NULL;
```
![TASK2](Img/Task2.png)

- ## Years that video game critics loved
```
SELECT year, ROUND(AVG(critic_score),2) AS avg_critic_score
FROM game_sales as g
LEFT JOIN reviews as r
ON g.game = r.game
GROUP BY year
ORDER BY avg_critic_score DESC
LIMIT 10;
```
![TASK3](Img/Task3.png)

- ## Was 1982 really that great?
```
SELECT g.year, COUNT(g.game) AS num_games, ROUND(AVG(r.critic_score),2) AS avg_critic_score
FROM game_sales as g
INNER JOIN reviews as r
ON g.game = r.game
GROUP BY g.year
HAVING COUNT(g.game) > 4
ORDER BY avg_critic_score DESC
LIMIT 10;
```
![TASK4](Img/Task4.png)

- ## Years that dropped off the critics' favorites list
```
SELECT year, avg_critic_score
FROM top_critic_years
EXCEPT
SELECT year, avg_critic_score
FROM top_critic_years_more_than_four_games
ORDER BY avg_critic_score DESC;
```
![TASK5](Img/Task5.png)

- ## Years video game players loved
```
SELECT g.year, COUNT(g.game) AS num_games, ROUND(AVG(r.user_score),2) AS avg_user_score
FROM game_sales as g
INNER JOIN reviews as r
ON g.game = r.game
GROUP BY g.year
HAVING COUNT(g.game) > 4
ORDER BY avg_user_score DESC
LIMIT 10;
```
![TASK6](Img/Task6.png)

- ## Years that both players and critics loved
```
SELECT year
FROM top_critic_years_more_than_four_games
INTERSECT
SELECT year
FROM top_user_years_more_than_four_games;
```
![TASK7](Img/Task7.png)

- ## Sales in the best video game years
```
SELECT g.year, SUM(g.games_sold) AS total_games_sold
FROM game_sales as g
WHERE g.year IN (SELECT year
FROM top_critic_years_more_than_four_games
INTERSECT
SELECT year
FROM top_user_years_more_than_four_games)
GROUP BY g.year
ORDER BY total_games_sold DESC;
```
![TASK8](Img/Task8.png)

## Technology Stack
- Postgresql 15
