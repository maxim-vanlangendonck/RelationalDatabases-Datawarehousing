-- Exercise 1
-- Create the following overview. First give the SQL statement, then use a cursor to get the following layout
/*
Africa
 - Number of countries =         54
 - Total population = 1,371,687,302
Asia
 - Number of countries =         49
 - Total population = 4,646,440,014
Europe
 - Number of countries =         51
 - Total population = 750,877,952
North America
 - Number of countries =         34
 - Total population = 592,829,053
Oceania
 - Number of countries =         16
 - Total population = 42,898,029
South America
 - Number of countries =         12
 - Total population = 433,950,159
*/

SELECT continent, COUNT(DISTINCT country) AS Number_Of_Countries, SUM(CAST(population AS BIGINT)) AS Total_Population
FROM countries
GROUP BY continent

DECLARE @continent varchar(100), @number_of_countries int, @total_population bigint

DECLARE corona_cursor_5 CURSOR FOR
SELECT continent, COUNT(DISTINCT country) AS Number_Of_Countries, 
SUM(CAST(population AS BIGINT)) AS Total_Population
FROM countries
GROUP BY continent

OPEN corona_cursor_5
FETCH NEXT FROM corona_cursor_5 INTO @continent, @number_of_countries, @total_population
WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT @continent
		PRINT ' - Number of countries = ' +
str(@number_of_countries)
		PRINT ' - Total population = ' + 
format(@total_population, 'N0')
		FETCH NEXT FROM corona_cursor_5 INTO @continent, 
		@number_of_countries, @total_population
	END
CLOSE corona_cursor_5

DEALLOCATE corona_cursor_5


-- Exercise 2: Give per continent a list with the 5 countries with the highest number of deaths
-- Step 1: Give a list of all continents. First give the SQL statement, then use a cursor to get the following layout
-- - Africa
-- - Asia
-- - Europe
-- - North America
-- - Oceania
-- - South America

--sql statement
SELECT DISTINCT continent
FROM Countries
--cursor
DECLARE @continent varchar(50)

DECLARE cursor_corona_3 CURSOR FOR
SELECT DISTINCT continent
FROM Countries

OPEN cursor_corona_3
FETCH NEXT FROM cursor_corona_3 INTO @continent

WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT ' - ' + @continent
		FETCH NEXT FROM cursor_corona_3 INTO @continent
	END

CLOSE cursor_corona_3
DEALLOCATE cursor_corona_3

-- Step 2: Give the countries with the highest number of deaths for Africa. First give the SQL statement, then use a cursor to get the following layout
-- South Africa      87001
-- Tunisia      24732
-- Egypt      17149
-- Morocco      14132
-- Algeria       5767
DECLARE @country varchar(50), @new_deaths int

DECLARE cursor_corona_4 CURSOR FOR
SELECT TOP 5 c.Country, SUM(ISNULL(cd.new_deaths, 0))
FROM Countries c JOIN CovidData cd ON c.Country = cd.Country
WHERE c.continent = 'Africa'
GROUP BY c.country
ORDER BY 2 DESC;

OPEN cursor_corona_4

FETCH NEXT FROM cursor_corona_4 INTO @country, @new_deaths

WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT  @country + ' ' + str(@new_deaths)
		FETCH NEXT FROM cursor_corona_4 INTO @country, @new_deaths
	END
CLOSE cursor_corona_4
DEALLOCATE cursor_corona_4
		
	END
-- Step 3: Combine both cursors to get the following result
/*
 - Africa
South Africa      87001
Tunisia      24732
Egypt      17149
Morocco      14132
Algeria       5767
 - Asia
India     446658
Indonesia     141381
Iran     119082
Turkey      62938
Philippines      37405
 - Europe
Russia     199450
United Kingdom     136465
Italy     130653
France     117157
Germany      93398
 - North America
United States     687746
Mexico     274703
Canada      27690
Guatemala      13331
Honduras       9679
 - Oceania
Australia       1231
Fiji        590
Papua New Guinea        225
New Zealand         27
Vanuatu          1
 - South America
Brazil     594200
Peru     199228
Colombia     126102
Argentina     114849
Chile      37432
*/
OPEN cursor_corona_3 INTO @continent

-- Step 4: Replace the TOP 5 values by a cte with dense_rank





