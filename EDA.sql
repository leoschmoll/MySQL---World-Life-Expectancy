-- EXPLORATORY DATA ANALYSIS (EDA) --------------------------------------------------------------

SELECT * FROM world_life_expectancy;

-- Lowest and Highest life expectancy

SELECT Country, min(life_expentancy), max(life_expentancy)
FROM world_life_expectancy
GROUP BY Country
HAVING min(life_expentancy) <> 0
AND max(life_expentancy) <> 0
ORDER BY Country DESC
;


-- smallest and biggest alteration of life expectancy

SELECT Country, 
min(life_expentancy), 
max(life_expentancy),
round(max(life_expentancy) - min(life_expentancy),1) AS life_exp_increase_15Y
FROM world_life_expectancy
GROUP BY Country
HAVING min(life_expentancy) <> 0
AND max(life_expentancy) <> 0
ORDER BY life_exp_increase_15Y DESC
;

SELECT Country, 
min(life_expentancy), 
max(life_expentancy),
round(max(life_expentancy) - min(life_expentancy),1) AS life_exp_increase_15Y
FROM world_life_expectancy
GROUP BY Country
HAVING min(life_expentancy) <> 0
AND max(life_expentancy) <> 0
ORDER BY life_exp_increase_15Y ASC
;


-- life expectancy by each year

SELECT Year, round(avg(life_expentancy),2) AS average_li_exp
FROM world_life_expectancy
WHERE life_expentancy <> 0
GROUP BY Year
ORDER BY Year ASC
;


-- correlation between GDP and life expectancy

SELECT Country, round(avg(life_expentancy),1) AS life_exp, round(avg(GDP),1) AS GDP
FROM world_life_expectancy
GROUP BY Country
HAVING life_exp > 0 
AND GDP > 0
ORDER BY GDP DESC
;


SELECT
sum(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) AS High_GDP_count,
ROUND(avg(CASE WHEN GDP >= 1500 THEN life_expentancy ELSE NULL END),1) AS High_GDP_life_exp,
sum(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) AS Low_GDP_count,
ROUND(avg(CASE WHEN GDP <= 1500 THEN life_expentancy ELSE NULL END),1) AS Low_GDP_life_exp
FROM world_life_expectancy
;


-- life expectancy accordingly the Quantity and Status of countries

SELECT Status, COUNT(DISTINCT Country), round(AVG(life_expentancy),1)
FROM world_life_expectancy
GROUP BY Status
;


-- Body Mass Index (BMI) by countries

SELECT Country, round(avg(life_expentancy),1) AS life_exp, round(avg(BMI),1) AS BMI
FROM world_life_expectancy
GROUP BY Country
HAVING life_exp > 0 
AND BMI > 0
ORDER BY BMI DESC
;

-- 
SELECT * FROM world_life_expectancy;
--
ALTER TABLE world_life_expectancy
RENAME COLUMN `Adult Mortality` TO adult_mortality;
--

-- Adult Mortality over the Years by countries compared to the life expectancy

SELECT Country
Year,
life_expentancy,
adult_mortality,
SUM(adult_mortality) OVER(PARTITION BY Country ORDER BY Year) AS adult_mort_accumulated
FROM world_life_expectancy
WHERE Country = 'Argentina'
;