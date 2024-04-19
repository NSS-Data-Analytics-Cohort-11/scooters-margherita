SELECT *
FROM scooters
LIMIT 5;
-- 9 columns
--  73414043 rows

SELECT *
FROM trips
LIMIT 5;
-- 16 columns
-- 565522 rows

/***** Are there any null values in any columns in either table? ****/
SELECT *
FROM scooters
WHERE NOT (scooters IS NOT NULL);
-- 770 rows contain atleast 1 null in scooters

SELECT *
FROM trips
WHERE NOT (trips IS NOT NULL);
-- 0 rows contain atleast 1 null in trips

/***** What date range is represented in each of the date columns? Investigate any values that seem odd. *****/
SELECT MIN(pubdatetime)::DATE || ' to ' || MAX(pubdatetime)::DATE AS date_range
FROM scooters;
-- "2019-05-01 to 2019-07-31" for scooters

SELECT MIN(pubtimestamp)::DATE || ' to ' || MAX(pubtimestamp)::DATE AS date_range
FROM trips;
-- "2019-05-01 to 2019-08-01" for trips

SELECT *
FROM trips
WHERE enddate = (SELECT MAX(enddate) FROM trips);

/***** Is time represented with am/pm or using 24 hour values in each of the columns that include time? *****/
-- 		24 hour time	 

/***** What values are there in the sumdgroup column? Are there any that are not of interest for this project? *****/
SELECT CASE
		WHEN sumdgroup = 'scooter' THEN 'scooter'
		ELSE 'scooter'
			END AS sumdgroupclean
FROM scooters
WHERE sumdgroup != 'bicycle';
-- 73387514 rows

-- remove bikes from trips table
WITH bikes AS 
				(
				SELECT DISTINCT sumdid
				FROM scooters
				WHERE sumdgroup = 'bicycle' 
				)
				
SELECT sumdid
FROM trips
WHERE sumdid NOT IN (SELECT sumdid FROM bikes)

/***** What are the minimum and maximum values for all the latitude and longitude columns? Do these ranges make sense, or is there anything surprising? *****/
SELECT MIN(latitude) AS min_lat,
		MAX(latitude) AS max_lat,
		MIN(longitude) AS min_lon,
		MAX(longitude) AS max_lon
FROM scooters
-- 0.000000	3609874.116666	-97.443879	0.000000

SELECT MIN(startlatitude) AS min_lat,
		MAX(startlatitude) AS max_lat,
		MIN(startlongitude) AS min_lon,
		MAX(startlongitude) AS max_lon,
		MIN(endlatitude) AS endmin_lat,
		MAX(endlatitude) AS endmax_lat,
		MIN(endlongitude) AS endmin_lon,
		MAX(endlongitude) AS endmax_lon
FROM trips

/**** What is the range of values for trip duration and trip distance? Do these values make sense? Explore values that might seem questionable. ****/
SELECT MIN(tripduration),
		MAX(tripduration),
		MIN(tripdistance),
		MAX(tripdistance)
	FROM trips
	
/**** Check out how the values for the company name column in the scooters table compare to those of the trips table. What do you notice?
 ****/
 SELECT DISTINCT companyname
 FROM scooters
 
  SELECT DISTINCT companyname
 FROM trips
--  bolt vs bolt mobility, capitalization.


/********* 1 ********/
/* During this period, seven companies offered scooters. How many scooters did each company have in this time frame? Did the number for each company change over time? Did scooter usage vary by company? */
SELECT *
FROM scooters 
WHERE companyname iLike 'Bird'
	AND EXTRACT(MONTH FROM pubdatetime) = 5
	AND sumdgroup != 'bicycle'
-- 	4334006

WITH filter_id AS (SELECT sumdid
				FROM trips
				GROUP BY sumdid
				HAVING COUNT(sumdid) = 1
					AND ((SUM(tripdistance) <= 0) OR (SUM(tripduration) <= 0)))
					
SELECT *
FROM scooters
WHERE companyname iLike 'Bird'
	AND EXTRACT(MONTH FROM pubdatetime) = 5
	AND sumdgroup != 'bicycle'
	AND sumdid NOT IN (SELECT sumdid FROM filter_id)
