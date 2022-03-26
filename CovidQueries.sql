## Cleaning data

alter table deaths
add id int not null auto_increment primary key first

alter table vaccinations
add id int not null auto_increment primary key first

# format 'date' column to correct format (yyyy-mm-dd) for both tables

update deaths
set date = date_format(str_to_date(date,'%d/%m/%Y'),'%Y-%m-%d')
update vaccinations
set date = date_format(str_to_date(date,'%d/%m/%Y'),'%Y-%m-%d')

# replace empty values in column 'total_deaths' in 'death' table with 0, then change data type to int

update deaths
set total_deaths = 0
where total_deaths = ''  

alter table deaths
modify total_deaths int

# do the same as above for column 'new_deaths' in 'death' table

update deaths set new_deaths = 0
where new_deaths = ''

alter table deaths
modify new_deaths int

# replace empty values for column 'continent' in 'death' table with NULL

update deaths
set continent = null
where continent = ''

# replace empty values in continent in 'new_vaccinations' table with 0
# then change its data type to 'bigint'

update vaccinations
set new_vaccinations = 0
where new_vaccinations = ''

alter table vaccinations
modify new_vaccinations bigint

# find the data which was not uploaded in 'deaths' table. This must be done because MySQL Workbench is not fully import

select a.location
from vaccinations a
left join deaths b on a.id = b.id
where b.id is null
group by a.location

# Data was not uploaded for every country from Urguguay (inclusive) onwards ordered
# alphabetically, until Zimbabwe (inclusive)

# --------------------------------------------------------------------------------

# Q1) Infected as % of Population over time: Germany

select location, date, total_cases, (total_cases/population)*100 as '% of Cases'
from deaths
where location = 'Germany'

# --------------------------------------------------------------------------------

# Q2) Mortality Rate over time: Germany

select location, date, total_cases, total_deaths, round(((total_deaths/total_cases)*100), 2) as 'Mortality Rate'
from deaths
where location = 'Germany'
order by 1, 2

# --------------------------------------------------------------------------------

# Q3) What is the deadliest month on average: Germany

Select location, month(date), round(avg((total_deaths/total_cases)*100), 2) as morality_percentage
from deaths
where location = 'Germany'
group by location, month(date)
order by morality_percentage DESC

# insight: all the summer months. This is predictable; people tend to be most social and outgoing in the summer to enjoy the weather
# as more people visit public places, the likelihood of the virus transmitting is greater. But that doesn't explain why mortality is higher.
# perhaps older segments of population visit public places more and get infected, and older people are more likely to die from Covid

# --------------------------------------------------------------------------------

# Q4) In which countries are you most likely to die from Covid today?

select location, date, (total_deaths/total_cases)*100 as Mortality_Rate
from deaths
where date = '2022-03-18'
order by Mortality_Rate DESC
limit 5

# --------------------------------------------------------------------------------

select location, max((total_deaths/population*100)) as death_rate
from deaths
group by location
order by death_rate desc
limit 10

# Q5) What are the total deaths figures by continent?

select location, max(total_deaths) as total_continent_deaths
from deaths
where continent is null and location not in('High income', 'European Union', 'Low income')
group by location
order by total_continent_deaths desc

# --------------------------------------------------------------------------------

## GLOBAL FIGURES - excluding ASIA

# Q6) Total global cases and deaths

select sum(new_cases) as total_cases_global, sum(new_deaths) as total_deaths_global,
	   (sum(new_deaths)/sum(new_cases))*100 as death_percentage
from deaths
where continent is null and location not in('European Union', 'High income', 'Low income')

# according to wikipedia, Asia had 150,490,302 total cases. When we add this to the figure of
# 336,193,901, we get 486,684,203, which is very close to the total number of cases obtained from Google at 471 million

# --------------------------------------------------------------------------------

# Q7) Total Global Vaccination Rate by date

with cte1 as(
select a.continent, a.location, a.date, a.population,
	   b.new_vaccinations,
       sum(b.new_vaccinations) OVER (Partition by a.location order by a.location, a.date) as vacc_so_far
from deaths a inner join vaccinations b using(location, date)
where a.continent is not null)
select location, date, population, new_vaccinations, vacc_so_far, (vacc_so_far/population)*100 as percent_pop_vaccinated
from cte1

# ---------------------------------------------------------------------------------------------

## CREATE VIEW

create view global_vaccination_rate as

with cte1 as(
select a.continent, a.location, a.date, a.population,
	   b.new_vaccinations,
       sum(b.new_vaccinations) OVER (Partition by a.location order by a.location, a.date) as vacc_so_far
from deaths a inner join vaccinations b using(location, date)
where a.continent is not null)
select location, date, population, new_vaccinations, vacc_so_far, (vacc_so_far/population)*100 as percent_pop_vaccinated
from cte1

