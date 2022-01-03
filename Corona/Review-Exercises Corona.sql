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

-- Calculate the average life_expectancy for each continent
-- Take into account the population for each country

-- Give the country with the highest number of Corona deaths


-- On which day was 50% of the Belgians fully vaccinated?


-- On which day the first Belgian received a vaccin?


-- On which day the first Corona death was reported in Europe?


-- What is the estimated total amount of smokers in Belgium?
-- Subtract 2 000 000 children from the total Belgian population


-- The first lockdown in Belgium started on 18 march 2020. Give all the data until 21 days afterwards
-- to be able to check if the lockdown had any effect.


-- In which month (month + year) the number of deaths was the highest in Belgium?