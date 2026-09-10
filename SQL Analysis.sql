SELECT TOP (10) [Country]
      ,[Year]
      ,[Total_Water_Consumption_Billion_Cubic_Meters]
      ,[Per_Capita_Water_Use_Liters_per_Day]
      ,[Agricultural_Water_Use]
      ,[Industrial_Water_Use]
      ,[Household_Water_Use]
      ,[Rainfall_Impact_Annual_Precipitation_in_mm]
      ,[Groundwater_Depletion_Rate]
      ,[Water_Scarcity_Level]
  FROM [Project].[dbo].[global_water_consumption]
 /*  =============================================================================
                             1. DATA QUALITY CHECKS
     ==============================================================================   */
  --Row Count
  SELECT COUNT(*)
  FROM [Project].[dbo].[global_water_consumption];
  
  SELECT Country, Year, COUNT(*) AS COUNT
  FROM [Project].[dbo].[global_water_consumption]
  GROUP BY Country, Year
  HAVING COUNT(*) > 1;

  SELECT DISTINCT [Water_Scarcity_Level]
  FROM [Project].[dbo].[global_water_consumption]
  
  /*  =====================================================================
                    2. OVERALL WATER CONSUMPTION
      =====================================================================  */

  SELECT SUM(Total_Water_Consumption_Billion_Cubic_Meters) AS TOTAL_CONSUMPTION,
  AVG(Total_Water_Consumption_Billion_Cubic_Meters) AS AVERAGE_CONSUMPTION,
  MIN(Total_Water_Consumption_Billion_Cubic_Meters) AS MINIMUM_CONSUMPTION,
  MAX(Total_Water_Consumption_Billion_Cubic_Meters) AS MAXIMUM_CONSUMPTION
  FROM [Project].[dbo].[global_water_consumption];

  /*  ===================================================================
                          3. COUNTRY WISE ANALYSIS
      ==================================================================== */
      --1. Total Consumption by Country
     SELECT Country, SUM(Total_Water_Consumption_Billion_Cubic_Meters) AS Total_Water_Consumption
     FROM [Project].[dbo].[global_water_consumption]
     GROUP BY Country
     ORDER BY Total_Water_Consumption DESC;
     --2. Average Consumption By Country
     SELECT Country, AVG(Total_Water_Consumption_Billion_Cubic_Meters) AS Average_Water_Consumption
     FROM [Project].[dbo].[global_water_consumption]
     GROUP BY Country
     ORDER BY Average_Water_Consumption DESC;
     --3. Top 5 Countries by consumption
     SELECT TOP (5) [Country],
     SUM(Total_Water_Consumption_Billion_Cubic_Meters) AS Total_Water_Consumption
     FROM [Project].[dbo].[global_water_consumption]
     GROUP BY Country
     ORDER BY Total_Water_Consumption DESC;
     --4. Bottom 5 Countries by Consumption
     SELECT TOP (5) [Country],
     SUM(Total_Water_Consumption_Billion_Cubic_Meters) AS Total_Water_Consumption
     FROM [Project].[dbo].[global_water_consumption]
     GROUP BY Country
     ORDER BY Total_Water_Consumption ASC;
     --5. Country Ranking By Consumptions
     SELECT Country,
     SUM(Total_Water_Consumption_Billion_Cubic_Meters) AS Total_Water_Consumption,
     DENSE_RANK() OVER (ORDER BY SUM(Total_Water_Consumption_Billion_Cubic_Meters) DESC) 
     AS Country_Rank
     FROM [Project].[dbo].[global_water_consumption]
     GROUP BY Country
     ORDER BY Country_Rank;

