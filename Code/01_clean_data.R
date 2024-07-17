# 01_CLEAN_DATA.R

# 0. SETUP ----

## Install EpiSewer & CmdStan
## I'm not yet sure why you need this, so I commented it out
# remotes::install_github("adrian-lison/EpiSewer", dependencies = TRUE)
# cmdstanr::check_cmdstan_toolchain()
# cmdstanr::install_cmdstan(cores = 2) # Use more cores to speed up

## Load Packages
#install.packages("pacman")
#pacman::p_load(rio,tidyverse, janitor, psych, gtsummary, here, readxl, pacman, EpiSewer, ggplot2, data.table, here)

## Use here() to set working directory by specifying i_am()
setwd("~/Documents/GitHub/mask-ban-analysis/Code")
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
#nyt_covid_rates_by_county <- nyt_covid_rates_by_county %>%
 # filter(date >= as.Date("2020-07-02") & date <= as.Date("2020-07-14"))

### 1.3.4 Delete unnecessary columns
nyt_covid_rates_by_county <- nyt_covid_rates_by_county %>%
  select(-state)

## 1.4 CDC Data - National Immunization Data 2024 ----

### 1.4.1 Import Data
 cdc_immunization_data <- import(here("National_Immunization_Survey_Adult_COVID_Module__NIS-ACM___COVIDVaxViews__Data___Centers_for_Disease_Control_and_Prevention__cdc.gov__20240627.csv")) %>%
janitor::clean_names()

### 1.4.2 Filter to only keep NC Data
cdc_immunization_data <- cdc_immunization_data %>%
  filter(geography == "North Carolina")

### 1.4.3 Filter most current data
cdc_immunization_current <- cdc_immunization_data %>%
  filter(time_period == "April 1 - April 27")

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

## 1.7 CDC atlas risk factors Data ----

### 1.7.1 Import Data
cdc_risk_factors<- import(here("Data/raw_data/CDC_atlas_risk_factors.csv")) %>% 
  janitor::clean_names()

### 1.7.2 Filter to only keep NC Data
cdc_risk_factors_nc <- cdc_risk_factors %>% 
  filter(cnty_fips>= "37000"& cnty_fips <= "38000")

### 1.7.3 Rename column cnty_fips to fips
cdc_risks_nc <- cdc_risk_factors_nc %>% 
  rename(fips = cnty_fips)

### 1.7.4 Remove county name column 
cdc_risks_nc <- cdc_risks_nc %>% 
  select(-"display_name")

## 1.8 Percent nonwhite population Data ----

###1.8.1 Import Data
percent_nonwhite_pop <- import(here("Data/raw_data/percent_nonwhite_pop.csv")) %>% 
  janitor::clean_names()

### 1.8.2 Filter to only keep NC Data
nc_percent_nonwhite_pop <-percent_nonwhite_pop %>% 
  filter(fips>= "37000" & fips<= "38000")

## 1.9 Population density Data ----

### 1.9.1 Import Data
population_density <- import(here("Data/raw_data/population_density.csv")) %>% 
  janitor::clean_names()

### 1.9.2 Filter to only keep NC Data
nc_population_density <-population_density %>% 
  filter(fips>= "37000" & fips<= "38000")

### 1.9.3 Remove county name column
nc_population_density <- nc_population_density %>% 
  select(-"name")

## 1.10. Mask adherence data by state ----

### 1.10.1 Import Data
mask_adherence_by_state <- import(here("Data/raw_data/mask_adherence_by_state.csv")) %>% 
  janitor::clean_names()


# 2. MERGING DATA ----

## 2.1 Left join all datasets by fips, in order that it was imported ----

merged_data <- nyt_covid_rates_by_county %>%
  left_join(nyt_mask_use_by_county, by = "fips") %>%
  # left_join(cdc_immunization_data, by = "fips") %>%
  left_join(nc_population_data_by_county, by = "fips") %>% 
# %>% left_join(wastewater_data_by_county, by = "county", "date") 
## Wastewater has a lot of missing data for now, so it is causing issues. I will return to this later 
## NOT USING WASTEWATER ANYMORE
  left_join(cdc_risks_nc, by = "fips") %>% 
  left_join(nc_percent_nonwhite_pop, by = "fips") %>% 
  left_join(nc_population_density, by = "fips")

## 2.2 Add column for covid prevalence ----
merged_data <- merged_data %>%  
  mutate(prevalence = cases / population)

## 2.3 Add column for avg prevalence by fips ----
merged_data <- merged_data %>% 
  group_by(fips) %>% 
  mutate(summarize(avg_prevalence = mean(prevalence, na.rm = TRUE)))

## 2.4 Add column for change in covid prevalence ----
covid_prevalence_data <- merged_data %>% 
  select(fips, date, prevalence) %>%
  spread(date, prevalence) %>%
  rename(prevalence_2020_07_02 = `2020-07-02`, prevalence_2020_07_14 = `2020-07-14`) %>%
  mutate(change_in_prevalence = prevalence_2020_07_14 - prevalence_2020_07_02)

#left join new column to merged data
merged_data <- merged_data %>%
  left_join(covid_prevalence_data %>% 
  select(fips, change_in_prevalence), by = "fips") 


  
# 3. SAVE CLEANED DATA ----

## Save cleaned data to cleaned_data folder
write_csv(merged_data, here("Data/cleaned_data/merged_data.csv"))

## Remove all other datasets
rm(list = ls()[!ls() %in% c("merged_data", "cdc_immunization_current")])


#merged_data_unique <- merged_data %>%
#  distinct(fips, .keep_all = TRUE)
