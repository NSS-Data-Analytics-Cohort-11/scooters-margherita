-- explore data
Select *
FROM scooters LIMIT 10;
-- 9 columns

SELECT *
FROM trips LIMIT 10; 
-- 16 columns

-- find nulls
SELECT *
FROM scooters
WHERE NOT (scooters IS NOT NULL);
-- 770 rows all nulls in chargelevel column, IS NULL doesn't work

SELECT *
FROM trips
WHERE NOT (trips IS NOT NULL);
-- No null values in trips

-- find date range
SELECT MAX(pubdatetime), MIN(pubdatetime)
FROM scooters;
-- "2019-07-31"	"2019-05-01"

SELECT MAX(pubtimestamp), MIN(pubtimestamp)
FROM trips;
-- The trips range goes to August 1st where the scooters table only goes to JULY 31st

-- Is time represented with am/pm or using 24 hour values in each of the columns that include time?
-- FROM previous code we see that time is listed in 24 hour values in both date columns

-- What values are there in the sumdgroup column? Are there any that are not of interest for this project?
SELECT distinct sumdgroup
FROM scooters;
-- "bicycle", "scooter", "Scooter" bicycles are not of interest

-- remove the bicycles and fix the capital S
SELECT
	CASE WHEN sumdgroup = 'Scooter' THEN 'scooter'
	ELSE 'scooter'
	END AS sumdgroup_clean
FROM scooters
WHERE sumdgroup <> 'bicycle';
-- 73414043 before 73387514 after

-- select the bicycle rows
SELECT *
FROM scooters
WHERE sumdgroup = 'bicycle';

SELECT *
FROM trips
WHERE sumdid NOT LIKE 'standard';

-- What are the minimum and maximum values for all the latitude and longitude columns? Do these ranges make sense, or is there anything surprising? 
--What is the range of values for trip duration and trip distance? Do these values make sense? Explore values that might seem questionable.
SELECT latitude, longitude