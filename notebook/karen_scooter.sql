--Scooters table 
SELECT *
FROM scooters
Limit 100

--Trips table with trip duration of 1 min and up
SELECT *
FROM trips
Where tripduration < 1
LIMIT 50
---- 

--How many scooters per company
Select companyname, Count(sumdid)
From scooters
Group by companyname

-- Are there any null values in any columns in either table?
SELECT *
FROM scooters
WHERE NOT (scooters IS NOT NULL)
-- Answer 770


--- What date range is represented in each of the date columns? Investigate any values that seem odd.
-- SELECT MIN (pubdatetime)::DATE || ' to '  || MAX(pubdatetime)::DATE AS date_range
-- FROM scooters


SELECT MIN(pubdatetime), MAX(pubdatetime)
 FROM scooters;
 
--Answer 01/05/2019 -07/31/2019

--- Is time represented with am/pm or using 24 hour values in each of the columns that include time?

--Answer using 24 hour values

-- What values are there in the sumdgroup column? Are there any that are not of interest for this project?
SELECT Distinct (sumdgroup)
FROM scooters
--Answer bicycle


-- What are the minimum and maximum values for all the latitude and longitude columns? Do these ranges make sense, or is there anything surprising?
SELECT MAX(latitude), Max(longitude), Min(latitude), Min(longitude)
FROM scooters

-- Answer 3609874.116666 Max(lat)	0.000000 Min(long)	0.000000 Min(latitude)	-97.443879 Min(long)


-- What is the range of values for trip duration and trip distance? Do these values make sense? Explore values that might seem questionable.
SELECT latitude, longitude
FROM scooters
--Answer

-- Check out how the values for the company name column in the scooters table compare to those of the trips table. What do you notice?
SELECT companyname
FROM scooters
--union companyname
--Answer

--** Once you've gotten an understanding of what is contained in the available tables, start with addressing these questions:

SELECT startdate, tripduration, starttime, enddate
FROM trips;
---------------------

WITH nobike AS
(SELECT DISTINCT sumdid
FROM scooters
WHERE sumdgroup iLIKE 'bicycle'
)
SELECT *
FROM trips
WHERE sumdid NOT IN (SELECT sumdid FROM nobike)

--------------------------
******************************************************************************************************************************

COPY public."summer" to 'D:\summer.CSV' DELIMITER ',' CSV HEADER;
d

CREATE TABLE summer
  AS (
	  WITH filter_id AS (SELECT sumdid
				FROM trips
				GROUP BY sumdid
				HAVING COUNT(sumdid) = 1
					AND ((SUM(tripdistance) <= 0) OR (SUM(tripduration) <= 0)))
					
SELECT *
FROM scooters
WHERE EXTRACT(MONTH FROM pubdatetime) IN ('5','6','7')
	AND sumdgroup != 'bicycle'
	AND sumdid NOT IN (SELECT sumdid FROM filter_id)
	AND latitude BETWEEN 36.0 AND 36.3
	AND longitude BETWEEN -86.9 AND -86.2
	 
	);
	
SELECT EXTRACT(MONTH FROM pubdatetime) AS month, companyname, COUNT(*) AS count FROM scooters GROUP BY month, companyname ORDER BY month, companyname	
******************************************************************************************************************************
										``
--1. During this period, seven companies offered scooters. How many scooters did each company have in this time frame? Did the number for each company change over time? Did scooter usage vary by company?
SELECT companyname, sumdid, sumdgroup, Count(companyname)
FROM scooters
GROUP BY companyname, sumdid, sumdgroup
LIMIT 100
-- run query

SELECT companyname, Count(companyname)
FROM scooters
GROUP BY companyname
--run query

	
/*2. According to Second Substitute Bill BL2018-1202 (as amended) (https://web.archive.org/web/20181019234657/https://www.nashville.gov/Metro-Clerk/Legislative/Ordinances/Details/7d2cf076-b12c-4645-a118-b530577c5ee8/2015-2019/BL2018-1202.aspx), all permitted operators will first clean data before providing or reporting data to Metro. Data processing and cleaning shall include:  
* Removal of staff servicing and test trips  
* Removal of trips below one minute  
* Trip lengths are capped at 24 hours  
Are the scooter companies in compliance with the second and third part of this rule? */
SELECT Distinct companyname
FROM Trips
WHERE Tripduration < 1 OR
Tripduration > 1440

/*CREATE TABLE summer
  AS (
	  WITH filter_id AS (SELECT sumdid
				FROM trips
				GROUP BY sumdid
				HAVING COUNT(sumdid) = 1
					AND ((SUM(tripdistance) <= 0) OR (SUM(tripduration) <= 0)))
					
SELECT *
FROM scooters
WHERE EXTRACT(MONTH FROM pubdatetime) IN ('5','6','7')
	AND sumdgroup != 'bicycle'
	AND sumdid NOT IN (SELECT sumdid FROM filter_id)
	AND latitude BETWEEN 36.0 AND 36.3
	AND longitude BETWEEN -86.9 AND -86.2*/
	
SELECT DISTINCT(companyname), COUNT(tripduration)
FROM trips
WHERE tripduration > 1440
GROUP BY companyname;

--Answer find the count, three company that are not compliant 



--3. The goal of Metro Nashville is to have each scooter used a minimum of 3 times per day. Based on the data, what is the average number of trips per scooter per day? Make sure to consider the days that a scooter was available. How does this vary by company?

SELECT companyname, sumdid, CAST(pubdatetime AS DATE) as date, COUNT(*) AS total
FROM scooters	  
GROUP BY companyname, sumdid, CAST(pubdatetime AS DATE)
--Answer 
	  
	  

--4. Metro would like to know how many scooters are needed, and something that could help with this is knowing peak demand. Estimate the highest count of scooters being used at the same time. When were the highest volume times? Does this vary by zip code or other geographic region?
SELECT
      sumdid,
      companyname,
      COUNT(DISTINCT triprecordnum) AS trips
    FROM
      trips
    WHERE
       tripduration BETWEEN 1 AND 1440
    GROUP BY
      sumdid,
      companyname
--Answer

WITH scoot_dates AS (
SELECT sumdid, CAST(pubdatetime AS date) AS dd, companyname
  FROM scooters)
SELECT sumdid, companyname, COUNT(DISTINCT dd) AS days
FROM scoot_dates
GROUP BY sumdid, companyname
--5. **Stretch Goal:** SUMDs can provide alternative transportation and provide "last mile" access to public transit. How often are trips starting near public transit hubs? You can download a dataset of bus stop locations from https://data.nashville.gov/Transportation/WeGo-Transit-Bus-Stops/vfe9-k7vc/about_data.
SELECT
FROM
--Answer


/*Deliverables:
At the conclusion of this project, your group should deliver a presentation which addresses the following points:
* Are scooter companies in compliance with the required data cleaning?
* What are typical usage patterns for scooters in terms of time, location, and trip duration?
* What are your recommendations for total number of scooters for the city overall and density of scooters by zip code?
* **Stretch Goal:** Does it appear that scooters are used as "last mile" transportation from public transit hubs to work or school?


