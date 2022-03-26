# Introduction

This analysis concerns the Coronavirus pandemic and is conducted in SQL as part of my portfolio. It is aimed at extracting and visualising data related to
Covid-related deaths, vaccination rates, mortality rates and more, broken down by country, continent and time.

In this way it aims to provide important information about the success (or lack of) of different countries in combatting the pandemic. It also aims to 
provide a picture of how the pandemic evolved over time.

# Data

**Data Source**: The data is obtained from [Our World in Data](https://ourworldindata.org/covid-deaths). The first date available in the dataset
is 24/02/2020. The last date available is 18/03/2022, as the dataset was downloaded on that date.

There are two tables: 'deaths' and 'vaccinations'. 

**Observations**: There are 169483 observations for the 'vaccinations' table and 162186 observations for the deaths table. The reason for this discrepancy
is explained in the *Limitations* section of this file. In summary, MySQLWorkbench was used to import the data from CSV files and it was not able to import
the entire dataset due to formatting issues.

**Columns/Features**:

There are 27 columns each in the 'deaths' and 'vaccinations' tables. Both tables share the columns 'continent', 'location' and 'date'.
A few of the exclusive columns in the former are:

- population
- new_cases
- total_deaths
- reproduction_rate
- icu_patients

Similarly, the following are among the exclusive columns in the 'vaccinations' table:

- total_tests
- positive_rate
- total_vaccinations
- total_boosters
- people_vaccinated


# Approach

My approach was to start with simple queries and work up to more complex ones. Many of the queries are aimed at extracting data to be visualised
using Tableau. The brief, initial focus is on a single country (Germany) before expanding out to continent and world-level data.

# Limitations

There are a few limitations and I believe these are the result of formatting mismatches between CSV files and MySQLWorkbench, which was used to conduct
this analysis.

1. MySQLWorkbench was not able to import the full dataset available. As a result, data for countries from Uruguay (inclusive) to Zimbabwe (inclusive)
was not imported.
2. The 'continent' column includes the values 'European Union', 'High income' and 'Low income'. These had to be filtered out.
3. The 'continent' column does not include values for 'Asia'. Therefore, continent-level analysis includes Asian countries.
4. In the exploration of how much of a country's population is vaccinated, there are multiple countries with total vaccination rates of > 100%. 

There could be a few reasons for this. The first is that the 'new_vaccinations' column (the sum of which is used to find the total vaccinations for a
country) counts each shot and each booster dose as a value. So if an individual gets two vaccines over a year, with each vaccine having 2 shots and 1 
booster dose, that will result in a value of (2 vaccines x 2 shots) + (1 booster dose + 1 booster dose) = 6 'new vaccinations' for one person.

The second reason could be that the data is erroneous. However, I conducted online research to see if data from 'new_vaccinations' column (among others)
corroborated with data from other sources. It seems to be the case that the 'new_vaccinations' data is accurate as other sources agree with it.

