-- total cases vs total death percentage 

select * from Covid_deaths$

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
from Covid_deaths$
where location like '%ndia'
order by 1,2

-- o/p - 1.2 percent chance of dying if infected as of 26th June 2022 in India with a total of 43M cases

select location, date, population, total_cases, (total_cases/population)*100 as infected_ppl_percentage
from Covid_deaths$
where location like '%ndia'
order by 1,2

select location, date, population, total_cases, (total_cases/population)*100 as infected_ppl_percentage
from Covid_deaths$
where location like '%states%'
order by 1,2


-- countries with highest infection rate

select location, population, max(total_cases) as highest_per_location, max((total_cases/population))*100 as percent_population_infected
from Covid_deaths$
group by location, population 
order by percent_population_infected desc;

--countries with Max deaths 
select location, Max(cast(total_deaths as int)) as Max_deaths
from Covid_deaths$
where continent is not null
--where location = 'Asia'
group by location 
order by max_deaths desc


-- max_death per continent
select continent, Max(cast(total_deaths as int)) as Max_deaths
from Covid_deaths$
where continent is not null
--where location = 'Asia'
group by continent
order by max_deaths desc


select location, Max(cast(total_deaths as int)) as Max_deaths
from Covid_deaths$
where continent is null
--where location = 'Asia'
group by location
order by max_deaths desc

-- across the world, the new cases per date wise and death percentage 

select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as bigint))/sum(new_Cases)*100 as death_percentage
from Covid_deaths$
where new_cases <> 0
group by date
order by 1, 2

--Total aggregate value 
select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as bigint))/sum(new_Cases)*100 as death_percentage
from Covid_deaths$
where new_cases <> 0



-- vaccination table 
select * from Covid_vaccination$

--total number of people in the world who got vaccinated 

select * from Covid_deaths$ dea
join Covid_vaccination$ vacc 
on dea.location = vacc.location and dea.date = vacc.date
order by 3,4



-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From Covid_deaths$ dea
Join Covid_vaccination$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From Covid_deaths$ dea
Join Covid_vaccination$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From  Covid_deaths$ dea
Join Covid_vaccination$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
