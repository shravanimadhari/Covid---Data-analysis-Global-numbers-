Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From Covid_deaths$
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

select distinct location from Covid_deaths$
order by 1
--checking for invalid location or country names 

-- query to exculde invalid location names such as high income, European union, international, low income, upper middle income, world

select location, sum(new_Cases) as total_cases, sum(cast(new_deaths as int)) as total_Deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentage
from Covid_deaths$
where continent is null and location not in ('World', 'European union', 'Upper middle income', 'High income', 'low income', 'international', 'lower middle income')
group by location
order by death_percentage desc


Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From Covid_deaths$
Group by Location, Population
order by PercentPopulationInfected desc


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From Covid_deaths$
Group by Location, Population, date
order by PercentPopulationInfected desc