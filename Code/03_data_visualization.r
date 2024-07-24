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
library(corrplot)


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




## 3. Create a coorelation matrix for the merged_data dataset that includes all the numeric columns ----

### 3.1 create data frame with numeric columns from merged_data set ----
Merged_Percents <- merged_data %>%
  select("prop_poverty", "chd_hosp", "ob_prev_adj", "hypertension_hosp", "prop_diabetes", 
         "prop_edu_less_high_school", "prop_edu_less_college", "prop_food_stamp_snap_recip", 
         "median_hhi", "income_inequal", "prop_uninsured", "prop_medicaid_eligible", 
         "pop_per_sq_mile", "housing_per_sq_mile", "avg_prevalence", "deaths", "combined_probability")

### 3.2 find correlations between variables ----
correlation_matrix <- cor(Merged_Percents, use = "pairwise.complete.obs")

### 3.3 plot correlation matrix on heatmap ----
cor_df <- melt(correlation_matrix)

 ggplot(cor_df, aes(Var1, Var2, fill = value)) +
  geom_tile() +
  scale_fill_gradient2(low = "blue", high = "blue", mid = "white",
                       midpoint = 0, limits = c(-1, 1),
                       space = "Lab",
                       name = "Correlation") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, vjust = 1, size = 7, hjust = 1)) +
  labs(title = "Correlation Heatmap") +
  coord_fixed()

### 3.4 Filter correlations above 0.5 ----
high_Pcorrelations <- high_Pcorrelations %>%
  filter(abs(value) > 0.5)

### 3.5 Order the high correlations from lowest to highest ----
high_Pcorrelations <- high_Pcorrelations %>%
  arrange(desc(value))

### 3.6 Print the high correlations ----
print(high_Pcorrelations)
 
 
 
 ## 4. Choroopleth Map of Covid Prevalence Changes in NC Counties in 2020 and compares them to county detriminents of health ----
 ### 3a. Create a facet plot of actual values
 ### Subset needed data for merged_data to only include 2020-2020
merged_data_viz <- merged_data %>%
   filter(year %in% 2020:2020) %>%
   mutate(viz_actual = ifelse(viz_actual == 0, NA, viz_actual)) %>%  # This is done to stretch the palette.
   select(c("fips", "name", "year", "viz_actual")) %>%
   left_join(counties, by = c("fips" = "GEOID"))
 
 
 ### Create a facet wrap by year, plotting actual ED rates using ggplot geom_sf
 merged_data_plot <- merged_data_viz %>%
   ggplot(aes(fill = edrate_actual, geometry = geometry)) +
   geom_sf() +
   facet_wrap(~ year, ncol = 2) +
   labs(title = "County Detriments of Health",
        fill = "ED Rate") +
   theme_bw() +
   theme(
     text = element_text(family = "serif"),
     plot.title = element_text(hjust = 0.5),
     legend.position = "none"
   ) +
   scale_fill_viridis_c(option = "viridis",
                        direction = -1,
                        na.value = "grey95") +
   guides(fill = guide_colorbar(title.position = "top")) +
   coord_sf(datum = NA)
 
 ### 3b. Create a plot of predicted values in 2020
 ### Subset analytic_df to only include 2015-2019
 df_pred <- analytic_df %>%
   filter(year == 2020) %>%
   mutate(edrate_pred = ifelse(edrate_pred == 0, NA, edrate_pred)) %>%  # This is done to stretch the palette.
   select(c("fips", "name", "year", "edrate_pred")) %>%
   left_join(counties, by = c("fips" = "GEOID"))
 
 ### Create a facet wrap by year, plotting actual ED rates using ggplot geom_sf
 pred_plot <- df_pred %>%
   ggplot(aes(fill = edrate_pred, geometry = geometry)) +
   geom_sf() +
   labs(title = "Predicted (2020)",
        fill = "ED Rate") +
   theme_bw() +
   theme(text = element_text(family = "serif"),
         plot.title = element_text(hjust = 0.5),
         legend.position = "bottom") +
   scale_fill_viridis_c(option = "viridis",
                        direction = -1,
                        na.value = "grey95") +
   guides(fill = guide_colorbar(title.position = "top")) +
   coord_sf(datum = NA)
 
 ### 3c. Print combined plot
 choropleth <-
   (actual_plot) | (pred_plot + plot_layout(guides = 'keep'))
 
 choropleth <-
   choropleth + plot_layout(widths = c(2, 1)) +
   plot_annotation(title = 'Observed ED Rates (2015-2019) vs. Predicted ED rates (2020)',
                   subtitle = 'ED Rates corresponding to visits per 10,000 persons',
                   caption = 'Note: Counties with 0 ED visits are not depicted')
 
 ### 3d. Save combined plot
 png(
   here::here("figures", "edrate_choropleth.png"),
   width = 8,
   height = 8,
   units = "in",
   res = 300
 )
 
 choropleth &
   theme(
     text = element_text('serif'),
     plot.title = element_text(hjust = 0.5),
     plot.subtitle = element_text(hjust = 0.5),
   )
 
 dev.off()
 
 ## Clear memory before mapping except for analytic_df and counties
 rm(list = ls()[!ls() %in% c("analytic_df", "counties")])
 
 
 




correlation_matrix <- cor(c(fips, date, "never", "rarely", "sometimes", "frequently", "always", "population",
                            "cases", "deaths", "prevalence", "avg_prevalence", "prop_poverty", "p_nonwhite", 
                            "p_white", "prop_diabetes", "chd_hosp", "ob_prev_adj", "hypertension_hosp", 
                            "prop_edu_less_high_school", "prop_edu_less_college", "prop_food_stamp_snap_recip", 
                            "median_hhi", "income_inequal", "prop_uninsured", "prop_medicaid_eligible", 
                            "pop_per_sq_mile", "housing_per_sq_mile","combined_probilities")) 
                          use = "complete.obs")


"fips", "date", "never", "rarely", "sometimes", "frequently", "always", 
                      "population", "cases", "deaths", "prevalence", "avg_prevalence", "prop_poverty", 
                      "p_nonwhite", "p_white", "prop_diabetes", "chd_hosp", "ob_prev_adj", 
                      "hypertension_hosp", "prop_edu_less_high_school", "prop_edu_less_college", 
                      "prop_food_stamp_snap_recip", "median_hhi", "income_inequal", "prop_uninsured", 
                      "prop_medicaid_eligible", "pop_per_sq_mile", "housing_per_sq_mile")




print columns of merged_data
print(colnames(merged_data))
plot_usmap(include = c("NC"), data = covid_prevalence_changes, values = "change_in_prevalence", regions= "counties")+
           scale_fill_continuous(low= "white", high = "blue", name = "Prevalence of Covid", label= scales::comma)+
            labs(title = "Change in Covid-19 Prevalance in NC Counties", subtitle = "Data from July 2, 2020 to July 14, 2020 Adjusted for Population")+
            theme(legend.position = "right")



###PATCHWORK (IN GGPLOT LECTURE) ----
