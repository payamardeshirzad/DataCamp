/*
Advanced subquery

For each of the six continents listed in 2015, you'll identify which country had the maximum inflation rate (and how high it was) using multiple subqueries. 
The table result of your query in Task 3 should look something like the following, where anything between < > will be filled in with appropriate values:

+------------+---------------+-------------------+
| name       | continent     | inflation_rate    |
|------------+---------------+-------------------|
| <country1> | North America | <max_inflation1>  |
| <country2> | Africa        | <max_inflation2>  |
| <country3> | Oceania       | <max_inflation3>  |
| <country4> | Europe        | <max_inflation4>  |
| <country5> | South America | <max_inflation5>  |
| <country6> | Asia          | <max_inflation6>  |
+------------+---------------+-------------------+
Again, there are multiple ways to get to this solution using only joins, but the focus here is on showing you an introduction into advanced subqueries.
*/


SELECT name, continent, inflation_rate
  FROM countries
	INNER JOIN economies
	on countries.code = economies.code
  WHERE year = 2015
    and inflation_rate in (
        SELECT MAX(inflation_rate) AS max_inf
        FROM (
             SELECT name, continent, inflation_rate
             FROM countries
             INNER JOIN economies
             using (code)
             WHERE year = 2015) AS subquery
        GROUP BY continent);




/*
Final challenge
Yyou'll need to get the country names and other 2015 data in the economies table and the countries table for Central American countries with an official language.
*/

SELECT DISTINCT c.name, e.total_investment, e.imports
  FROM countries AS c
    LEFT JOIN economies AS e
      ON (c.code = e.code
        AND c.code IN (
          SELECT l.code
          FROM languages AS l
          WHERE official = 'true'
        ))
  WHERE c.region = 'Central America' AND e.year = 2015
ORDER BY c.name;

------------------------
/*
Final challenge (2)

Let's ease up a bit and calculate the average fertility rate for each region in 2015.
*/

SELECT c.region, c.continent, avg(p.fertility_rate) AS avg_fert_rate
  FROM countries AS c
    INNER JOIN populations AS p
      ON c.code = p.country_code
  WHERE year = 2015
GROUP BY c.region, c.continent
ORDER BY avg_fert_rate;

--Final challenge (3)
--You are now tasked with determining the top 10 capital cities in Europe and the Americas in terms of a calculated percentage using city_proper_pop and metroarea_pop in cities.

SELECT cities.name, country_code, city_proper_pop, metroarea_pop,  
     city_proper_pop  / metroarea_pop * 100 AS city_perc
  FROM cities
  WHERE name IN
    (SELECT capital
     FROM countries
     WHERE (continent = 'Europe'
        OR continent LIKE '%America'))
       AND metroarea_pop IS not null
ORDER BY city_perc desc
Limit 10;