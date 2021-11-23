-- How many countries can be found in the dataset?
SELECT COUNT(country) AS 'Number of Countries'
FROM dbo.Countries

-- Give the total population per continent
SELECT continent, SUM(population) AS 'Total population'
FROM dbo.Countries
WHERE population IS NOT NULL
GROUP BY continent

-- Which country with more than 1 000 000 inhabitants, has the highest lfe expectancy?
SELECT MAX(life_expectancy) AS 'Highest life expectancy'
FROM Countries
WHERE population > 1000000
