--creating view
create view overallview
as Select Top 300 * from coviddeaths


Select Top 100 * 
from coviddeaths

Select Top 100 * 
from covidvacc

Select Location, date, total_cases, new_cases, total_deaths,population
from Coviddeaths
Order By Location,date


--Changing data types of Columns
ALTER TABLE coviddeaths 
ALTER COLUMN total_cases float 

ALTER TABLE coviddeaths 
ALTER COLUMN total_deaths float 

ALTER TABLE coviddeaths 
ALTER COLUMN total_deaths_per_million float 

ALTER TABLE coviddeaths 
ALTER COLUMN total_cases_per_million float 


--Total Cases vs Total deaths
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 PercentageDeaths
from Coviddeaths
Where Location= 'India'
Order By Location,date


--Total Cases vs Population
Select Location, (total_cases), population, (total_cases/population)*100 PercentageInfected
from Coviddeaths
Group By Location
Order By PercentageInfected desc,date desc


--Max percentage of overall Population got Infected
Select Location, population, Max(total_cases) MaxInfected, Max((total_cases/Population)*100) MaxInfectedPercent
from coviddeaths
Group By Location, population 
Having Location='India'
Order By Max(total_cases/Population) desc


--Total Deaths % so far by country
Select Location, Max(total_deaths) TotalDeaths,(Max(total_deaths/population)*100) DeathPercentage
from coviddeaths
Group By Location
Order By DeathPercentage desc

--Total cases in the world yearwise
Select YEAR(date) Yr, sum(total_cases) TotalCases
from coviddeaths
Group By YEAR(date)
Order by YEAR(date)

--Looking at avg total deaths per milion by country

Select continent Continent, avg(total_cases_per_million) avgcasespermillion, avg(total_deaths_per_million) avgdeathspermillion
from coviddeaths
Where continent is not null
Group By continent 
Order By avgcasespermillion desc

--Looking at total deaths by continent

Select continent Continent, max(total_deaths) TotalDeaths
from coviddeaths
Where continent is not null
Group By continent
--Having Year(Date) = 2022
Order By TotalDeaths desc

--Global Numbers of cases day by day
Select top 100 * from coviddeaths

Select date, sum(total_cases)
from coviddeaths
Where continent is not null
Group By date
order by date

--cases in India day by day
Select date, sum(total_cases)
from coviddeaths
Where continent is not null
Group By date, location
having location ='India'
order by date



--population by continent
Select * from coviddeaths
select * from covidvacc
Select location, max(population)
from coviddeaths
where continent is null
Group By location


Select * from covidvacc
where continent is null

--Total vaccination by continent
Select coviddeaths.location , max(Convert(float,covidvacc.people_vaccinated)) TotalVaccination, max(coviddeaths.population)TotalPopulation, 
max(Convert(float,covidvacc.people_vaccinated)/coviddeaths.population) Percentvaccination
from coviddeaths
join covidvacc
     on coviddeaths.location = covidvacc.location
	 and coviddeaths.date = covidvacc.date
Where coviddeaths.continent is null
Group By coviddeaths.location
Order by TotalVaccination desc



--percentage of population of people vaccinated at least one by Country
Select coviddeaths.location Country, max(Convert(float,covidvacc.people_vaccinated)) TotalVaccination, max(coviddeaths.population) TotalPopulation, 
max(Convert(float,covidvacc.people_vaccinated)/coviddeaths.population) Percentvaccination
from coviddeaths
join covidvacc
     on coviddeaths.location = covidvacc.location
	 and coviddeaths.date = covidvacc.date
Where coviddeaths.location is not null
Group By coviddeaths.location
Order By Percentvaccination desc


--Looking at the total population vs vaccination
Select coviddeaths.continent, coviddeaths.location , coviddeaths.date, coviddeaths.population, covidvacc.new_vaccinations
, SUM(Convert(float,covidvacc.new_vaccinations)) 
OVER (Partition By coviddeaths.location Order By coviddeaths.location , coviddeaths.date) Cumulativevaccination
from coviddeaths
join covidvacc
     on coviddeaths.location = covidvacc.location
	 and coviddeaths.date = covidvacc.date
Where coviddeaths.continent is not null
Order By coviddeaths.location, coviddeaths.date



--for performing calculation further in output we will use CTE
--increasing in percentage of people vaccination in a country by date
with Rollingvacc (continent, location, date, population, new_vaccinations, Cumulativevaccination)
as
(
Select coviddeaths.continent, coviddeaths.location , coviddeaths.date, coviddeaths.population, covidvacc.new_vaccinations
, SUM(Convert(float,covidvacc.new_vaccinations)) 
OVER (Partition By coviddeaths.location Order By coviddeaths.location , coviddeaths.date) Cumulativevaccination
from coviddeaths
join covidvacc
     on coviddeaths.location = covidvacc.location
	 and coviddeaths.date = covidvacc.date
Where coviddeaths.continent is not null
--Order By coviddeaths.location, coviddeaths.date
)
Select *, (Cumulativevaccination/population)*100
from Rollingvacc


--Temp Table
Drop Table if exists #Rollingsumpeoplevaccination
Create Table #Rollingsumpeoplevaccination
(Continent varchar(200),
location varchar(150),
Date datetime,
Population numeric,
New_vaccinations numeric,
Cumulativevaccination numeric
)

Insert Into #Rollingsumpeoplevaccination
Select coviddeaths.continent, coviddeaths.location , coviddeaths.date, coviddeaths.population, covidvacc.new_vaccinations
, SUM(Convert(float,covidvacc.new_vaccinations)) 
OVER (Partition By coviddeaths.location Order By coviddeaths.location , coviddeaths.date) Cumulativevaccination
from coviddeaths
join covidvacc
     on coviddeaths.location = covidvacc.location
	 and coviddeaths.date = covidvacc.date
Where coviddeaths.continent is not null


--creating a view
Create view Continentvaccinationpercentage as 
Select coviddeaths.location , max(Convert(float,covidvacc.people_vaccinated)) TotalVaccination, max(coviddeaths.population)TotalPopulation, 
max(Convert(float,covidvacc.people_vaccinated)/coviddeaths.population) Percentvaccination
from coviddeaths
join covidvacc
     on coviddeaths.location = covidvacc.location
	 and coviddeaths.date = covidvacc.date
Where coviddeaths.continent is null
Group By coviddeaths.location
--Order by TotalVaccination desc











-------------------------------------------------------------------------------------------------------------------------------------







































