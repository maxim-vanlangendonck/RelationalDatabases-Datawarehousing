--- SQL Review --- 
-- 1. There how many different musical Styles?
SELECT COUNT(DISTINCT *) AS 'Number of different Musical Styles'
FROM Musical_Styles

-- 2. What is the number of available entertainers per style?
SELECT es.StyleID, ms.StyleName, COUNT(EntertainerID) AS NumberOfEntertainers
FROM Entertainer_Styles es JOIN Musical_Styles ms ON es.StyleID = ms.StyleID
GROUP BY es.StyleID, ms.StyleName
-- 3. What are the memebers that belong ot more than 1 entertainer?
SELECT m.MemberID, m.MbrFirstName + ' ' + m.MbrLastName AS 'NameOfMember', COUNT(DISTINCT EntertainerID) As NumberOfEntertainers
FROM Entertainer_Members em JOIN Members m ON em.MemberID = m.MemberID
GROUP BY m.MemberID, MbrFirstName + ' ' + MbrLastName
HAVING COUNT(DISTINCT EntertainerID) > 1

-- 4. What is the number of engagements per year and per entertainer? Use StartDate to determine the year. Order on the number of engagemetns in descending way.
-- 5. What is the total revenue for each entertainer per year? Use contractprice to calculate the revenue. Order on the total revenue in descending way.
-- 6. How many entertainers were entered per year? Order by year in ascending way
-- 7. Give for each agen the total income per year. An agent has a salary and a commision on the contractpice. Round the result to 2 decimals
-- 8. What is the number of male and female entertainers
	-- Extension: Gender = NULL is perhaps an entertainer that didn't want to reveal his gender. Change the previous solution into the following solution.
-- 9. What is the average number of members per entertainer per musical style. Only take into account StyleStrength = 1. Order by the everage number of memebers in descending way.
-- 10. What is number of entertainers each agent already worked with?
-- 11. What is number of agents each entertainer already worked with?
-- 12. What are the engagements for which the contractprice is 50% more expensive than the number of days * EntPricePerDay?
-- 13. What is the average price per musical style based on EntPricePerDay. Only tkae into account StyleStrength  = 1. Order by average price in descending way.
-- 14. What are the music styles for which we don't have any entertainer available in the database?