-- Exercise 3
-- Make the following, visual overview for the total number of new_cases / 500 for Belgium for each week starting from 2021-01-01
-- This makes it more clear which are the weeks with a lot of new_cases
-- Use the function REPLICATE to get the x's
/*
- 1    xxxxx
- 2    xxxxxxxxxxxxxxxxxxxxxxxxxxx
- 3    xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
- 4    xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
- 5    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
- 6    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
- 7    xxxxxxxxxxxxxxxxxxxxxxxxxx
- 8    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
- 9    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
- 10    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
- 11    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
- 12    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
- 13    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
- 14    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
- 15    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
- 16    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
- 17    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
- 18    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
- 19    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
- 20    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
- 21    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
- 22    xxxxxxxxxxxxxxxxxxxxxxxxx
- 23    xxxxxxxxxxxxxxxxxxxx
- 24    xxxxxxxxxxx
- 25    xxxxxx
- 26    xxxxxx
- 27    xxxxxxxx
- 28    xxxxxxxxxxxxxx
- 29    xxxxxxxxxxxxxxxxxxx
- 30    xxxxxxxxxxxxxxxxxxxx
- 31    xxxxxxxxxxxxxxxxxxxxxx
- 32    xxxxxxxxxxxxxxxxxxxxxxxx
- 33    xxxxxxxxxxxxxxxxxxxxxxxxxx
- 34    xxxxxxxxxxxxxxxxxxxxxxxxxxx
- 35    xxxxxxxxxxxxxxxxxxxxxxxxxxxx
- 36    xxxxxxxxxxxxxxxxxxxxxxxxxxxx
- 37    xxxxxxxxxxxxxxxxxxxxxxxxxxx
- 38    xxxxxxxxxxxxxxxxxxxxxxxxxxxx
- 39    xxxxxxxxxxxxxxxxxxxxxxxxxxx
*/
-- Declaratie van cursor
DECLARE corona_cursor CURSOR
FOR
SELECT DATEPART(week, report_date), SUM(new_cases) / 500
FROM CovidData
WHERE country = 'Belgium' and report_date >= '2021-01-01'
GROUP BY DATEPART(week, report_date)

DECLARE @weeknumber INT, @sumNewCases INT

--OPEN cursor
OPEN corona_cursor

-- fetch data
FETCH NEXT FROM corona_cursor INTO @weeknumber, @sumNewCases

WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT str(@weekNumber, 2) + ' ' + REPLICATE('x', @sumNewCases)
		FETCH NEXT FROM corona_cursor INTO @weekNumber, @sumNewCases
	END
	
-- close cursor
CLOSE corona_cursor

-- deallocate cursor
DEALLOCATE corona_cursor
-- Exercise 4
-- Give an overview of all the golfs: startdate + enddate + number of deaths
-- We define the beginning (ending) of a golf 
-- when the 14 days moving average of positive_rate becomes >= (<) 0.06
/*
Het begin van golf          1: 2020-03-07 00:00:00.0000
Het einde van golf          1: 2020-05-05 00:00:00.0000
Het aantal cases:      50400
Het aantal deaths:       8016
Het begin van golf          2: 2020-10-05 00:00:00.0000
Het einde van golf          2: 2021-01-14 00:00:00.0000
Het aantal cases:     542651
Het aantal deaths:      10230
Het begin van golf          3: 2021-02-25 00:00:00.0000
Het einde van golf          3: 2021-05-21 00:00:00.0000
Het aantal cases:     283803
Het aantal deaths:       2821
*/

-- declare cursor
DECLARE corona_cursor CURSOR
FOR
SELECT report_date, new_cases, new_deaths, AVG(positive_rate) OVER (ORDER BY report_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
FROM CovidData
WHERE country = 'Belgium'

DECLARE @report_date datetime2(7), @new_cases INT, @new_deaths INT, @avg_pos_rate float
DECLARE @total_new_cases INT = 0, @total_new_deaths INT = 0, @in_golf BIT = 0, @teller INT = 0

-- open cursor
OPEN corona_cursor

-- fetch data
FETCH NEXT FROM corona_cursor INTO @report_date, @new_cases, @new_deaths, @avg_pos_rate

WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @in_golf = 0 AND @avg_pos_rate >= 0.06
		BEGIN
			SET @in_golf = 1
			SET @teller += 1
			SET @total_new_cases = ISNULL(@new_cases, 0)
			SET @total_new_deaths = ISNULL(@new_deaths, 0)
			PRINT 'Begin van golf ' + str(@teller) + ' ---> ' + FORMAT(@report_date, 'dd-MM-yyyy')
		END
		ELSE IF @in_golf = 1 AND @avg_pos_rate < 0.06
		BEGIN
			SET @in_golf = 0
			SET @total_new_cases += ISNULL(@new_cases, 0)
			SET @total_new_deaths += ISNULL(@new_deaths, 0)
			PRINT 'Einde van golf ' + str(@teller) + ' ---> ' + FORMAT(@report_date, 'dd-MM-yyyy')
			PRINT 'Het totaal aantal cases ' + str(@total_new_cases)
			PRINT 'Het totaal aantal doden ' + str(@total_new_deaths)
			PRINT ''
		END
		ELSE IF @in_golf = 1 AND @avg_pos_rate >= 0.06
		BEGIN
			SET @total_new_cases += ISNULL(@new_cases, 0)
			SET @total_new_deaths += ISNULL(@new_deaths, 0)
		END
		FETCH NEXT FROM corona_cursor INTO @report_date, @new_cases, @new_deaths, @avg_pos_rate
	END

-- close cursor
CLOSE corona_cursor

-- deallocate cursor
DEALLOCATE corona_cursor