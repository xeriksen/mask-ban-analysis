# 02_summary_stats.r

# 0. SETUP

# 02_summary_stats.r

# 0. SETUP ----

## Load Packages
pacman::p_load(dplyr, gtsummary, here)

## Specify here using i_am()
here::i_am("Code/02_summary_stats.r")

## Load in cleaned data. 
## If merged_data.csv is not in the cleaned_data folder, then run scripts/01_clean_data.r to create and save it, else load in the file
if (!file.exists(here("cleaned_data", "merged_data.csv"))) {
  source(here("scripts", "01_clean_data.r"))
}
main_data <- read.csv(here("cleaned_data", "merged_data.csv"))

# 1. SUMMARY STATISTICS ----

## 1.1 Main Data ----

### 1.1.1 Summary Stats
summary(main_data)

### 1.1.2 Detailed Summary Stats
main_data %>% 
  select(date, cases, deaths, population, never, rarely, sometimes, frequently, always) %>%
  tbl_summary(statistic = date ~ "({min}, {max})")

## 1.2 CDC Data ----

### 1.2.1 Summary Stats
summary(CDC_data_current)

### 1.2.2 Detailed Summary Stats
CDC_data_current %>% 
  select(time_period, indicator_category) %>%
  tbl_summary(statistic = time_period ~ "{max}",
              indicator_category = c("Healthcare provider recommended I get a COVID-19 vaccine",
                                     "Concerned about COVID-19 disease",
                                     "Received a 2023-2024 COVID-19 vaccine dose (among all adults 18+)",
                                     "Confidence that COVID-19 vaccine is important to protect me (somewhat or very important)",
                                     "Probably will get a second dose of the updated COVID-19 vaccine or unsure (among adults 65+ with >= 1 dose)",
                                     "Received two doses of the 2023-2024 COVID-19 vaccine (among adults 65+)",
                                     "Received a 2023-2024 COVID-19 vaccine dose (among all adults 18+)"))

## 1.3 Summary Table with N and % ----

main_data %>% 
  tbl_summary(statistic = all_continuous() ~ "{mean} ({sd})",
              type = all_categorical() ~ "categorical")


#GET SUMMARY STATS FOR MAIN DATA
summary(main_data)

#GET SUMMARY STATS FOR CDC DATA
summary(CDC_data_current)

#LOAD SUMMARY PACKAGE 
library(gtsummary)

  
#GET SUMMARY STATS FOR MAIN DATA
main_data %>% 
  select(date, cases, deaths, population, never,rarely,sometimes, frequently, always) %>%
  tbl_summary( statistic = date ~ "({min}, {max})")
  
#GET SUMMARY STATS FOR CDC DATA
data=CDC_data_current %>% 
  select(time_period, indicator_category) %>%)
  tbl_summary( statistic = time_period ~ "{max})"
               indicator_category= ("Healthcare provider recommended I get a COVID-19 vaccine",
                                     "Concerned about COVID-19 disease",
                                     "Received a 2023-2024 COVID-19 vaccine dose (among all adults 18+)",
                                     "Confidence that COVID-19 vaccine is important to protect me (somewhat or very important)",
                                     "Probably will get a second dose of the updated COVID-19 vaccine or unsure (among adults 65+ with >= 1 dose)",
                                     "Received two doses of the 2023-2024 COVID-19 vaccine (among adults 65+)",
                                     "Received a 2023-2024 COVID-19 vaccine dose (among all adults 18+)")
               
# Summary table with N and %
main_data %>% 
  # select(date, indicator_category) %>%
  tbl_summary( statistic = all_continuous() ~ "{mean} ({sd})",
               type = all_categorical() ~ "categorical")



library(dplyr)
library(gtsummary)

# GET SUMMARY STATS FOR MAIN DATA
main_data %>%
  select(date, cases, deaths, population, never, rarely, sometimes, frequently, always) %>%
  tbl_summary(
    statistic = date ~ "({min}, {max})",
    label = list(
      cases ~ "Cases",
      deaths ~ "Deaths",
      population ~ "Population",
      never ~ "Never",
      rarely ~ "Rarely",
      sometimes ~ "Sometimes",
      frequently ~ "Frequently",
      always ~ "Always"
    )
  )

# GET SUMMARY STATS FOR CDC DATA
CDC_data_current %>%
  select(time_period, indicator_category) %>%
  tbl_summary(
    statistic = time_period ~ "September 24 - October 28",
    label = list(
      indicator_category ~ "Indicator Category"
    )
  )

library(dplyr)
library(gtsummary)

# GET SUMMARY STATS FOR CDC DATA
CDC_data_current %>%
  select(indicator_category, group_name) %>%
  tbl_summary(
    statistic = list(
      indicator_category ~ "{n} ({p}%)"
    ),
    label = list(
      indicator_category ~ "Indicator Category"|
      group_name ~ "Group Name"

    )
  ) %>%
  modify_header(label = "CDC DATA") %>% # Optional: customize header
  modify_footnote(
    all_stat_cols() ~ "Time period: September 24 - October 28"
  )

# Summary table with N and % for categorical variables
main_data %>%
  select(date, cases, deaths, population, never, rarely, sometimes, frequently, always) %>%
  tbl_summary(
    statistic = all_continuous() ~ "{mean} ({sd})",
    statistic = all_categorical() ~ "{n} ({p}%)",
    type = all_categorical() ~ "categorical",
    label = list(
      date ~ "Date",
      cases ~ "Cases",
      deaths ~ "Deaths",
      population ~ "Population",
      never ~ "Never",
      rarely ~ "Rarely",
      sometimes ~ "Sometimes",
      frequently ~ "Frequently",
      always ~ "Always"
    )
  )
