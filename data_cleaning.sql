-- DATA CLEANING --------------------------------------------------------------

SELECT * FROM world_life_expectancy;

-- Identifying Duplicates

SELECT Country, Year, Concat(Country, Year), count(Concat(Country, Year))
FROM world_life_expectancy
GROUP BY Country, Year, Concat(Country, Year)
HAVING count(Concat(Country, Year)) > 1
;

-- Identifying Duplicates by Row Number

SELECT * 
FROM (
	SELECT Row_ID, 
	Concat(Country, Year),
	ROW_NUMBER() OVER(PARTITION BY Concat(Country, Year) ORDER BY Concat(Country, Year)) AS Row_Num
	FROM world_life_expectancy
    ) AS Row_table
WHERE Row_Num > 1
;

-- Deleting Duplicates by Row Number

DELETE FROM world_life_expectancy
WHERE 
	Row_ID IN ( SELECT Row_ID 
				FROM (
					SELECT Row_ID, 
					Concat(Country, Year),
					ROW_NUMBER() OVER(PARTITION BY Concat(Country, Year) ORDER BY Concat(Country, Year)) AS Row_Num
					FROM world_life_expectancy
					) AS Row_table
				WHERE Row_Num > 1
)
;


-- Identifying Blanks/Nulls in Status Column

SELECT * FROM world_life_expectancy
WHERE Status = ''
;

SELECT DISTINCT(Status)
FROM world_life_expectancy
WHERE Status <> ''
;


SELECT DISTINCT(Country)
FROM world_life_expectancy
WHERE Status = 'Developing'
;


-- Populating Blanks/Nulls in "Status" Column

-- error:
UPDATE world_life_expectancy
SET Status = 'Developing'
WHERE Country IN (
				SELECT DISTINCT(Country)
				FROM world_life_expectancy
				WHERE Status = 'Developing')
;

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developing'
;

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developed'
;

-- 
SELECT * FROM world_life_expectancy;
--
ALTER TABLE world_life_expectancy
RENAME COLUMN `Life expectancy` TO life_expentancy;
--


-- Populating Blanks/Nulls in "life_expentancy" Column

SELECT t1.Country, t1.Year, t1.life_expentancy, 
t2.Country, t2.Year, t2.life_expentancy,
t3.Country, t3.Year, t3.life_expentancy,
round((t2.life_expentancy + t3.life_expentancy)/2,1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year -1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year +1
WHERE t1.life_expentancy = ''
;

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year -1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year +1
SET t1.life_expentancy = round((t2.life_expentancy + t3.life_expentancy)/2,1)
WHERE t1.life_expentancy = ''
;

-- 

SELECT * FROM world_life_expectancy
;