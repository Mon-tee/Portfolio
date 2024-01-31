-- Limit Code Execution to First Five Entries: Write code to restrict processing to 
-- the initial five records in a dataset, ensuring efficient and targeted data handling.

SELECT *
FROM `new_schema`.`owid-covid-data (1)`
LIMIT 5;

--  Analyze and Organize Data by Location and Date: Develop a method to examine data focusing on 
-- 'location', 'date', 'total_cases', 'new_cases', 'total_deaths', and 'population', 
-- and arrange this information in an orderly manner based on location and date

SELECT  location,
        date, 
        total_cases, 
        new_cases, 
        total_deaths, 
        population
FROM `new_schema`.`owid-covid-data (1)`
ORDER BY location, date;

-- Examine Total Cases Versus Total Deaths: Implement an approach to analyze and 
-- compare 'total_cases' and 'total_deaths' data

SELECT location, 
       date, 
       total_cases, 
       total_deaths, 
       (total_deaths / total_cases) * 100 as death_percentage
FROM `new_schema`.`owid-covid-data (1)`
WHERE location LIKE '%states%'
ORDER BY location, date;



-- Analyze Total Cases Relative to Population: Develop a method to study and compare 
-- 'total_cases' against 'population' data.

SELECT location, 
       date, 
       total_cases, 
       population, 
       (total_cases / population) * 100 AS case_percentage
FROM `new_schema`.`owid-covid-data (1)`
WHERE location LIKE '%states%'
ORDER BY location, date;


-- Analyze Countries with Highest Infection Rate Relative to Population: Implement a strategy to 
-- identify and compare countries based on their infection rates, taking into account the total 
-- number of cases in relation to their population sizes.

SELECT 
    location, 
    population, 
    MAX(total_cases) AS highest_infection_count,
    MAX((total_cases / population) * 100) AS percent_population_infected
FROM `new_schema`.`owid-covid-data (1)`
GROUP BY location, population
ORDER BY percent_population_infected DESC;

-- Display Countries with Highest Death Count Relative to Population: 
-- Develop a method to identify and showcase countries with the most significant number of deaths 
-- in proportion to their population sizes, highlighting regions with the gravest impact in terms 
-- of mortality rates.

SELECT location, MAX(CAST(total_deaths AS INT)) AS total_death_count
FROM `new_schema`.`owid-covid-data (1)`
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_death_count DESC;

--  Present Countries with Highest Death Count by Continent: Create an approach to identify 
-- and display the countries with the highest number of deaths due to a specific cause, 
-- categorized and compared within their respective continents

SELECT continent, MAX(CAST(total_deaths AS INT)) AS total_death_count
FROM `new_schema`.`owid-covid-data (1)`
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC;

-- Calculate Death Percentage per Continent: Establish a procedure to compute and 
-- analyze the death percentage for each continent, focusing on the proportion of deaths 
-- in relation to the total population of the continen

SELECT 
    date, 
    SUM(new_cases) AS total_cases, 
    SUM(CAST(new_deaths AS INT)) AS total_deaths, 
    (SUM(CAST(new_deaths AS INT)) / SUM(new_cases)) * 100 AS death_percentage
FROM `new_schema`.`owid-covid-data (1)`
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date, total_cases;


-- Analyze Total Population Versus Vaccinations by Merging Data: Implement a strategy to combine 
-- and examine data from CovidDeaths and CovidVaccination databases,
-- focusing on comparing the total population figures with vaccination numbers

SELECT 
    dhs.continent, 
    dhs.location, 
    dhs.date, 
    dhs.population, 
    vns.new_vaccinations, 
    SUM(CONVERT(BIGINT, vns.new_vaccinations)) OVER (
        PARTITION BY dhs.location 
        ORDER BY dhs.location, dhs.date
    ) AS rolling_people_vaccinated
FROM 
    `new_schema`.`CovidDeaths` dhs
JOIN 
    `new_schema`.`CovidVaccination` vns
ON 
    dhs.date = vns.date
    AND dhs.location = vns.location
WHERE 
    dhs.continent IS NOT NULL
ORDER BY 
    dhs.location, 
    dhs.date;

-- SQL Query Development with CTE: Design an SQL query incorporating a Common Table 
-- Expression (CTE) named 'Popvsvac' to efficiently merge data and compute the cumulative total 
-- of new vaccinations by location and date.

WITH Popvsvac (continent, location, date, population, New_Vaccinations, rolling_people_vaccinated) AS (
    SELECT 
        dhs.continent, 
        dhs.location, 
        dhs.date, 
        dhs.population, 
        vns.new_vaccinations, 
        SUM(CONVERT(BIGINT, vns.new_vaccinations)) OVER (
            PARTITION BY dhs.location 
            ORDER BY dhs.location, dhs.date
        ) AS RollingPeopleVaccinated
    FROM 
        `new_schema`.`CovidDeaths` dhs
    JOIN 
        `new_schema`.`CovidVaccination` vns
    ON 
        dhs.date = vns.date
        AND dhs.location = vns.location
    WHERE 
        dhs.continent IS NOT NULL
)
SELECT * FROM Popvsvac
ORDER BY location, date;

-- Table Creation for Vaccination Data: Construct a table named 'PercentPopulationVaccinated' to 
-- systematically store and manage data regarding the percentage of the population vaccinated.

DROP TABLE IF EXISTS #PercentPopulationVaccinated;
CREATE TABLE #PercentPopulationVaccinated
(
    Continent NVARCHAR(255),
    Location NVARCHAR(255),
    Date DATETIME,
    Population NUMERIC,
    New_vaccination NUMERIC,
    RollingPeopleVaccinated NUMERIC
);

INSERT INTO #PercentPopulationVaccinated
SELECT 
    dhs.continent, 
    dhs.location, 
    dhs.date, 
    dhs.population, 
    vns.new_vaccinations, 
    SUM(CONVERT(BIGINT, vns.new_vaccinations)) OVER (
        PARTITION BY dhs.location 
        ORDER BY dhs.location, dhs.date
    ) AS RollingPeopleVaccinated
FROM 
    `new_schema`.`CovidDeaths` dhs
JOIN 
    `new_schema`.`CovidVaccination` vns
ON 
    dhs.date = vns.date
    AND dhs.location = vns.location
WHERE 
    dhs.continent IS NOT NULL;

SELECT 
    *, 
    (RollingPeopleVaccinated / Population) * 100 AS PercentPopulationVaccinated
FROM 
    #PercentPopulationVaccinated;

-- View Establishment for Vaccination Data: Implement the creation of a view named 
-- 'PercentPopulationVaccinated', designed to provide a dynamic and structured representation 
-- of vaccination data. 

CREATE VIEW PercentPopulationVaccinated AS
SELECT 
    dhs.continent, 
    dhs.location, 
    dhs.date, 
    dhs.population, 
    vns.new_vaccinations, 
    SUM(CONVERT(BIGINT, vns.new_vaccinations)) OVER (
        PARTITION BY dhs.location 
        ORDER BY dhs.location, dhs.date
    ) AS RollingPeopleVaccinated,
    (SUM(CONVERT(BIGINT, vns.new_vaccinations)) OVER (
        PARTITION BY dhs.location 
        ORDER BY dhs.location, dhs.date
     ) / dhs.population) * 100 AS PercentPopulationVaccinated
FROM 
    `new_schema`.`CovidDeaths` dhs
JOIN 
    `new_schema`.`CovidVaccination` vns
ON 
    dhs.date = vns.date
    AND dhs.location = vns.location
WHERE 
    dhs.continent IS NOT NULL;
