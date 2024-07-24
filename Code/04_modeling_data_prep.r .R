#04_modeling_data_prep.r

# 0. SETUP ----
#install.packages(dplyr) 

## Load Packages
#pacman::p_load(dplyr,)

## Specify here using i_am()
#setwd("~/Desktop/ENABLE/ENABLE mask ban analysis/ENABLE-mask-ban-")
here::i_am("Code/04_modeling_data_prep.r")

## Load in cleaned data. 
## If merged_data.csv is not in the cleaned_data folder, then run scripts/01_clean_data.r to create and save it, else load in the file
if (!file.exists(here("Data", "cleaned_data", "merged_data.csv"))) {
  source(here("code", "01_clean_data.r"))
}
main_data <- read.csv(here("data", "cleaned_data", "merged_data.csv"))



## 1.1 Create filter dataset for modeling ----

### 1.1.1 Select Important Columns from Data ----
selected_data <- merged_data %>% 
  select(fips,"county", "never", "rarely", "sometimes", "frequently", "always", 
         "mask_adherence_probability", "avg_prevalence", "prop_poverty", 
         "p_nonwhite", "prop_diabetes", "chd_hosp", "ob_prev_adj", "hypertension_hosp", 
         "prop_edu_less_high_school", "median_hhi", "prop_uninsured", 
         "prop_medicaid_eligible", "pop_per_sq_mile")

### 1.1.2 Filter out rows with distinct values ----
selected_data <- selected_data %>% 
  filter(!duplicated(selected_data))


