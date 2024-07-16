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

## 1. NC Map Prevalence of Covid (07/02/2020-07/14/2020) ----

### 1.1.1 Select Data for NC Map Prevalence --- 
covid_prevalence_changes<-merged_data %>% 
  select(fips, date, prevalence) %>%
  spread(date, prevalence) %>%
  
### 1.1.2 Rename merged prevalence/date columns ----
  rename(prevalence_2020_07_02 = `2020-07-02`, prevalence_2020_07_14 = `2020-07-14`) %>%
  
### 1.1.3 Calculate change in prevalance for map ----
    mutate(change_in_prevalence = prevalence_2020_07_14 - prevalence_2020_07_02)

### 1.1.4 Load NC counties shapefile ----
# DONT KNOW THAT I WILL USE THIS WANT TO KEEP THE SHAPE FILE CODE IN CASE FOR LATER --
nc_map_prevalence <- sf::st_read(system.file("shape/nc.shp", package= "sf")) %>% 
janitor::clean_names()

### 1.1.5 Ensure character type of fips column remains an integer ----
nc_map_prevalence <- nc_map_prevalence %>%
  mutate(fips = as.integer(fips))

### 1.1.6 Merge the prevalence data with the shapefile ----
nc_map_prevalence <- nc_map_prevalence %>%
  left_join(covid_prevalence_changes, by = c("fips" = "fips"))

### 1.1.7 Plot the map ----
#-- DONT KNOW IF I WILL USE.. Don't like long and latitude, could figure out changing x & y --
ggplot(nc_map_prevalence) +
  geom_sf(aes(fill = change_in_prevalence)) +
  scale_fill_viridis_c(option = "plasma", name = "Change in Prevalence") +
  theme_minimal() +
  labs(title = "Change in COVID Prevalence in NC Counties",
       subtitle = "From 2020-07-02 to 2020-07-14")+
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

