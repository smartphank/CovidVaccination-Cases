Select *
From PortfolioProject..CovidDeaths$
Where continent is not Null
Order by 3,4

--Select *
--From PortfolioProject..CovidVaccination$
--Order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths$
Where continent is not Null
Order by 1,2

-- Looking at Tocal Cases vs Total Deaths in Vietnam
-- Shows likelihook of dying if you contract covid in Vietnam
Select Location, date, total_cases, total_deaths, round((total_deaths/total_cases)*100,2) as DeathPercentage
from PortfolioProject..CovidDeaths$
where location like 'Vietnam'
Order by 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid

Select Location, date, total_cases, population, round((total_cases/population)*100,2) as CasePercentage
from PortfolioProject..CovidDeaths$
where location = 'Vietnam'
Order by 1,2

-- Looking at Countries with Highest Infection Rate compared to Population

Select Location, Population, Max(total_cases) as HighestInfectionCount, max((total_cases/population)*100) as CasePercentage
from PortfolioProject..CovidDeaths$
Where continent is not Null
Group by Location, population
Order by CasePercentage desc

-- Looking at Countries with Highest Death Count compared to Population

Select Location, Population, MAX((total_deaths/population)*100) as DeathPercentage, max(total_deaths) as HighestDeathCount
from PortfolioProject..CovidDeaths$
Where continent is not Null
Group by Location, population
Order by DeathPercentage desc

-- Showing countries with Highest Death Count per Population

Select Location, Max(cast(total_deaths as Int)) as TotalDeathCount
from PortfolioProject..CovidDeaths$
Where continent is not Null
Group by Location
Order by TotalDeathCount desc

-- Break things down by Continent and Income level

Select location, Max(cast(total_deaths as Int)) as TotalDeathCount
from PortfolioProject..CovidDeaths$
Where continent is Null
Group by location
Order by TotalDeathCount desc

-- Global numbers by date

Select date, SUM(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage	
from PortfolioProject..CovidDeaths$
Where continent is not Null
Group by date
Order by 1,2 desc

-- Total Global numbers

Select SUM(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage	
from PortfolioProject..CovidDeaths$
Where continent is not Null
Order by 1,2 desc

-- Looking at Total Population vs Vaccinations

Select d.continent, d.location, d.date, d.population, v.new_vaccinations, sum(convert(bigint,v.new_vaccinations)) over (Partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
-- Subqueries
From
(Select distinct date, continent, location, population
from PortfolioProject..CovidDeaths$) as D
Join PortfolioProject..CovidVaccination$ V
On D.location = V.location
And D.date = V.date
Where d.continent is not null
Order by 2,3