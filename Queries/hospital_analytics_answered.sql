-- Connect to database (MySQL only)
USE hospital_db;

-- OBJECTIVE 1: ENCOUNTERS OVERVIEW

-- a. How many total encounters occurred each year?
SELECT 
	YEAR(START) Year, 
    COUNT(distinct(ID))
FROM 
	Encounters
GROUP BY 
	YEAR
ORDER BY 
	YEAR;
    
-- b. For each year, what percentage of all encounters belonged to each encounter class
-- (ambulatory, outpatient, wellness, urgent care, emergency, and inpatient)?
SELECT 
	year(START) Year, 
		ENCOUNTERCLASS, 
			ROUND(count(*) * 100 / SUM(COUNT(*)) OVER (PARTITION BY YEAR(START)),2) AS Percentage
FROM 
	hospital_db.encounters
GROUP BY 
	Year, 
    ENCOUNTERCLASS
ORDER BY 
	Year, 
    ENCOUNTERCLASS;

-- c. What percentage of encounters were over 24 hours versus under 24 hours?
SELECT 
	CASE
		WHEN timestampdiff(HOUR, START, STOP) >= 24 THEN 'Over 24 Hours'
        ELSE 'Under 24 Hours'
	END AS Duration_Category,
    COUNT(*) as Encounter_Count,
    ROUND(COUNT(*) *100 / (SELECT COUNT(*) FROM encounters), 2) AS Percentage
FROM
	hospital_db.encounters
GROUP BY
	Duration_Category
ORDER BY
	Duration_Category ASC;

-- OBJECTIVE 2: COST & COVERAGE INSIGHTS

-- a. How many encounters had zero payer coverage, and what percentage of total encounters does this represent?
SELECT 
	COUNT(*) AS Zero_Payer_Coverage,
    ROUND(COUNT(*) *100 / (SELECT COUNT(*) FROM encounters),2) AS Percentage_of_Total
FROM
	hospital_db.encounters
WHERE
	PAYER_COVERAGE=0
    OR PAYER_COVERAGE IS NULL;

-- b. What are the top 10 most frequent procedures performed and the average base cost for each?
SELECT
    CODE,
    DESCRIPTION,
    count(*) AS Procedure_Count,
    ROUND(AVG(BASE_COST),2) AS AVG_BASE_COST
FROM
	hospital_db.procedures
GROUP BY 
	CODE, 
    DESCRIPTION
ORDER BY
	Procedure_Count DESC
LIMIT
	10;

-- c. What are the top 10 procedures with the highest average base cost and the number of times they were performed?
SELECT
    CODE,
    DESCRIPTION,
    ROUND(AVG(BASE_COST),2) AS AVG_BASE_COST,
    count(*) AS Procedure_Count
FROM
	hospital_db.procedures
GROUP BY 
	CODE, 
    DESCRIPTION
ORDER BY
	AVG_BASE_COST DESC
LIMIT
	10;

-- d. What is the average total claim cost for encounters, broken down by payer?
SELECT
	DISTINCT(p.Name) AS Name,
    ROUND(AVG(e.base_encounter_cost),2) AS Average_Encounter_Cost
FROM
	hospital_db.encounters e
LEFT JOIN
	hospital_db.payers p
    ON e.PAYER = p.Id
GROUP BY
	Name
ORDER BY
	Name ASC;

-- OBJECTIVE 3: PATIENT BEHAVIOR ANALYSIS

-- a. How many unique patients were admitted each quarter over time?
SELECT
	YEAR(START) as Year,
    QUARTER(START) as Quarter,
	COUNT(distinct(PATIENT)) as Unique_Patients
FROM
	encounters
GROUP BY
	YEAR, 
    QUARTER;

-- b. How many patients were readmitted within 30 days of a previous encounter?

-- c. Which patients had the most readmissions?

-- Will have to calculate how many times a particular patient has returned wihtin 30 days
-- Existing query shows the amount of times the patient has been admitted since 
SELECT
	p.First,
    p.Last,
    COUNT(DISTINCT(e.id)) AS Readmission
FROM
	hospital_db.encounters e
    LEFT JOIN
		hospital_db.patients p
			ON e.PATIENT = p.ID
GROUP BY
	p.FIRST,
    p.LAST
ORDER BY
	Readmission DESC;
		
