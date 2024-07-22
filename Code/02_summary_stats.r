# 02_summary_stats.r

# 0. SETUP

# 02_summary_stats.r

# 0. SETUP ----
#install.packages("reshape2") 

## Load Packages
pacman::p_load(dplyr,gt, gtsummary, here, boot, tidyr, kintr, reshape2)-

## Specify here using i_am()
#setwd("~/Desktop/ENABLE/ENABLE mask ban analysis/ENABLE-mask-ban-")
here::i_am("Code/02_summary_stats.r")

## Load in cleaned data. 
## If merged_data.csv is not in the cleaned_data folder, then run scripts/01_clean_data.r to create and save it, else load in the file
if (!file.exists(here("Data", "cleaned_data", "merged_data.csv"))) {
  source(here("code", "01_clean_data.r"))
}
main_data <- read.csv(here("data", "cleaned_data", "merged_data.csv"))

### 1.1.1 Summary Stats
summary(merged_data)

### 1.1.2 Detailed Summary Stats
merged_data %>%
  tbl_summary()

# SUMMARY STATISTICS ----

# 1. Merged Data ----
## 1.1 Covid prevalence Stats----

### 1.1.1 Add column for covid prevalence ----
merged_data <- merged_data %>%  
  mutate(prevalence = cases / population)

### 1.1.2 Add column for avg prevalence by fips ----
merged_data <- merged_data %>% 
  group_by(fips) %>% 
  mutate(avg_prevalence = mean(prevalence, na.rm = TRUE)) %>% 
  ungroup()

### 1.1.3 Add column for change in covid prevalence ----
covid_prevalence_data <- merged_data %>% 
  select(fips, date, prevalence) %>%
  spread(date, prevalence) %>%
  rename(prevalence_2020_07_02 = `2020-07-02`, prevalence_2020_07_14 = `2020-07-14`) %>%
  mutate(change_in_prevalence = prevalence_2020_07_14 - prevalence_2020_07_02)

### 1.1.4 left join new column to merged data
merged_data <- merged_data %>%
  left_join(covid_prevalence_data %>% 
              select(fips, change_in_prevalence), by = "fips") 


### 1.1.5 Add column for covid prevalence ----
merged_data <- merged_data %>%  
  mutate(prevalence = cases / population)

### 1.1.6 Add column for avg prevalence by fips ----
merged_data <- merged_data %>% 
  group_by(fips) %>% 
  mutate(avg_prevalence = mean(prevalence, na.rm = TRUE)) %>% 
  ungroup()

### 1.1.7 Add column for change in covid prevalence ----
covid_prevalence_data <- merged_data %>% 
  select(fips, date, prevalence) %>%
  spread(date, prevalence) %>%
  rename(prevalence_2020_07_02 = `2020-07-02`, prevalence_2020_07_14 = `2020-07-14`) %>%
  mutate(change_in_prevalence = prevalence_2020_07_14 - prevalence_2020_07_02)

### 1.1.8 left join new column to merged data
merged_data <- merged_data %>%
  left_join(covid_prevalence_data %>% 
  select(fips, change_in_prevalence), by = "fips") 



## 1.2 Correlation between Variables in Merged Data ----
### 1.2.1 *poverty (0.581788016732757)----
# Calculate correlation
correlation <- cor(merged_data$"prop_poverty", merged_data$"avg_prevalence", use = "complete.obs")
print(paste("Correlation between poverty and covid prevalence: ", correlation))

### 1.2.2 chd_hosp (NOT SIGNIFICANT: 0.42179211437511)----
# Calculate correlation
correlation <- cor(merged_data$"chd_hosp", merged_data$"avg_prevalence", use = "complete.obs")
print(paste("Correlation between chronic heart diesease and covid prevalence: ", correlation))

  ### 1.2.3 *ob_prev_adj (0.520943274428159)----
