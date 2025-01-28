-- Select Data

SELECT * FROM dbo.Retail_Sales;


-- Changed Sales, Discount, Profit to two decimal places -----------------------------------------------

ALTER TABLE dbo.Retail_Sales
ALTER COLUMN Sales DECIMAL(20,2);

ALTER TABLE dbo.Retail_Sales
ALTER COLUMN Discount DECIMAL(20,2);

ALTER TABLE dbo.Retail_Sales
ALTER COLUMN Profit DECIMAL(20,2);


-- Top 10 Best Selling Product at the Store ------------------------------------------------------------

SELECT TOP 10 Product_ID, Product_Name, SUM(Quantity) AS Total_Quantity_Sold, SUM(Sales) AS Total_Revenue
FROM dbo.Retail_Sales
GROUP BY Product_ID, Product_Name
ORDER BY Total_Quantity_Sold DESC;

-- Total Sales by Month and Year -----------------------------------------------------------------------

SELECT FORMAT(Order_Date, 'yyyy') AS Sales_Month, DATENAME(MONTH, Order_Date) AS Month_Name,
SUM(Sales) AS Total_Sales
FROM DBO.Retail_Sales
GROUP BY FORMAT(Order_Date, 'yyyy'), DATENAME(MONTH, Order_Date), YEAR(Order_Date), MONTH(Order_Date)
ORDER BY YEAR(Order_Date), MONTH(Order_Date);

-- Added Year and Month column to the table ----------------------------------------------------------

ALTER TABLE DBO.Retail_Sales
ADD Year INT,
Month NVARCHAR(20);

UPDATE DBO.Retail_Sales
SET Year = YEAR(Order_Date),
Month = DATENAME(MONTH, Order_Date);

-- Top 10 Customers ------------------------------------------------------------------------------

SELECT TOP 10 Customer_ID, Customer_Name, SUM(Sales) AS Total_Spent
FROM Dbo.Retail_Sales
GROUP BY Customer_ID, Customer_Name
ORDER BY Total_Spent DESC;

-- Year over Year growth in Sales ------------------------------------------------------------------

WITH Yearly_Sales AS (
SELECT YEAR(Order_Date) AS Year, SUM(Sales) AS Total_Sales
FROM dbo.Retail_Sales
GROUP BY YEAR(Order_Date)
)
SELECT Year, Total_Sales, LAG(Total_Sales) OVER (ORDER BY Year) AS Previous_Year_Sales,
ROUND(CASE 
WHEN LAG(Total_Sales) OVER (ORDER BY Year) IS NULL THEN NULL
ELSE ((Total_Sales - LAG(Total_Sales) OVER (ORDER BY Year)) * 100.0 / LAG(Total_Sales) OVER (ORDER BY Year))
END, 2
) AS Year_Over_Year_Growth
FROM Yearly_Sales
ORDER BY Year;

-- Top Selling Regions ----------------------------------------------------------------------------------

SELECT TOP 5 Region, SUM(Sales) AS Total_Sales
FROM dbo.Retail_Sales
GROUP BY Region
ORDER BY Total_Sales DESC;

-- Customer Purchase Activity -------------------------------------------------------------------------

SELECT Customer_Name, COUNT(Order_ID) Total_Purchases,
SUM(Sales) AS Total_Spent
FROM dbo.Retail_Sales
GROUP BY Customer_Name
ORDER BY Total_Spent DESC;

-- Total Sales -----------------------------------------------------------------------------------------
SELECT SUM(Sales) as Total_Sales
FROM dbo.Retail_Sales;

-- Total Sales by Category ----------------------------------------------------------------------------

SELECT Category, SUM(Sales) AS Total_Sales
FROM dbo.Retail_Sales
GROUP BY Category
ORDER BY Total_Sales DESC;

