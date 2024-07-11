# 01_CLEAN_DATA.R

# 0. SETUP ----

## Install EpiSewer & CmdStan
## I'm not yet sure why you need this, so I commented it out
# remotes::install_github("adrian-lison/EpiSewer", dependencies = TRUE)
# cmdstanr::check_cmdstan_toolchain()
# cmdstanr::install_cmdstan(cores = 2) # Use more cores to speed up

## Load Packages
pacman::p_load(rio,tidyverse, janitor, psych, gtsummary, here, readxl, pacman, EpiSewer, ggplot2, data.table, here)

## Use here() to set working directory by specifying i_am()
here::i_am("Code/01_clean_data.r")

# 1. LOAD AND PROCESS DATA ----

## 1.1 NYTimes Data - Mask Use by County ----

### 1.1.1 Import Data
nyt_mask_use_by_county <- import(here("Data/raw_data/mask-use-by-county.csv")) %>%
  janitor::clean_names()

### 1.1.2 Rename Column
nyt_mask_use_by_county <- nyt_mask_use_by_county %>%
  rename(fips = countyfp)

## 1.2 NYTimes Data - County Info ----
## You don't actually need this since you're getting so much from the 2020 rates dataset, it is exactly the same.
# ### 1.2.1 Import Data
# nyt_county_info <- import(here("Data/raw_data/us-counties.csv")) %>%
#   janitor::clean_names()
# 
# ### 1.2.2 Filter to only keep NC Data
# nyt_county_info <- nyt_county_info %>%
#   filter(state == "North Carolina")
# 
# ### 1.2.3 Filter to date ranges
# nyt_county_info <- nyt_county_info %>%
#   filter(date >= as.Date("2020-07-02") & date <= as.Date("2020-07-14"))

### 1.2.4 Delete unnecessary columns
# ### Since you have county rates from another dataset, deleting the ones here
# nyt_county_info <- nyt_county_info %>%
#   select(-cases, -deaths, -state)

## 1.3 COVID RATES BY COUNTY ----

### 1.3.1 Import Data
nyt_covid_rates_by_county <- import(here("Data/raw_data/us-counties-2020.csv")) %>%
  janitor::clean_names()

### 1.3.2 Filter to only keep NC Data
nyt_covid_rates_by_county <- nyt_covid_rates_by_county %>%
  filter(state == "North Carolina")

### 1.3.3 Filter to date ranges
nyt_covid_rates_by_county <- nyt_covid_rates_by_county %>%
  filter(date >= as.Date("2020-07-02") & date <= as.Date("2020-07-14"))

### 1.3.4 Delete unnecessary columns
nyt_covid_rates_by_county <- nyt_covid_rates_by_county %>%
  select(-state)

## 1.4 CDC Data - National Immunization Data 2024 ----

### 1.4.1 Import Data
# cdc_immunization_data <- import(here("Data/raw_data/National_Immunization_Survey_Adult_COVID_Module__NIS-ACM___COVIDVaxViews__Data___Centers_for_Disease_Control_and_Prevention__cdc.gov__20240627.csv")) %>%
#   janitor::clean_names()
# 
# ### 1.4.2 Filter to only keep NC Data
# cdc_immunization_data <- cdc_immunization_data %>%
#   filter(geography == "North Carolina")

## 1.5 NC Population Data ----

### 1.5.1 Import Data
nc_population_data_by_county <- import(here("Data/raw_data/county-population-totals-2.csv")) %>%
  janitor::clean_names()

### 1.5.2 Rename value to population
nc_population_data_by_county <- nc_population_data_by_county %>%
  rename(population = value)

### 1.5.2 Delete unnecessary columns
nc_population_data_by_county <- nc_population_data_by_county %>%
  select(-variable, -council_of_government_region, -metropolitan_statistical_area_2013, -vintage, -estimate_projection, -county)

## 1.6 Recent Wastewater Data ----

### 1.6.1 Import Data
wastewater_data_by_county <- import(here("Data/raw_data/wastewater_latest.csv")) %>%
  janitor::clean_names() 

### 1.6.2 Rename county_names to county
wastewater_data_by_county <- wastewater_data_by_county %>%
  rename(county = county_names, date = date_new)

### 1.6.3 Filter to only keep dates
wastewater_data_by_county <- wastewater_data_by_county %>%
  filter(date >= as.Date("2021-07-02") & date <= as.Date("2021-07-14"))



# 2. MERGING DATA ----

## 2.1 Left join all datasets by fips, in order that it was imported

merged_data <- nyt_covid_rates_by_county %>%
  left_join(nyt_mask_use_by_county, by = "fips") %>%
  # left_join(cdc_immunization_data, by = "fips") %>%
  left_join(nc_population_data_by_county, by = "fips") 
# %>% left_join(wastewater_data_by_county, by = "county", "date") 
## Wastewater has a lot of missing data for now, so it is causing issues. I will return to this later



# 3. SAVE CLEANED DATA ----

## Save cleaned data to cleaned_data folder
write_csv(merged_data, here("Data/cleaned_data/merged_data.csv"))

## Remove all other datasets
# rm(list = ls()[!ls() %in% c("merged_data")])