/*  ======================================================================
                        4. PER CAPITA WATER USE
    ======================================================================  */
    -- 1. Average Per Capita Water Use Globally
    SELECT AVG(Per_Capita_Water_Use_Liters_per_Day) AS Average_Per_Capita_Water_Use
    FROM [Project].[dbo].[global_water_consumption];
    
    --2. Highest per capita use
    SELECT MAX(Per_Capita_Water_Use_Liters_per_Day) AS Highest_Per_Capita_Water_Use
    FROM [Project].[dbo].[global_water_consumption];

    -- 3. Top 5 countries by per capita water use
    SELECT TOP (5) Country,
    AVG(Per_Capita_Water_Use_Liters_per_Day) AS Average_per_capita_water_use
    FROM [Project].[dbo].[global_water_consumption]
    GROUP BY Country
    ORDER BY Average_per_capita_water_use DESC;

    -- 4. Bottom 5 countries by per capita water use
    SELECT TOP (5) Country,
    AVG(Per_Capita_Water_Use_Liters_per_Day) AS Average_per_capita_use
    FROM [Project].[dbo].[global_water_consumption]
    GROUP BY Country
    ORDER BY Average_per_capita_use ASC;

    -- 5. Per capita use trend by year
    SELECT Year, 
    AVG(Per_Capita_Water_Use_Liters_per_Day) AS Average_per_capita_use
    FROM [Project].[dbo].[global_water_consumption]
    GROUP BY Year
    ORDER BY Year; 

    /* ===================================================================
                      5. SECTOR WISE WATER CONSUMPTION
       ===================================================================  */
       -- 1.Total water use by each sector
       SELECT SUM([Agricultural_Water_Use]) AS Total_Agricultural_Water_Use,
       SUM([Industrial_Water_Use]) AS Total_Industrial_Water_Use,
       SUM([Household_Water_Use]) AS Total_Household_Water_Use
       FROM [Project].[dbo].[global_water_consumption];

       -- 2.Average Water use by each sector
       SELECT AVG([Agricultural_Water_Use]) AS AVG_Agricultural_Water_Use,
       AVG([Industrial_Water_Use]) AS AVG_Industrial_Water_Use,
       AVG([Household_Water_Use]) AS AVG_Household_Water_Use
       FROM [Project].[dbo].[global_water_consumption];

       -- 3. Sector wise consumption by year
       SELECT Year,
       SUM([Agricultural_Water_Use]) AS Agricultural_Water_Use,
       SUM([Industrial_Water_Use]) AS Industrial_Water_Use,
       SUM([Household_Water_Use]) AS Household_Water_Use
       FROM [Project].[dbo].[global_water_consumption]
       GROUP BY Year
       ORDER BY Year;

       -- 4. Section wise consumption by Country
       SELECT Country,
       SUM([Agricultural_Water_Use]) AS Agricultural_Water_Use,
       SUM([Industrial_Water_Use]) AS Industrial_Water_Use,
       SUM([Household_Water_Use]) AS Household_Water_Use
       FROM [Project].[dbo].[global_water_consumption]
       GROUP BY Country
       ORDER BY Country;

       -- 5. Which Sector Consumes the most
       SELECT Sector, Total_Water_Use
       FROM (
       SELECT 'Agriculture' AS Sector,
       SUM([Agricultural_Water_Use]) AS Total_Water_Use
       FROM [Project].[dbo].[global_water_consumption]

       UNION ALL

       SELECT 'Industry',
       SUM([Industrial_Water_Use])
       FROM [Project].[dbo].[global_water_consumption]

       UNION ALL
       SELECT 'HouseHold',
       SUM([Household_Water_Use])
       FROM [Project].[dbo].[global_water_consumption]
       ) AS Sector_Data
       ORDER BY Total_Water_Use; 

       /* ===================================================================
                           6. WATER SCARCITY ANALYSIS
          ===================================================================  */
          -- 1. Number of records by water scarcity level
          SELECT Water_Scarcity_Level,
          COUNT(*) AS Number_of_Records
          FROM [Project].[dbo].[global_water_consumption]
          GROUP BY Water_Scarcity_Level
          ORDER BY Number_of_Records DESC;
          
          -- 2. Average water consumption by water scarcity level
          SELECT Water_Scarcity_Level,
          AVG([Total_Water_Consumption_Billion_Cubic_Meters]) AS Average_Water_Consumption
          FROM [Project].[dbo].[global_water_consumption]
          GROUP BY Water_Scarcity_Level
          ORDER BY Average_Water_Consumption DESC;

          -- 3. Average per capita by water scarcity level
           SELECT Water_Scarcity_Level,
          AVG([Per_Capita_Water_Use_Liters_per_Day]) AS Average_Per_Capita
          FROM [Project].[dbo].[global_water_consumption]
          GROUP BY Water_Scarcity_Level
          ORDER BY Average_Per_Capita DESC;

          -- 4.Groundwater depletion by scarcity level
          SELECT Water_Scarcity_Level,
          AVG(Groundwater_Depletion_Rate) AS Avg_Groundwater_Depletion
          FROM [Project].[dbo].[global_water_consumption]
          GROUP BY Water_Scarcity_Level
          ORDER BY Avg_Groundwater_Depletion DESC;

          -- 5. Countries with high water consumption and high scarcity
          SELECT Country,
          AVG([Total_Water_Consumption_Billion_Cubic_Meters]) AS Average_Water_Consumption,
          AVG(Groundwater_Depletion_Rate) AS Avg_Groundwater_Depletion
          FROM [Project].[dbo].[global_water_consumption]
          WHERE Water_Scarcity_Level = 'High'
          GROUP BY Country
          ORDER BY Average_Water_Consumption;  

          /* =========================================================================
                             7. GROUNDWATER DEPLETION ANALYSIS
             ========================================================================== */
             -- 1. Overall Average and Highest Groundwater Depletion
            SELECT AVG([Groundwater_Depletion_Rate]) as Average_ground_water_depletion_rate,
             MAX([Groundwater_Depletion_Rate]) AS Highest_ground_water_depletion_rate
             FROM [Project].[dbo].[global_water_consumption]

             -- 2. Top 5 Countries by Ground Water Depletion
             SELECT TOP (5) Country,
             AVG([Groundwater_Depletion_Rate]) AS Average_groundwater_depletion_rate
             FROM [Project].[dbo].[global_water_consumption]
             GROUP BY Country
             ORDER BY Average_groundwater_depletion_rate DESC;

             -- 3. Bottom 5 Countries by Groundwater Depletion

              SELECT TOP (5) Country,
             AVG([Groundwater_Depletion_Rate]) AS Average_groundwater_depletion_rate
             FROM [Project].[dbo].[global_water_consumption]
             GROUP BY Country
             ORDER BY Average_groundwater_depletion_rate ASC;

             -- 4. Groundwater Depletion by Year
              SELECT Year,
             AVG([Groundwater_Depletion_Rate]) AS Average_groundwater_depletion_rate
             FROM [Project].[dbo].[global_water_consumption]
             GROUP BY Year
             ORDER BY Year;

             -- 5. High water Scarcity + High groundwater depletion
             SELECT Country,
             AVG([Groundwater_Depletion_Rate]) AS Average_groundwater_depletion_rate,
             AVG([Total_Water_Consumption_Billion_Cubic_Meters]) AS Average_Water_Consumption
             FROM [Project].[dbo].[global_water_consumption]
             WHERE [Water_Scarcity_Level] = 'High'
             GROUP BY Country
             ORDER BY Average_groundwater_depletion_rate DESC; 

             /* ================================================================================
                                              8. RAINFALL ANALYSIS
                ================================================================================  */
                -- 1. Average and highest annual rainfall
                SELECT AVG([Rainfall_Impact_Annual_Precipitation_in_mm]) AS Average_Annual_Rainfall,
                MAX([Rainfall_Impact_Annual_Precipitation_in_mm]) AS Highest_Annual_Rainfall
                FROM [Project].[dbo].[global_water_consumption];

                -- 2.Top 5 countries with Average rainfall
                SELECT TOP (5) Country,
                AVG([Rainfall_Impact_Annual_Precipitation_in_mm]) AS Average_Annual_Rainfall
                FROM [Project].[dbo].[global_water_consumption]
                GROUP BY Country
                ORDER BY Average_Annual_Rainfall DESC;
                
                -- 3.Bottom 5 countries with Average rainfall
                SELECT TOP (5) Country,
                AVG([Rainfall_Impact_Annual_Precipitation_in_mm]) AS Average_Annual_Rainfall
                FROM [Project].[dbo].[global_water_consumption]
                GROUP BY Country
                ORDER BY Average_Annual_Rainfall ASC;

                -- 4. Yearwise Rainfall Trend
                SELECT Year,
                AVG([Rainfall_Impact_Annual_Precipitation_in_mm]) AS Average_Annual_Rainfall
                FROM [Project].[dbo].[global_water_consumption]
                GROUP BY Year
                ORDER BY Year;

                -- 5. Rainfall vs water consumption

                SELECT Country,
                 AVG([Rainfall_Impact_Annual_Precipitation_in_mm]) AS Average_Annual_Rainfall,
                 AVG([Total_Water_Consumption_Billion_Cubic_Meters]) AS Average_Water_Consumption
                FROM [Project].[dbo].[global_water_consumption]
                GROUP BY Country
                ORDER BY Average_Annual_Rainfall DESC;
                
         /* ======================================================================================
                                      9. YEAR OVER YEAR TREND ANALYSIS               
            ====================================================================================== */

            -- 1. Year-wise total water consumption
            SELECT Year,
              SUM(Total_Water_Consumption_Billion_Cubic_Meters) AS Total_Water_Consumption
            FROM [Project].[dbo].[Global_Water_Consumption]
            GROUP BY Year
            ORDER BY Year;

            --2.Year over year water consumption change

            WITH YearlyConsumption AS
          (
              SELECT Year,
              SUM(Total_Water_Consumption_Billion_Cubic_Meters) AS Total_Water_Consumption
              FROM [Project].[dbo].[Global_Water_Consumption]
              GROUP BY Year
          )

           SELECT Year, Total_Water_Consumption,
           LAG(Total_Water_Consumption) OVER (ORDER BY Year) AS Previous_Year_Consumption,
           Total_Water_Consumption - LAG(Total_Water_Consumption) OVER (ORDER BY Year) 
           AS Change_From_Previous_Year
           FROM YearlyConsumption
           ORDER BY Year;

           -- 3. Year over year percentage change
           WITH YearlyConsumption AS
          (
             SELECT Year,
             SUM(Total_Water_Consumption_Billion_Cubic_Meters) AS Total_Water_Consumption
             FROM [Project].[dbo].[Global_Water_Consumption]
             GROUP BY Year
          )

          SELECT Year, Total_Water_Consumption,
          LAG(Total_Water_Consumption) OVER (ORDER BY Year) AS Previous_Year_Consumption,
          Total_Water_Consumption - LAG(Total_Water_Consumption) OVER (ORDER BY Year)
          AS Change_From_Previous_Year,

        (
               (Total_Water_Consumption - LAG(Total_Water_Consumption) OVER (ORDER BY Year))
               / NULLIF(LAG(Total_Water_Consumption) OVER (ORDER BY Year), 0)
        ) * 100 AS YoY_Percentage_Change

       FROM YearlyConsumption
       ORDER BY Year;

       -- 4. Country-wise year over year change
       WITH CountryConsumption AS(
             SELECT Country, Year,
             SUM(Total_Water_Consumption_Billion_Cubic_Meters) AS Total_Water_Consumption
             FROM [Project].[dbo].[Global_Water_Consumption]
             GROUP BY Country, Year
       )

          SELECT Country, Year, Total_Water_Consumption,
          LAG(Total_Water_Consumption) OVER
          (PARTITION BY Country ORDER BY Year) AS Previous_Year_Consumption,
          Total_Water_Consumption - LAG(Total_Water_Consumption) OVER
        ( PARTITION BY Country ORDER BY Year) AS Change_From_Previous_Year
        FROM CountryConsumption
        ORDER BY Country, Year;