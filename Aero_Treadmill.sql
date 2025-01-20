-- Query about Aerofit Treadmill

-- The KP281 is an entry-level treadmill that sells for $1,500;
-- The KP481 is for mid-level runners and sells for $1,750;
-- The KP781 treadmill is having advanced features and it sells for $2,500.

--Select all columns

SELECT * FROM dbo.aero_treadmill;

-- Average Age for the Product by Gender

SELECT Product, Gender, AVG(Age) as Average_Age
FROM dbo.aero_treadmill
GROUP BY Product, Gender
ORDER BY Product;

-- Determines the Average Fitness Level by Product

SELECT Product, AVG(Fitness) AS Average_Fitness_Level
FROM dbo.aero_treadmill
GROUP BY Product;


-- Determines Male and Female Count Per Product

SELECT 
Product,
COUNT(CASE WHEN Gender = 'Male' THEN 1 END) AS Male_Count,
COUNT(CASE WHEN Gender = 'Female' THEN 1 END) AS Female_Count
FROM dbo.aero_treadmill
GROUP BY Product;



-- Determines the count of Male and Females based on Marital Statuses and which demographics owns most of which machine

SELECT Product, Gender, MaritalStatus, COUNT(MaritalStatus) AS Total_MaritalStatus
FROM dbo.aero_treadmill
GROUP BY Product, Gender, MaritalStatus;

-- Average Income Level of individuals who own the Product

SELECT Product, AVG(Income) AS Average_Income
FROM dbo.aero_treadmill
GROUP BY Product;

-- Average Miles by Gender by Product

SELECT Product, Gender, AVG(Miles) AS Average_Miles
FROM dbo.aero_treadmill
GROUP BY Product, Gender
ORDER BY Product, Gender;

-- Amount of each Product sold

SELECT Product, COUNT(Product) AS Sum_of_Product_Sold
FROM dbo.aero_treadmill
GROUP BY Product;

-- Adding a table with the cost of each product

ALTER TABLE dbo.aero_treadmill
ADD Product_Cost NVARCHAR(255);

UPDATE dbo.aero_treadmill
SET Product_Cost =
CASE WHEN Product = 'KP281' THEN '1500'
     WHEN Product = 'KP481' THEN '1750'
	 WHEN Product = 'KP781' THEN '2500'
	 END;


-- Looking at how much each Product made Age and Product Type

 SELECT Product, SUM(CAST(Product_Cost AS FLOAT)) As Total_Amount
 FROM dbo.aero_treadmill
 GROUP BY Product;

 -- By Age & Gender KP281

 SELECT Product, Age, Gender, COUNT(Product) AS Total_Sold, SUM(CAST(Product_Cost AS FLOAT)) As Total_Amount
 FROM dbo.aero_treadmill
 WHERE Product = 'KP281'
 GROUP BY Product, Age, Gender
 ORDER BY Age;

  -- By Age & Gender KP481

 SELECT Product, Age, Gender, COUNT(Product) AS Total_Sold, SUM(CAST(Product_Cost AS FLOAT)) As Total_Amount
 FROM dbo.aero_treadmill
 WHERE Product = 'KP481'
 GROUP BY Product, Age, Gender
 ORDER BY Age;

  -- By Age & Gender KP781

 SELECT Product, Age, Gender, COUNT(Product) AS Total_Sold, SUM(CAST(Product_Cost AS FLOAT)) As Total_Amount
 FROM dbo.aero_treadmill
 WHERE Product = 'KP781'
 GROUP BY Product, Age, Gender
 ORDER BY Age;


 -- Amount sold by Fitness level and Average income level by Fitness Level

 SELECT Fitness, COUNT(Product) AS Total_Sold, AVG(Income) AS Average_Fitness_Level_Income
 FROM dbo.aero_treadmill
 GROUP BY Fitness;

 -- Using this formula, you can see people with a Fitness Level of 2-3 are most likely to purchase a machine, meanwhile for the higher end model you will see a fitness level 5 purchasing the machine
 -- The Average Income from low to mid level machine seems to be between $38000 - 50000, while the higher level is $67000-77000
 -- Based on data you will only see Fitness Levels of 3 and above looking at the higher end machine, while all Levels were looking at all three products

 SELECT Product, Fitness,  COUNT(Product) AS Total_Sold, AVG(Income) AS Average_Fitness_Level_Income
 FROM dbo.aero_treadmill
 GROUP BY Product, Fitness
 ORDER BY Product;


 -- Total Amount Spent each Gender spent on each Product

 SELECT Product, Gender, SUM(CAST(Product_Cost AS FLOAT)) AS Total_Amount
 FROM dbo.aero_treadmill
 GROUP BY Product, Gender
 ORDER BY Product;

 -- See how many Men and Women are in this data table

 SELECT Gender, COUNT(Gender) AS Total_Gender
 FROM dbo.aero_treadmill
 GROUP BY Gender;

 -- Total Sold based on Age

 SELECT Age, Gender, COUNT(Product) AS Total_Sold
 FROM dbo.aero_treadmill
 GROUP BY Age, Gender
 ORDER BY Age;



-- Dashboard Data Below 

-- Product & Gender Sold

 SELECT Product, Age, Gender, COUNT(Product) AS Total_Sold, SUM(CAST(Product_Cost AS FLOAT)) AS Total_Amount
 FROM dbo.aero_treadmill
 GROUP BY Product, Gender, Age
 ORDER BY Product;


 SELECT Product, Fitness, Age, Gender, COUNT(Product) AS Total_Sold
 FROM dbo.aero_treadmill
 GROUP BY Product, Age, Gender, Fitness
 ORDER BY Age;


 

