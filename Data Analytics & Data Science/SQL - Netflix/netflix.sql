-- Count the Total Number of Users: Write a SQL query to count the total number of users in the database.
SELECT *
FROM `new_schema`.`netflix_userbase`;

-- Calculate Average Age of Users: Find the average age of all users.
SELECT Country, AVG(Age) as Average_Age
FROM `new_schema`.`netflix_userbase` 
GROUP BY Country
ORDER BY Country;

SELECT Device, AVG(Age) as Average_Age
FROM `new_schema`.`netflix_userbase` 
GROUP BY Device
ORDER BY Device;

-- List All Subscription Types: Get a distinct list of all subscription types available.
SELECT DISTINCT(Device)
FROM `new_schema`.`netflix_userbase` ;

-- Sum Monthly Revenue: Calculate the total monthly revenue from all users.
SELECT SUM(`Monthly Revenue`) AS Total_Monthly_Revenue
FROM `new_schema`.`netflix_userbase`;

-- Find Users with Missing Data: Identify any users that have null or missing values in any of the critical columns like Monthly Revenue or Subscription Type.
SELECT `User ID`, `Monthly Revenue`, `Subscription Type`
FROM `new_schema`.`netflix_userbase`
WHERE `Monthly Revenue` IS NULL
OR `Monthly Revenue` = 0
OR `Subscription Type` IS NULL;

-- Device Usage Statistics: Determine the percentage of users using each type of device.
SELECT Device, 
COUNT(Device) * 100 / (SELECT COUNT(*) FROM `new_schema`.`netflix_userbase`) AS Percentage_of_users
FROM `new_schema`.`netflix_userbase`
GROUP BY Device
ORDER BY Percentage_of_users;
 

-- Revenue Growth Month-over-Month: Calculate the percentage growth in revenue month-over-month.
SELECT
    YEAR(`Last Payment Date`) AS RevenueYear,
    MONTH(`Last Payment Date`) AS RevenueMonth,
    SUM(`Monthly Revenue`) AS MonthlyRevenue,
    LAG(SUM(`Monthly Revenue`), 1) OVER (ORDER BY YEAR(`Last Payment Date`), MONTH(`Last Payment Date`)) AS PreviousMonthRevenue,
    (SUM(`Monthly Revenue`) - LAG(SUM(`Monthly Revenue`), 1) OVER (ORDER BY YEAR(`Last Payment Date`), MONTH(`Last Payment Date`))) / NULLIF(LAG(SUM(`Monthly Revenue`), 1) OVER (ORDER BY YEAR(`Last Payment Date`), MONTH(`Last Payment Date`)), 0) * 100 AS MonthOverMonthGrowthPercentage
FROM
    `new_schema`.`netflix_userbase`
GROUP BY
    RevenueYear,
    RevenueMonth
ORDER BY
    RevenueYear,
    RevenueMonth;

-- Cohort Analysis: Perform a cohort analysis to understand the behavior of users based on their join date.
WITH MonthlyRevenue AS (
    SELECT
        `User ID`,
        DATE_FORMAT(`Join Date`, '%Y-%m') AS Cohort,
        DATE_FORMAT(`Last Payment Date`, '%Y-%m') AS RevenueMonth,
        `Monthly Revenue`
    FROM
        `new_schema`.`netflix_userbase`
),
CohortSizes AS (
    SELECT
        Cohort,
        COUNT(DISTINCT `User ID`) AS CohortSize
    FROM
        MonthlyRevenue
    GROUP BY
        Cohort
)
SELECT
    a.Cohort,
    a.RevenueMonth,
    COUNT(DISTINCT a.`User ID`) AS ActiveUsers,
    SUM(a.`Monthly Revenue`) AS TotalRevenue,
    b.CohortSize,
    COUNT(DISTINCT a.`User ID`) / b.CohortSize * 100 AS RetentionRate
FROM
    MonthlyRevenue a
JOIN
    CohortSizes b ON a.Cohort = b.Cohort
GROUP BY
    a.Cohort,
    a.RevenueMonth,
    b.CohortSize
ORDER BY
    a.Cohort,
    a.RevenueMonth;


-- Average Plan Duration by Country: Find the average plan duration for users, grouped by country.
SELECT 
    Country,
    AVG(`Plan Duration`) AS AveragePlanDuration
