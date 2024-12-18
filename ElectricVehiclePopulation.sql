--Selects the table
SELECT * FROM dbo.Electric_Vehicle_Population_Data

--View which Car Models sold the most by: Make, Model, and Year
--EVPD is the Alias for dbo.Electric_Vehicle_Population_Data

SELECT EVPD.Make, EVPD.Model, EVPD.Model_Year, COUNT(EVPD.Model) AS Total_Models
FROM dbo.Electric_Vehicle_Population_Data AS EVPD
GROUP BY EVPD.Make, EVPD.Model, EVPD.Model_Year
ORDER BY Total_Models DESC;

--Adds County, City, State to the table
SELECT EVPD.County,EVPD.City, EVPD.State, EVPD.Make, EVPD.Model, EVPD.Model_Year,
COUNT(EVPD.Model) AS Total_Models
FROM dbo.Electric_Vehicle_Population_Data AS EVPD
GROUP BY EVPD.County,EVPD.City, EVPD.State, EVPD.Make, EVPD.Model, EVPD.Model_Year
ORDER BY Total_Models DESC;

--Removes Tesla and adds only Washington to see which cars sold the most in the state

SELECT EVPD.County,EVPD.City, EVPD.State, EVPD.Make, EVPD.Model, EVPD.Model_Year,
COUNT(EVPD.Model) AS Total_Models
FROM dbo.Electric_Vehicle_Population_Data AS EVPD
WHERE NOT EVPD.Make ='Tesla'
AND State = 'WA'
GROUP BY EVPD.County,EVPD.City, EVPD.State, EVPD.Make, EVPD.Model, EVPD.Model_Year
ORDER BY Total_Models DESC;

--View Model, Make, Model_Year and see the Electric Vehicle Type

SELECT Distinct (EVPD.Model) AS Car_Model, EVPD.Make, EVPD.Model_Year, EVPD.Electric_Vehicle_Type
FROM dbo.Electric_Vehicle_Population_Data as EVPD
ORDER BY EVPD.Model, EVPD.Make, EVPD.Model_Year ASC

--Shows Base Price for Cars based on Make, Model, and Year, excludes any vehicles witha Base_MSRP (Value) of 0

SELECT EVPD.Model_Year, EVPD.Make, EVPD.Model, EVPD.Base_MSRP
FROM dbo.Electric_Vehicle_Population_Data AS EVPD
WHERE EVPD.Base_MSRP IS NOT NULL
AND EVPD.Base_MSRP > 0
GROUP BY EVPD.Model_Year, EVPD.Make, EVPD.Model, EVPD.Base_MSRP
ORDER BY EVPD.Base_MSRP DESC

--View which cities in the state of Washington have the most Teslas

SELECT DISTINCT EVPD.City, EVPD.State, EVPD.Make,
COUNT(EVPD.Model) AS Total_Models
FROM dbo.Electric_Vehicle_Population_Data AS EVPD
WHERE EVPD.Make ='Tesla'
AND State = 'WA'
GROUP BY EVPD.City, EVPD.State, EVPD.Make
ORDER BY Total_Models DESC;

--Created an Index to improve data retrieval speed

CREATE INDEX Location
ON dbo.Electric_Vehicle_Population_Data (City, State);

--View Total Amount of Electric Vehicle Types by State

SELECT EVPD.State, EVPD.Electric_Vehicle_Type, COUNT(EVPD.Electric_Vehicle_Type) AS Total_Electric_Type
FROM dbo.Electric_Vehicle_Population_Data AS EVPD
GROUP BY EVPD.Electric_Vehicle_Type, EVPD.State
ORDER BY EVPD.State ASC;

--Create View to store data for later use

CREATE VIEW ElectricVehiclePopulation AS
SELECT EVPD.County, EVPD.City, EVPD.State, EVPD.Make, EVPD.Model, EVPD.Model_Year, LEN(EVPD.Make) as Total_Cars,
COUNT(EVPD.Model) AS Total_Models
FROM dbo.Electric_Vehicle_Population_Data AS EVPD
GROUP BY EVPD.County, EVPD.City, EVPD.State, EVPD.Make, EVPD.Model, EVPD.Model_Year;

--Drops view that was created above if needed

DROP VIEW dbo.ElectricVehiclePopulation

--Query the view

SELECT * FROM ElectricVehiclePopulation

