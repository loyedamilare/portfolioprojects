SELECT *
FROM
	portfolioproject..coviddeaths
WHERE 
	continent is not null
ORDER BY 
	1,2

SELECT
	Location, 
	date, 
	total_cases, 
	total_deaths, 
	population
FROM 
	portfolioproject..coviddeaths
ORDER BY 
	1,2

-- looking at total cases vs total deaths

SELECT 
	Location, 
	date, 
	total_cases, 
	total_deaths, 
	(total_deaths/total_cases)*100 as deathpercentage
FROM 
	portfolioproject..coviddeaths
WHERE 
	location = 'Nigeria'
and continent is not null
ORDER BY 
	1,2

-- looking at total cases vs the population


SELECT 
	Location, 
	population, 
	max(total_cases) as max_cases, 
	max(total_cases/population)*100 as infectionrate
FROM
	portfolioproject..coviddeaths
--WHERE location = 'Nigeria'
WHERE 
	continent is not null
GROUP BY 
	location, population
ORDER BY 4 DESC

--showing Countries with the Highest deathCount per population 

SELECT 
	Location, 
	MAX(cast (total_deaths as int)) as totaldeathcount
FROM 
	portfolioproject..coviddeaths
--WHERE location = 'Nigeria'
WHERE 
	continent is not null
GROUP BY 
	location, population
ORDER BY 
	totaldeathcount DESC

-- Breaking it down by Continent

SELECT 
	continent,
	MAX(cast (total_deaths as int)) as totaldeathcount
FROM 
	portfolioproject..coviddeaths
--WHERE location = 'Nigeria'
WHERE
	continent is not null
GROUP BY 
	continent
ORDER BY	
	totaldeathcount DESC


-- Global cases
SELECT 
	SUM(total_cases) as total_cases, 
	SUM(Cast(new_deaths as int)) as total_deaths, 
	SUM(cast(new_deaths as int))/SUM(total_cases)*100 as deathpercentage
FROM 
	portfolioproject..coviddeaths
--WHERE location = 'Nigeria'
WHERE 
	continent is not null
--GROUP BY date
ORDER BY 
	1,2 

SELECT
	date, 
	SUM(total_cases) as total_cases, 
	SUM(Cast(new_deaths as int)) as total_deaths, 
	SUM(cast(new_deaths as int))/SUM(total_cases)*100 as deathpercentage
FROM 
	portfolioproject..coviddeaths
--WHERE location = 'Nigeria'
WHERE 
	continent is not null
GROUP BY
	date
ORDER BY
	1,2

	select *
	from portfolioproject..CovidVaccination


SELECT 
	dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(convert (int, vac.new_vaccinations))
	Over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated

FROM 
	portfolioproject..coviddeaths dea
	join portfolioproject..[CovidVaccination] vac
	on dea.location = vac.location
	and dea.date = vac.date
Where 
	dea.continent is not null
order by 2,3

-- using CTE

with popvsvac ( continent, location, date, population, new_vaccinations, rollingpeoplevaccinated)
as 
(
SELECT 
	dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(convert (int, vac.new_vaccinations))
	Over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated

FROM 
	portfolioproject..coviddeaths dea
	join portfolioproject..CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)
select *, (rollingpeoplevaccinated/population)*100 as percentpopulationvaccinated 
from popvsvac





-- creating  view to store data for later vizualization
 
CREATE VIEW popvsvac as
SELECT 
	dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(convert (int, vac.new_vaccinations))
	Over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated

FROM 
	portfolioproject..coviddeaths dea
	join portfolioproject..CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
Where 
	dea.continent is not null
--order by 2,3


Create view  globaldeathpercent 
	as
SELECT
	date, 
	SUM(total_cases) as total_cases, 
	SUM(Cast(new_deaths as int)) as total_deaths, 
	SUM(cast(new_deaths as int))/SUM(total_cases)*100 as deathpercentage
FROM 
	portfolioproject..coviddeaths
--WHERE location = 'Nigeria'
WHERE 
	continent is not null
GROUP BY
	date
--ORDER BY
	
	select *
	from popvsvac