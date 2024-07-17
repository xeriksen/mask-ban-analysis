# 03_data_visualization.r 

## 0. SETUP ----

##Loadpackages 
#install.packages("sf")
#install.packages("usmap")
library(usmap)
library(dplyr)
library(ggplot2)
library(sf)
library(tidyr)

##Specify here usiang i_am()
# here::i_am("Code/03_data_visualiztion.r")

## Load in cleaned data. 
## If merged_data.csv is not in the cleaned_data folder, then run scripts/01_clean_data.r to create and save it, else load in the file
if (!file.exists(here("Data", "cleaned_data", "merged_data.csv"))) {
  source(here("code", "01_clean_data.r"))
  }
main_data <- read.csv(here("data", "cleaned_data", "merged_data.csv"))

# DATA VISUALIZATIONS

## 1. NC Map Avg Prevalence of Covid (2020) ----

### 1.1 Select Data for NC Map Prevalence ----
covid_prevalence_avg <-merged_data %>% 
  select(fips, date, prevalence, avg_prevalence) %>%
  spread(date, prevalence)
  
### 1.2 Rename merged prevalence/date columns ----
#  rename(prevalence_2020_07_02 = `2020-07-02`, prevalence_2020_07_14 = `2020-07-14`) %>%
  
### 1.3 Calculate change in prevalance for map ----
#    mutate(change_in_prevalence = prevalence_2020_07_14 - prevalence_2020_07_02)

### 1.4 Load NC counties shapefile ----
# DONT KNOW THAT I WILL USE THIS WANT TO KEEP THE SHAPE FILE CODE IN CASE FOR LATER --
nc_map<- sf::st_read(system.file("shape/nc.shp", package= "sf")) %>% 
janitor::clean_names()

### 1.5 Ensure character type of fips column remains an integer ----
nc_map_prevalence <- nc_map %>%
  mutate(fips = as.integer(fips))

### 1.6 Merge the prevalence data with the shapefile ----
nc_map_prevalence <- nc_map_prevalence %>%
  left_join(covid_prevalence_avg, by = c("fips" = "fips"))

### 1.7 Plot the map ----
#-- DONT KNOW IF I WILL USE.. Don't like long and latitude, could figure out changing x & y --
ggplot(nc_map_prevalence) +
  geom_sf(aes(fill = avg_prevalence)) +
  scale_fill_viridis_c(option = "plasma", name = "Avg Prevalence") +
  theme_minimal() +
  labs(title = "Average COVID Prevalence in NC Counties",
       subtitle = "In 2020")+
#remove lat long
  theme(axis.text = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank())+
#move legend to inside
  theme(legend.position = "bottom")


## 2 NC Map povery rates (2019) ----

### 2.1 Load NC counties shapefile ----
nc_map<- sf::st_read(system.file("shape/nc.shp", package= "sf")) %>% 
  janitor::clean_names()

### 2.2 Ensure character type of fips column remains an integer ----
nc_map_poverty <- nc_map %>%
  mutate(fips = as.integer(fips))

### 2.3 Merge the poverty data with the shapefile ----
nc_map_poverty <- nc_map_poverty %>%
  left_join(merged_data, by = c("fips" = "fips"))

### 2.4 Plot the map ----
ggplot(nc_map_poverty) +
  geom_sf(aes(fill = prop_poverty)) +
  scale_fill_viridis_c(option = "plasma", name = "Poverty Rates (%)") +
  theme_minimal() +
  labs(title = "Povery Rates in NC Counties",
       subtitle = "Percent of Population Impoverished")+
  #remove lat long
  theme(axis.text = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank())+
  #move legend to inside
  theme(legend.position = "bottom")


plot_usmap(include = c("NC"), data = covid_prevalence_changes, values = "change_in_prevalence", regions= "counties")+
           scale_fill_continuous(low= "white", high = "blue", name = "Prevalence of Covid", label= scales::comma)+
            labs(title = "Change in Covid-19 Prevalance in NC Counties", subtitle = "Data from July 2, 2020 to July 14, 2020 Adjusted for Population")+
            theme(legend.position = "right")

