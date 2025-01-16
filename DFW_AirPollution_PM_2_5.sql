-- This Query gives you info about PM 2.5/Air Pollution in Dallas-Fort Worth

/* PM 2.5 is a form of air pollution that consists of tiny particles, these particles can cause a variety
of health issues, examples: Lung cancer, heart disease, difficulty breathing and more. */

-- Allows you to select all of the columns

SELECT * FROM dbo.PMPollutant;
 
-- According the EPA anything above 35 micrograms per cubic meter for 24 hours is considered high

SELECT * FROM 
(SELECT Date, Local_Site_Name, CONCAT(Daily_Mean_PM2_5_Concentration, ' ', Units) AS Concentration
    FROM dbo.PMPollutant
) AS Subquery
WHERE CAST(SUBSTRING(Concentration, 1, CHARINDEX(' ', Concentration) - 1) AS FLOAT) > 35
ORDER BY Concentration ASC;

---------------------------------------------------------------------------------------------------

-- Created a new column that combines the concentration with units

ALTER TABLE dbo.PMPollutant
ADD Concentration nvarchar(255);

UPDATE dbo.PMPollutant
SET Concentration = CONCAT(Daily_Mean_PM2_5_Concentration, ' ', Units);

----------------------------------------------------------------------------------------------------

-- Bexar Street had a high Concentration level for one day, as well as Multiple days where the Daily Air Quality level was high too
-- CHARDINDEX is used to find the starting position of a substring within a string
-- CAST is used to convert a value from one data type to another
-- SUBSTRING is used to extract a portion of a string on a specified starting position and length

SELECT Date, Local_Site_Name, State, County, Concentration, Daily_AQI_Value
FROM dbo.PMPollutant
WHERE Local_Site_Name = 'Dallas Bexar Street'
ORDER BY CAST(SUBSTRING(Concentration, 1, CHARINDEX(' ', Concentration) -1) AS FLOAT) DESC;

----------------------------------------------------------------------------------------------------

-- Added a month column

SELECT DATENAME(MONTH, Date) as Month
FROM dbo.PMPollutant;


ALTER TABLE dbo.PMPollutant
ADD Month nvarchar(255);

UPDATE dbo.PMPollutant
SET Month  = DATENAME(MONTH, Date);

---------------------------------------------------------------------------------


-- Adding a column to state what the EPA considers the quality of the air



SELECT Daily_AQI_Value,
       CASE 
           WHEN Daily_AQI_Value > 300 THEN 'Hazardous'
           WHEN Daily_AQI_Value > 200 THEN 'Very Unhealthy'
           WHEN Daily_AQI_Value > 150 THEN 'Unhealthy'
           WHEN Daily_AQI_Value > 100 THEN 'Unhealthy for Sensitive Groups'
           WHEN Daily_AQI_Value > 50 THEN 'Moderate'
           ELSE 'Good'
       END AS Status
FROM dbo.PMPollutant;


ALTER TABLE dbo.PMPollutant
ADD Status nvarchar(255)

UPDATE dbo.PMPollutant
        SET Status = CASE 
           WHEN Daily_AQI_Value > 300 THEN 'Hazardous'
           WHEN Daily_AQI_Value > 200 THEN 'Very Unhealthy'
           WHEN Daily_AQI_Value > 150 THEN 'Unhealthy'
           WHEN Daily_AQI_Value > 100 THEN 'Unhealthy for Sensitive Groups'
           WHEN Daily_AQI_Value > 50 THEN 'Moderate'
           ELSE 'Good'
 	       END;


-- Air Quality at 100 is acceptable by could be an issue to sensitive groups

SELECT Date, County, Local_Site_Name, Daily_AQI_Value
FROM dbo.PMPollutant
WHERE Daily_AQI_Value > 100
ORDER BY Date;

-- PM 2.5 levels are considered unhealthy when they reach 55.5–125.4 micrograms per cubic meter 

SELECT Date, County, Local_Site_Name, Daily_Mean_PM2_5_Concentration
FROM dbo.PMPollutant
WHERE Daily_Mean_PM2_5_Concentration > 55
ORDER BY Date;



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- The following code below will be used towards creating a dashboard

-- Graph 1, Demonstrating the Monthly Average by County

SELECT County, Month, AVG(Daily_AQI_Value) AS Monthly_Average
FROM dbo.PMPollutant
GROUP BY County, Month
ORDER BY County, 
         CASE 
             WHEN Month = 'January' THEN 1
             WHEN Month = 'February' THEN 2
             WHEN Month = 'March' THEN 3
             WHEN Month = 'April' THEN 4
             WHEN Month = 'May' THEN 5
             WHEN Month = 'June' THEN 6
             WHEN Month = 'July' THEN 7
             WHEN Month = 'August' THEN 8
             WHEN Month = 'September' THEN 9
             WHEN Month = 'October' THEN 10
             WHEN Month = 'November' THEN 11
             WHEN Month = 'December' THEN 12
         END;

------------------------------------------------------------------------------------------------------------------------

-- Graph 2, Look at the Average Daily AQI Level by County/Local_Site_Name


SELECT County, Local_Site_Name, Site_Latitude, Site_Longitude, AVG(Daily_AQI_Value) AS Average_Air_Quality
FROM dbo.PMPollutant
GROUP BY County, Local_Site_Name, Site_Latitude, Site_Longitude;

------------------------------------------------------------------------------------------------------------------------

-- Graph 3, This graph looks at the Average PM 2.5 Levels by County as well as the site the levels were recorded at.


SELECT Local_Site_Name, County, AVG(Daily_Mean_PM2_5_Concentration) AS Average_Concentration
FROM dbo.PMPollutant
GROUP BY Local_Site_Name, County
ORDER BY County, Local_Site_Name;


------------------------------------------------------------------------------------------------------------------------

-- Graph 4, Looking at the Average PM 2.5 Levels by Month based on County

SELECT Month, AVG(Daily_Mean_PM2_5_Concentration) AS Average_Monthly_Concentration
FROM dbo.PMPollutant
GROUP BY Month
ORDER BY 
    CASE 
        WHEN Month = 'January' THEN 1
        WHEN Month = 'February' THEN 2
        WHEN Month = 'March' THEN 3
        WHEN Month = 'April' THEN 4
        WHEN Month = 'May' THEN 5
        WHEN Month = 'June' THEN 6
        WHEN Month = 'July' THEN 7
        WHEN Month = 'August' THEN 8
        WHEN Month = 'September' THEN 9
        WHEN Month = 'October' THEN 10
        WHEN Month = 'November' THEN 11
        WHEN Month = 'December' THEN 12
    END ASC;


--------------------------------------------------------------------------------------------------------------------------
