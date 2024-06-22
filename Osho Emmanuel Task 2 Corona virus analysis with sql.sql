-- OSHO EMMANUEL OLUWASEYI
-- TASK 2 Corona Virus Analysiswith SQL

USE corona_virus;

-- Province: Geographic subdivision within a country/region.
-- Country/Region: Geographic entity where data is recorded.
-- Latitude: North-south position on Earth's surface.
-- Longitude: East-west position on Earth's surface.
-- Date: Recorded date of CORONA VIRUS data.
-- Confirmed: Number of diagnosed CORONA VIRUS cases.
-- Deaths: Number of CORONA VIRUS related deaths.
-- Recovered: Number of recovered CORONA VIRUS cases.

SELECT * FROM corona_virus.`corona virus dataset`;

-- Q1. Write a code to check NULL values
SELECT * 
FROM `corona virus dataset`
WHERE `Province` IS NULL
   OR `Country/Region` IS NULL
   OR `Latitude` IS NULL
   OR `Longitude` IS NULL
   OR `Date` IS NULL
   OR `Confirmed` IS NULL
   OR `Deaths` IS NULL
   OR `Recovered` IS NULL;

-- Q2. If NULL values are present, update them with zeros for all columns. 

SET SQL_SAFE_UPDATES = 0;

UPDATE `corona virus dataset`
SET `Province` = COALESCE(`Province`, ''),
    `Country/Region` = COALESCE(`Country/Region`, ''),
    `Latitude` = COALESCE(`Latitude`, 0),
    `Longitude` = COALESCE(`Longitude`, 0),
    `Date` = COALESCE(`Date`, '1970-01-01'),
    `Confirmed` = COALESCE(`Confirmed`, 0),
    `Deaths` = COALESCE(`Deaths`, 0),
    `Recovered` = COALESCE(`Recovered`, 0);
    
    SET SQL_SAFE_UPDATES = 1;
    
    -- Q3. check total number of rows
    SELECT COUNT(*) AS total_rows
FROM `corona virus dataset`;

-- Q4. Check what is start_date and end_date
SELECT MIN(`Date`) AS start_date, MAX(`Date`) AS end_date
FROM `corona virus dataset`;

-- Q5. Number of month present in dataset
SELECT COUNT(DISTINCT DATE_FORMAT(`Date`, '%Y-%m')) AS total_months
FROM `corona virus dataset`;

SET SQL_SAFE_UPDATES = 0;

UPDATE `corona virus dataset`
SET `Date` = STR_TO_DATE(`Date`, '%d-%m-%Y');

SELECT COUNT(DISTINCT DATE_FORMAT(`Date`, '%Y-%m')) AS total_months
FROM `corona virus dataset`;

-- Q6. Find monthly average for confirmed, deaths, recovered
SELECT DATE_FORMAT(`Date`, '%Y-%m') AS month,
       AVG(`Confirmed`) AS avg_confirmed,
       AVG(`Deaths`) AS avg_deaths,
       AVG(`Recovered`) AS avg_recovered
FROM `corona virus dataset`
GROUP BY month;

-- Q7. Find most frequent value for confirmed, deaths, recovered each month
SELECT t.month, t.Confirmed, t.Deaths, t.Recovered
FROM (
    SELECT DATE_FORMAT(`Date`, '%Y-%m') AS month,
           `Confirmed`, `Deaths`, `Recovered`,
           COUNT(*) AS cnt,
           ROW_NUMBER() OVER (PARTITION BY DATE_FORMAT(`Date`, '%Y-%m') ORDER BY COUNT(*) DESC) AS rnk
    FROM `corona virus dataset`
    GROUP BY month, `Confirmed`, `Deaths`, `Recovered`
) t
WHERE t.rnk = 1;

-- Q8. Find minimum values for confirmed, deaths, recovered per year
SELECT YEAR(`Date`) AS year,
       MIN(`Confirmed`) AS min_confirmed,
       MIN(`Deaths`) AS min_deaths,
       MIN(`Recovered`) AS min_recovered
FROM `corona virus dataset`
GROUP BY year;

-- Q9. Find maximum values of confirmed, deaths, recovered per year
SELECT YEAR(`Date`) AS year,
       MAX(`Confirmed`) AS max_confirmed,
       MAX(`Deaths`) AS max_deaths,
       MAX(`Recovered`) AS max_recovered
FROM `corona virus dataset`
GROUP BY year;

--  Q10 Total number of confirmed, deaths, recovered each month
SELECT 
    YEAR(`Date`) AS year,
    MONTH(`Date`) AS month,
    SUM(`Confirmed`) AS total_confirmed,
    SUM(`Deaths`) AS total_deaths,
    SUM(`Recovered`) AS total_recovered
FROM 
    `corona virus dataset`
GROUP BY 
    year, month
ORDER BY 
    year, month;
    
    -- Q11. Check how corona virus spread out with respect to confirmed case
SELECT 
    SUM(`Confirmed`) AS total_confirmed,
    AVG(`Confirmed`) AS avg_confirmed,
    VARIANCE(`Confirmed`) AS var_confirmed,
    STDDEV(`Confirmed`) AS stddev_confirmed
FROM `corona virus dataset`;

-- Q12. Check how corona virus spread out with respect to death case per month
SELECT DATE_FORMAT(`Date`, '%Y-%m') AS month,
       SUM(`Deaths`) AS total_deaths,
       AVG(`Deaths`) AS avg_deaths,
       VARIANCE(`Deaths`) AS var_deaths,
       STDDEV(`Deaths`) AS stddev_deaths
FROM `corona virus dataset`
GROUP BY month;

-- Q13. Check how corona virus spread out with respect to recovered case
SELECT 
    SUM(`Recovered`) AS total_recovered,
    AVG(`Recovered`) AS avg_recovered,
    VARIANCE(`Recovered`) AS var_recovered,
    STDDEV(`Recovered`) AS stddev_recovered
FROM `corona virus dataset`;

-- Q14. Find Country having highest number of the Confirmed case
SELECT `Country/Region`,
       SUM(`Confirmed`) AS total_confirmed
FROM `corona virus dataset`
GROUP BY `Country/Region`
ORDER BY total_confirmed DESC
LIMIT 1;

-- Q15. Find Country having lowest number of the death case
SELECT `Country/Region`,
       SUM(`Deaths`) AS total_deaths
FROM `corona virus dataset`
GROUP BY `Country/Region`
ORDER BY total_deaths ASC
LIMIT 1;

-- Q16. Find top 5 countries having highest recovered case
SELECT `Country/Region`,
       SUM(`Recovered`) AS total_recovered
FROM `corona virus dataset`
GROUP BY `Country/Region`
ORDER BY total_recovered DESC
LIMIT 5;