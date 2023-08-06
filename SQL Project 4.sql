#How many olympics games have been held?
Select count(games) as "total_games_held" from athlete_events;

#List down all Olympics games held so far.
select year, season, city from athlete_events;

#Mention the total no of nations who participated in each olympics game?
select a.games, count(n.region) AS "Total_countries" from athlete_events a inner join noc_regions n on a.noc=n.noc
group by a.games;

#Which year saw the highest and lowest no of countries participating in olympics
with ct as(
select a.games as "lowest_countries", count(n.region) AS "Count" from athlete_events a inner join noc_regions n on a.noc=n.noc
group by a.games 
order by count(n.region) asc
limit 1),

act as(
select a.games as "highest_countries", count(n.region) AS "count" from athlete_events a inner join noc_regions n on a.noc=n.noc
group by a.games 
order by count(n.region) desc
limit 1)

select ct.lowest_countries, ct.count, act.highest_countries, act.count from ct,act;

#Which nation has participated in all of the olympic games



#Identify the sport which was played in all summer olympics.
with cte as(
select sport, count(distinct(games)) as "number_of_games" from athlete_events where season= "summer" group by sport),

bte as(
select count(distinct(games)) as "total_games" from athlete_events where season= "summer")

select*from cte join bte on cte.number_of_games=bte.total_games;

#Which Sports were just played only once in the olympics.
with ate as(
select games, sport, count(games) as "number_of_games" from athlete_events group by sport, games)

select ate.games, ate.sport, ate.number_of_games from ate where ate.number_of_games=1;


##Fetch the total no of sports played in each olympic games.
select games, count(sport) from athlete_events group by games;


#Fetch oldest athletes to win a gold medal
select age, name, sex, team, games, city, sport, event, medal from athlete_events where medal= "gold"
order by age desc
limit 2;

# Find the Ratio of male and female athletes participated in all olympic games.
With cte as(
select count(sex) as "male" from athlete_events where sex= "M"),
gte as(
select count(sex) as "female" from athlete_events where sex= "F")

select round((cte.male/gte.female),2) as "sex_ratio" from cte, gte;

#Fetch the top 5 athletes who have won the most gold medals.
select name, team, count(medal) as "total_gold_medals" from athlete_events where medal= "gold"
group by name, team
order by count(medal) desc
limit 5;

#Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).
select name, team, count(medal) as "total_medals" from athlete_events
group by name, team
order by count(medal) desc
limit 5;


#Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won
select n.region, count(a.medal) as "total_medals", dense_rank() over(order by count(a.medal) desc) as "rank"
from athlete_events a inner join noc_regions n on a.noc= n.noc
group by n.region
limit 5;

#List down total gold, silver and bronze medals won by each country.
with cte as(
select n.region as "country", count(medal="gold" or null) as gold, count(medal= "silver"or null) as silver, count("bronze"or null) as bronze from athlete_events a inner join noc_regions n on a.noc=n.noc group by n.region)
select country, gold, silver, bronze from cte ;

## In which Sport/event, India has won highest medals.
select a.sport, count(a.medal) as "total_medals" from athlete_events a inner join noc_regions n
on a.noc= n.noc
where n.region= "India"
group by a.sport
order by count(a.medal) desc
limit 1;

#Break down all olympic games where India won medal for Hockey and how many medals in each olympic games
select team, sport, games, count(medal) as "total_medals" from athlete_events 
where team= "India"
AND sport= "hockey"
group by team, sport, games;

## Which countries have never won gold medal but have won silver/bronze medals?
Select n.region from athlete_events a inner join noc_regions n on a.noc= n.noc
where a.medal not in("gold");