# Calculate correlation
correlation <- cor(merged_data$"ob_prev_adj", merged_data$"avg_prevalence", use = "complete.obs")
print(paste("Correlation between chronic heart diesease hospitalization and covid prevalence: ", correlation))

### 1.2.4 hypertension_hosp (NOT SIGNIFICANT: 0.431920304816451)----
# Calculate correlation
correlation <- cor(merged_data$"hypertension_hosp", merged_data$"avg_prevalence", use = "complete.obs")
print(paste("Correlation between hypertension hospitalization and covid prevalence: ", correlation))

### 1.2.5 prop_diabetes (NOT SIGNIFICANT: 0.422220996863624)----
#prop_diabetes is a factor, need to convert to numeric
merged_data$prop_diabetes <- as.numeric(as.character(merged_data$prop_diabetes))
# Calculate correlation
correlation <- cor(merged_data$"prop_diabetes", merged_data$"avg_prevalence", use = "complete.obs")
print(paste("Correlation between prop diabetes and covid prevalence: ", correlation))

### 1.2.6 **prop_edu_less_high_school (0.706607756775956)----
# Calculate correlation
correlation <- cor(merged_data$"prop_edu_less_high_school", merged_data$"avg_prevalence", use = "complete.obs")
print(paste("Correlation between prop w/o high school diploma and covid prevalence: ", correlation))

### 1.2.7 prop_edu_less_college (NOT SIGNIFICANT: 0.429464181325142)----
# Calculate correlation
correlation <- cor(merged_data$"prop_edu_less_college", merged_data$"avg_prevalence", use = "complete.obs")
print(paste("Correlation between prop w/o college degree and covid prevalence: ", correlation))

### 1.2.8 prop_food_stamp_snap_recip (NOT SIGNIFICANT: 0.483517105272379)----
# Calculate correlation
correlation <- cor(merged_data$"prop_food_stamp_snap_recip", merged_data$"avg_prevalence", use = "complete.obs")
print(paste("Correlation between prop food stamp recipiant and covid prevalence: ", correlation))

### 1.2.9 median_hhi (NOT SIGNIFICANT: -0.436341904085857)----
# Calculate correlation
correlation <- cor(merged_data$"median_hhi", merged_data$"avg_prevalence", use = "complete.obs")
print(paste("Correlation between median household income and covid prevalence: ", correlation))

### 1.2.10 income_inequal (NOT SIGNIFICANT: 0.253242830983877)----
# Calculate correlation
correlation <- cor(merged_data$"income_inequal", merged_data$"avg_prevalence", use = "complete.obs")
print(paste("Correlation between income inequality and covid prevalence: ", correlation))

### 1.2.11 unemployment_rate (NOT SIGNIFICANT: 0.368148635344851)----
# Calculate correlation
correlation <- cor(merged_data$"unemployment_rate", merged_data$"avg_prevalence", use = "complete.obs")
print(paste("Correlation between unemployment rate and covid prevalence: ", correlation))

### 1.2.12 annual_pm2_5 (NOT SIGNIFICANT: 0.296946436197328)----
# Calculate correlation
correlation <- cor(merged_data$"annual_pm2_5", merged_data$"avg_prevalence", use = "complete.obs")
print(paste("Correlation between annual PM2.5 and covid prevalence: ", correlation))

### 1.2.13 *prop_uninsured (0.501906347684064)----
# Calculate correlation
correlation <- cor(merged_data$"prop_uninsured", merged_data$"avg_prevalence", use = "complete.obs")
print(paste("Correlation between prop uninsured and covid prevalence: ", correlation))

### 1.2.14 *prop_medicaid_eligible (0.563496999727039)----
# Calculate correlation
correlation <- cor(merged_data$"prop_medicaid_eligible", merged_data$"avg_prevalence", use = "complete.obs")
print(paste("Correlation between prop medicaid eligible and covid prevalence: ", correlation))

