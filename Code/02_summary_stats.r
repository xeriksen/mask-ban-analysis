# 02_summary_stats.r

# 0. SETUP

# 02_summary_stats.r

# 0. SETUP ----

## Load Packages
pacman::p_load(dplyr,gt, gtsummary, here, boot, tidyr, kintr)

## Specify here using i_am()
setwd("~/Desktop/ENABLE/ENABLE mask ban analysis/ENABLE-mask-ban-")
here::i_am("Code/02_summary_stats.r")

## Load in cleaned data. 
## If merged_data.csv is not in the cleaned_data folder, then run scripts/01_clean_data.r to create and save it, else load in the file
if (!file.exists(here("Data", "cleaned_data", "merged_data.csv"))) {
  source(here("code", "01_clean_data.r"))
}
main_data <- read.csv(here("data", "cleaned_data", "merged_data.csv"))

# 1. SUMMARY STATISTICS ----

## 1.1 Main Data ----

### 1.1.1 Summary Stats
summary(main_data)

### 1.1.2 Detailed Summary Stats


## 1.2 CDC Data ----

### 1.2.1 Summary Stats
summary(cdc_data_current)

### 1.2.2 Detailed Summary Stats: Organized by Group Names

# Select relevant columns
selected_data <- cdc_data_current %>%
  select(group_name, indicator_category, estimate_percent)

# Create summary statistics table
cdc_groups_summary_table <- selected_data %>%
  tbl_summary(
    by = indicator_category,
    
    label = list(
      indicator_category ~ "Indicator Category"
    )
  )

# Display the summary table
cdc_groups_summary_table

### 1.2.3 Detailed Summary Stats: Organized by Group Names and Group Category

# Select relevant columns
selected_data <- cdc_data_current %>%
  select(group_name, group_category, indicator_category, estimate_percent)

# Create summary statistics table
cdc_age_race_summary_table <- selected_data %>%
  tbl_summary(
    by = indicator_category,
    statistic = all_continuous() ~ "{mean} ({sd})", # You can customize the statistics as needed
    label = list(
      indicator_category ~ "Indicator Category"
    )
  )

# Display the summary table
summary_table

# Filter the data for the specified group_name
filtered_data <- cdc_data_current %>%
  filter(group_name == "Social Vulnerability Index (SVI) of county of residence")

# Create summary statistics table
summary_table <- filtered_data %>%
  select(group_category, indicator_category, estimate_percent) %>%
  tbl_summary(
    by = indicator_category,
    statistic = all_continuous() ~ "{mean} ({sd})", # Customize the statistics as needed
    label = list(
      indicator_category ~ "Indicator Category"
    )
  )
summary_table



# Select relevant columns
selected_data <- cdc_data_current %>%
  select(group_name, group_category, indicator_category, estimate_percent)

# Create summary statistics table
summary_table <- selected_data %>%
  tbl_summary(
    by = indicator_category,
    statistic = all_continuous() ~ "{mean} ({sd})", # You can customize the statistics as needed
    label = list(
      indicator_category ~ "Indicator Category"
    )
  )

# Display the summary table
summary_table






# Create pivot table
pivot_table <- cdc_data_current %>%
  group_by(indicator_category, group_category) %>%
  summarize(estimate_percent = mean(estimate_percent, na.rm = TRUE), .groups = 'drop') %>%
  pivot_wider(names_from = group_category, values_from = estimate_percent, values_fill = list(estimate_percent = "No data")) %>%
  gt() %>%
  sub_missing(
    columns = everything(),
    missing_text = "No data"
  ) %>%
  tab_header(
    title = "CDC DATA"
  ) %>%
  tab_footnote(
    footnote = "Time period: September 24 - October 28 2023",
    locations = cells_column_labels(
      columns = everything()
    )
  )

# Display the pivot table
pivot_table



## 1.3 Summary Table with N and % ----

# Summary table with N and %
main_data %>% 
  # select(date, indicator_category) %>%
  tbl_summary( statistic = all_continuous() ~ "{mean} ({sd})",
               type = all_categorical() ~ "categorical")

