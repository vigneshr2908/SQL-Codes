SELECT * FROM athlete_events
WHERE ID<200

--6. Identify the sport which was played in all summer olympics.
--   Problem Statement: SQL query to fetch the list of all sports which have been part of every Summer olympics.

-- 6.1 Find total no. summer olympic games
-- 6.2 Find all the sports games played in summer olympic games
-- 6.3 Compare the above 2

Select Count (Distinct Games) AS 'Total_Summer_Olympics'
from athlete_events
where Season = 'Summer'

With t1 as
	(Select Count (Distinct Games) AS 'total_games'
from athlete_events
where Season = 'Summer'
),
t2 as 
	(SELECT Sport, Count (Distinct Games) As 'no_games'
	FROM athlete_events
	Group By Sport
)

Select Sport, total_games, no_games
from t1 Join t2 on t1.total_games = t2.no_games

-- 11. Fetch the top 5 athletes who have won the most gold medals.
-- 11.1 Athletes who have won the most gold medals

With t1 as (
	Select Name, count(1) As 'Total_gold_medals' from athlete_events
	where Medal = 'Gold'
	Group By Name),

t2 as 
	( Select *, dense_rank() over(Order by Total_gold_medals desc) as rnk
	from t1)

Select Name , Total_gold_medals from t2
where rnk <= 5

--Method 2:

Select * from (
Select Name, count(Medal) As 'Total_gold_medals', 
dense_rank() Over(Order by count(Medal) Desc) as rnk
from athlete_events
where Medal = 'Gold'
Group By Name) as t1
where rnk <= 5
order by rnk asc

-- 14. List down total gold, silver and bronze medals won by each country.

SELECT * FROM   
	(
	Select nr.region, Medal from athlete_events AS ae
	join noc_regions AS nr on ae.NOC = nr.NOC
	--where Medal in ('Gold', 'Silver', 'Bronze')
	where Medal <> 'NA'
	) AS t1
PIVOT 
	(
	count(Medal) 
	For Medal in ( [Gold], [Silver], [Bronze])
	) pivot_table
order by Gold desc, Silver, Bronze 
--Ans 3

SELECT *
FROM (
 SELECT nr.region, medal
 FROM athlete_events ae INNER JOIN noc_regions nr
  ON ae.noc = nr.noc
 WHERE medal <> 'NA'
) t1
PIVOT(COUNT(medal) FOR medal in ([Gold], [Silver], [Bronze])) pt
ORDER BY gold+silver+bronze DESC

Select OH.Region,
Count(Case When O.Medal='Gold' Then 1 End) AS Gold,
Count(Case When O.Medal='Silver' Then 1 End) AS Silver,
Count(Case When O.Medal='Bronze' Then 1 End) AS Bronze
from athlete_events O
Join noc_regions OH On OH.NOC = O.NOC 
Group by OH.Region
Order By Gold Desc,Silver Desc,Bronze Desc