### 1.2.15 pop_per_sq_mile (NOT SIGNIFICANT: -0.0730449518986835)----
# Calculate correlation
correlation <- cor(merged_data$"pop_per_sq_mile", merged_data$"avg_prevalence", use = "complete.obs")
print(paste("Correlation between population per square mile and covid prevalence: ", correlation))

### 1.2.16 *p_nonwhite (0.564579593004188)----
# Calculate correlation
correlation <- cor(merged_data$"p_nonwhite", merged_data$"avg_prevalence", use = "complete.obs")
print(paste("Correlation between percent nonwhite population and covid prevalence: ", correlation))

### 1.2.17 *p_white (-0.564579593004188)----
# Calculate correlation
correlation <- cor(merged_data$"p_white", merged_data$"avg_prevalence", use = "complete.obs")
print(paste("Correlation between percent white population and covid prevalence: ", correlation))


### 1.2.18 masking prevalence and change in covid prevalence----
# Calculate correlation
correlation <- cor(merged_data$"combined_probability", merged_data$"change_in_prevalence.x", use = "complete.obs")
print(paste("Correlation between masking prevalence and change in covid prevalence: ", correlation))

### 1.2.18 masking prevalence----
# Calculate correlation
correlation <- cor(merged_data$"combined_probability", merged_data$"avg_prevalence", use = "complete.obs")
print(paste("Correlation between masking prevalence and change in covid prevalence: ", correlation))



# Calculate the correlation
correlation <- cor(merged_data$mask_wearing_freq_always, merged_data$change_in_prevalence.x, use = "complete.obs")

# Print the result
print(paste("Correlation between percent of population wearing mask frequently or always and COVID-19 prevalence: ", correlation))

## 1.3 Covid nyt mask Stats----

### 1.3.1: Calculate the probabilities for each mask adherence category ----
merged_data <- merged_data %>%
  rowwise() %>%
  mutate(
    prob_never = never,
    prob_rarely = rarely,
    prob_sometimes = sometimes,
    prob_frequently = frequently,
    prob_always = always
  ) %>%
  ungroup()

### 1.3.2: Create a function to simulate the mask adherence for a set of 10 people with sampling ----
simulate_100_people <- function(prob_never, prob_rarely, prob_sometimes, prob_frequently, prob_always) {
  adherence <- sample(c("never", "rarely", "sometimes", "frequently", "always"),
                      size = 10,
                      replace = TRUE,
                      prob = c(prob_never, prob_rarely, prob_sometimes, prob_frequently, prob_always))
  return(adherence)
}

### 1.3.3: Apply the simulation for each county, a ten times, and combine results ----
set.seed(123)  # For reproducibility
simulated_data <- merged_data %>%
  rowwise() %>%
  mutate(
    simulations = list(replicate(10, simulate_100_people(prob_never, prob_rarely, prob_sometimes, prob_frequently, prob_always), simplify = FALSE))
  ) %>%
  ungroup()

### 1.3.4: Calculate the average likelihood of people in the sample being masked and combine the results ----
simulated_data <- simulated_data %>%
  rowwise() %>%
  mutate(
    avg_mask_likelihood = mean(unlist(sapply(simulations, function(sim) mean(sim %in% c("frequently", "always"))))) * 100
  ) %>%
  ungroup()


### 1.3.5: View the results ----
print(simulated_data %>% select(fips, avg_mask_likelihood))

### 1.3.6: Left join new column to merged data
 merged_data <- merged_data %>%
   left_join(simulated_data %>%
               select(fips, avg_mask_likelihood), by = "fips")
 
 # Check if the column has been added and is numeric
 str(merged_data$avg_mask_likelihood)

### 1.3.7: Calculate correlation between mask adherence and covid prevalence (NULL: -0.0475335676764584")
# Ensure both columns are numeric
 merged_data$avg_mask_likelihood <- as.numeric(merged_data$avg_mask_likelihood)
 
 correlation <- cor(merged_data$avg_mask_likelihood, merged_data$avg_prevalence, use = "complete.obs")
 print(paste("Correlation between mask adherence and covid prevalence: ", correlation))


