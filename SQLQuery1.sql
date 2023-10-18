Select * from PortfolioProject.dbo.CovidDeaths where continent is not null order by 3,4

--Select * from PortfolioProject.dbo.CovidVaccinations order by 3,4


Select Location, date, total_cases, new_cases, total_deaths, population from PortfolioProject..CovidDeaths order by 1,2


-- Total death and total cases, to see liklihood of dying if you get covid 
Select Location, date, total_cases, total_deaths , (total_deaths/total_cases)*100 as 'deaths per cases'  
from PortfolioProject..CovidDeaths 
where Location like '%states%'
order by 1,2


-- Total cases vs Population, what percentage of people have covid in USA 
Select Location, date, total_cases, population , (total_cases/population)*100 as 'Infection percentage'  
from PortfolioProject..CovidDeaths 
where Location like '%states%'
order by 1,2


-- Countries with highest infection rate
Select Location,  Max(total_cases) as 'Highest infection', population , Max((total_cases/population))*100 as MaxPercentageInfested  
from PortfolioProject..CovidDeaths 
group by Location,Population 
order by MaxPercentageInfested desc


-- Countries with highest death counts
Select Location,  Max(cast(total_deaths as int)) as MaxDeathCount 
from PortfolioProject..CovidDeaths  where continent is not null
group by Location
order by MaxDeathCount desc

-- Conitnents with highest death counts
Select  continent,  Max(cast(total_deaths as int)) as MaxDeathCountContinent 
from PortfolioProject..CovidDeaths  where continent is not  null
group by continent
order by MaxDeathCountContinent desc

Select  location,  Max(cast(total_deaths as int)) as MaxDeathCountlocation
from PortfolioProject..CovidDeaths  where continent is  null
group by location
order by MaxDeathCountContinent desc


---Global Numbers


--per day
Select date, sum(new_cases) as 'total_cases', sum(cast(new_deaths as int)) as 'total_Deaths', (sum(cast(new_deaths as int))/sum(new_cases))*100 as 'death_percentage'--total_deaths, population , (total_deaths/population)*100 as 'Infection percentage'  
from PortfolioProject..CovidDeaths 
where continent is not null
group by date
order by 1,2

--acroos the world
Select sum(new_cases) as 'total_cases', sum(cast(new_deaths as int)) as 'total_Deaths', (sum(cast(new_deaths as int))/sum(new_cases))*100 as 'death_percentage'--total_deaths, population , (total_deaths/population)*100 as 'Infection percentage'  
from PortfolioProject..CovidDeaths 
where continent is not null
order by 1,2



---Join
Select * from PortfolioProject..CovidDeaths as dea join PortfolioProject..CovidVaccinations as vac 
on dea.location = vac.location and dea.date = vac.date

--looking at total population vs vaccination

Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations, 
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from PortfolioProject..CovidDeaths dea 
join PortfolioProject..CovidVaccinations vac 
on dea.location = vac.location 
and dea.date = vac.date
where dea.continent is not null
order by 2,3


--CTE
with PopvsVac  (Continent, location,date,population,new_vaccinations,rollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations, 
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from PortfolioProject..CovidDeaths dea 
join PortfolioProject..CovidVaccinations vac 
on dea.location = vac.location 
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)

Select *, (rollingpeoplevaccinated/population)*100 as rollingpercentage from PopvsVac


--Temp Table
Drop Table if exists #PerPopulationVaccinated
create table #PerPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric)

Insert into #PerPopulationVaccinated
Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations, 
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from PortfolioProject..CovidDeaths dea 
join PortfolioProject..CovidVaccinations vac 
on dea.location = vac.location 
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *, (rollingpeoplevaccinated/population)*100 as rollingpercentage from #PerPopulationVaccinated



--create view to store data for later visualitsation
create view cases_per_day as 
Select date, sum(new_cases) as 'total_cases', sum(cast(new_deaths as int)) as 'total_Deaths', (sum(cast(new_deaths as int))/sum(new_cases))*100 as 'death_percentage'--total_deaths, population , (total_deaths/population)*100 as 'Infection percentage'  
from PortfolioProject..CovidDeaths 
where continent is not null
group by date
--order by 1,2


create view perPopVacc as 
Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations, 
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from PortfolioProject..CovidDeaths dea 
join PortfolioProject..CovidVaccinations vac 
on dea.location = vac.location 
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select * from perPopVacc