FROM 
    `new_schema`.`netflix_userbase`
GROUP BY 
    Country
ORDER BY 
    AveragePlanDuration DESC;
    
-- Lifetime Value of a Customer (LTV): Calculate the LTV of customers based on their monthly payments and plan duration.
SELECT 
    Country,
    AVG(`Monthly Revenue` * `Plan Duration`) AS AverageLTV
FROM 
    `new_schema`.`netflix_userbase`
GROUP BY 
    Country
ORDER BY
	AverageLTV DESC;

-- Segmented Revenue Analysis: Analyze the revenue by creating user segments based on age, country, and subscription type.
SELECT 
    AgeSegment,
    Country,
    `Subscription Type`,
    COUNT(DISTINCT `User ID`) AS TotalUsers,
    SUM(`Monthly Revenue`) AS TotalRevenue,
    AVG(`Monthly Revenue`) AS AverageRevenue
FROM (
    SELECT
        `User ID`,
        `Monthly Revenue`,
        `Subscription Type`,
        Country,
        CASE 
            WHEN Age BETWEEN 0 AND 18 THEN '0-18'
            WHEN Age BETWEEN 19 AND 30 THEN '19-30'
            WHEN Age BETWEEN 31 AND 45 THEN '31-45'
            WHEN Age BETWEEN 46 AND 60 THEN '46-60'
            ELSE '60+' END AS AgeSegment
    FROM 
        `new_schema`.`netflix_userbase`
) AS SegmentedData
GROUP BY 
    AgeSegment,
    Country,
    `Subscription Type`
ORDER BY 
    TotalRevenue DESC;


-- User Clustering for Marketing: Cluster users into different groups for targeted marketing based on their behavior and subscription details.
SELECT 
    `Subscription Type`,
    `Plan Duration`,
    RevenueCategory,
    COUNT(*) AS UserCount
FROM (
    SELECT 
        `User ID`,
        `Subscription Type`,
        `Plan Duration`,
        `Monthly Revenue`,
        CASE
            WHEN `Monthly Revenue` < 10 THEN 'Low'
            WHEN `Monthly Revenue` >= 10 AND `Monthly Revenue` < 20 THEN 'Medium'
            WHEN `Monthly Revenue` >= 20 THEN 'High'
            ELSE 'Unknown' 
        END AS RevenueCategory
    FROM 
        `new_schema`.`netflix_userbase`
) AS UserRevenue
GROUP BY 
    `Subscription Type`,
    `Plan Duration`,
    RevenueCategory
ORDER BY 
    `Subscription Type`, 
    `Plan Duration`, 
    RevenueCategory;


-- Anomaly Detection in Payments: Identify any anomalies in the payment amounts or frequencies indicating potential fraud or system errors.
SET @rowindex := -1;

WITH OrderedRevenues AS (
    SELECT
        `Monthly Revenue`,
        @rowindex:=@rowindex + 1 AS `rowindex`,
        COUNT(*) OVER() AS total_rows
    FROM 
        `new_schema`.`netflix_userbase`
    ORDER BY 
        `Monthly Revenue`
),
Quartiles AS (
    SELECT 
        MAX(CASE WHEN `rowindex` = FLOOR(total_rows * 0.25) THEN `Monthly Revenue` END) AS Q1,
        MAX(CASE WHEN `rowindex` = FLOOR(total_rows * 0.75) THEN `Monthly Revenue` END) AS Q3
    FROM 
        OrderedRevenues
),
IQRData AS (
    SELECT 
        Q1,
        Q3,
        Q3 - Q1 AS IQR
    FROM 
        Quartiles
)
SELECT 
    n.`Monthly Revenue`,
    i.Q1,
    i.Q3,
    i.IQR,
    i.Q1 - 1.5 * i.IQR AS LowerBound,
    i.Q3 + 1.5 * i.IQR AS UpperBound
FROM 
    `new_schema`.`netflix_userbase` n
CROSS JOIN 
    IQRData i
WHERE 
    n.`Monthly Revenue` < (i.Q1 - 1.5 * i.IQR) OR n.`Monthly Revenue` > (i.Q3 + 1.5 * i.IQR);