# 
# 
# # 2.0 CDC Data ----
# 
# ## 2.1 Summary Stats ----
# summary(cdc_immunization_current)
# 
# ### 2.2.1 Detailed Summary Stats: Organized by Group Names ----
# 
# # Select relevant columns
# selected_data <- cdc_immunization_current %>%
#   select(group_name, indicator_category, estimate_percent)
# 
# #use selected data to create summary table
# cdc_groups_summary_table <- selected_data %>%
#   tbl_summary(
#     by = group_name,
#     label = list(
#       group_name ~ "Group Name"
#     )
#   )
# 
# #view summary table
# cdc_groups_summary_table
# 
# # Create summary statistics table
# cdc_groups_summary_table <- selected_data %>%
#   tbl_summary(
#     by = indicator_category,
#     
#     label = list(
#       indicator_category ~ "Indicator Category"
#     )
#   )
# 
# # Display the summary table
# cdc_groups_summary_table
# 
# ### 1.2.3 Detailed Summary Stats: Organized by Group Names and Group Category
# 
# # Select relevant columns
# selected_data <- cdc_data_current %>%
#   select(group_name, group_category, indicator_category, estimate_percent)
# 
# # Create summary statistics table
# cdc_age_race_summary_table <- selected_data %>%
#   tbl_summary(
#     by = indicator_category,
#     statistic = all_continuous() ~ "{mean} ({sd})", # You can customize the statistics as needed
#     label = list(
#       indicator_category ~ "Indicator Category"
#     )
#   )
# 
# # Display the summary table
# summary_table
# 
# # Filter the data for the specified group_name
# filtered_data <- cdc_data_current %>%
#   filter(group_name == "Social Vulnerability Index (SVI) of county of residence")
# 
# # Create summary statistics table
# summary_table <- filtered_data %>%
#   select(group_category, indicator_category, estimate_percent) %>%
#   tbl_summary(
#     by = indicator_category,
#     statistic = all_continuous() ~ "{mean} ({sd})", # Customize the statistics as needed
#     label = list(
#       indicator_category ~ "Indicator Category"
#     )
#   )
# summary_table
# 
# 
# 
# # Select relevant columns
# selected_data <- cdc_data_current %>%
#   select(group_name, group_category, indicator_category, estimate_percent)
# 
# # Create summary statistics table
# summary_table <- selected_data %>%
#   tbl_summary(
#     by = indicator_category,
#     statistic = all_continuous() ~ "{mean} ({sd})", # You can customize the statistics as needed
#     label = list(
#       indicator_category ~ "Indicator Category"
#     )
#   )
# 
# # Display the summary table
# summary_table
# 
# 
# 
# 
# 
# 
# # Create pivot table
# pivot_table <- cdc_data_current %>%
#   group_by(indicator_category, group_category) %>%
#   summarize(estimate_percent = mean(estimate_percent, na.rm = TRUE), .groups = 'drop') %>%
#   pivot_wider(names_from = group_category, values_from = estimate_percent, values_fill = list(estimate_percent = "No data")) %>%
#   gt() %>%
#   sub_missing(
#     columns = everything(),
#     missing_text = "No data"
#   ) %>%
#   tab_header(
#     title = "CDC DATA"
#   ) %>%
#   tab_footnote(
#     footnote = "Time period: September 24 - October 28 2023",
#     locations = cells_column_labels(
#       columns = everything()
#     )
#   )
# 
# # Display the pivot table
# pivot_table
# 
# 
# 
# ## 1.3 Summary Table with N and % ----
# 
# # Summary table with N and %
# main_data %>% 
#   # select(date, indicator_category) %>%
#   tbl_summary( statistic = all_continuous() ~ "{mean} ({sd})",
#                type = all_categorical() ~ "categorical")
# 
# 
# ## 3. Calculate mask adherence by county ----
# ``
# 
# 
