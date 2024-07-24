#04_modeling.r

# 0. SETUP ----
#install.packages(dplyr) 

## Load Packages
pacman::p_load(dplyr,randomForest, tidyverse, caret, doParallel)

## Specify here using i_am()
#setwd("~/Desktop/ENABLE/ENABLE mask ban analysis/ENABLE-mask-ban-")
#here::i_am("Code/04_modeling.r")

## Load in cleaned data. 
## If merged_data.csv is not in the cleaned_data folder, then run scripts/01_clean_data.r to create and save it, else load in the file
if (!file.exists(here("Data", "cleaned_data", "merged_data.csv"))) {
  source(here("code", "01_clean_data.r"))
}
main_data <- read.csv(here("data", "cleaned_data", "merged_data.csv"))

# #save merged_data
# write_csv(merged_data, here("data", "cleaned_data", "model_data.csv"))

## 1.1 Create filter dataset for modeling ----

### 1.1.1 Select Important Columns from Data ----
selected_data <- merged_data %>%
  select(
    # "population",
    "housing_per_sq_mile",
    # fips,
    #"county",
    # "never",
    # "rarely",
    # "sometimes",
    # "frequently",
    # "always",
     "mask_adherence_probability",
    # "mask_wearing_freq_always",
    "avg_prevalence",
    "prop_poverty",
    "p_nonwhite",
    "prop_diabetes",
    "chd_hosp",
    "ob_prev_adj",
    "hypertension_hosp",
    "prop_edu_less_high_school",
    "prop_uninsured",
    "prop_medicaid_eligible",
    "pop_per_sq_mile"
   )

### 1.1.2 Filter out rows with distinct values ----
selected_data <- selected_data %>% 
  filter(!duplicated(selected_data))


## 1.2 Start random forest model ----

### 1.2.1 Set seed for reproducibility ----
set.seed(123)

## 1.2.2 Create a cluster with the number of cores available minus one
cl <- makeCluster(detectCores() - 1)
##Register the cluster for parallel processing
registerDoParallel(cl)

### 1.2.3 Fit random forest model ----
rf_model <- randomForest(
  x=selected_data %>% select(-avg_prevalence), 
  y= selected_data$avg_prevalence, 
  importance = TRUE,
  ntree = 500,
)

print(rf_model)

### 1.2.4 Parameter tuning ----

# Parameter tuning
# Tuning mtry

#### 1.2.4.1 Tuning mtry ----
mtry_results <- tuneRF(
  x = selected_data %>% select(-avg_prevalence),  # Predictors
  y = selected_data$avg_prevalence,               # Response variable
  ntreeTry = 500,                  # Number of trees to try
  stepFactor = 1,                # Factor to increase mtry
  improve = 0.01,                  # Minimum improvement to continue
  trace = TRUE,                    # Print progress to console
  plot = TRUE                      # Plot the results
)


# Find best mtry
best_mtry <- mtry_results[which.min(mtry_results[, "OOBError"]), "mtry"]
cat("Best mtry:", best_mtry, "\n")

#### 1.2.4.2 Finding optimal number of trees ----
rf_model_large <- randomForest(
  x = selected_data %>% select(-avg_prevalence),  # Predictors
  y = selected_data$avg_prevalence,               # Response variable
  importance = TRUE,               # Calculate variable importance
  ntree = 5000,                    # Use a larger number of trees
  mtry = best_mtry                 # Use the best mtry we found
)


rf_error_df <- data.frame(
  MSE = rf_model_large$mse,
  ITERATION = seq_along(rf_model_large$mse)
)


ggplot(rf_error_df, aes(x = ITERATION, y = MSE)) +
  geom_line() +
  theme_minimal() +
  labs(title = "MSE vs Number of Trees",
       x = "Number of Trees",
       y = "Mean Squared Error")

optimal_n_trees <- which.min(rf_error_df$MSE)
cat("Optimal number of trees:", optimal_n_trees, "\n")

# Final model with optimal parameters
rf_final_model <- randomForest(
  x = selected_data %>% select(-avg_prevalence),
  y = selected_data$avg_prevalence,
  mtry = best_mtry,
  importance = TRUE,
  ntree = optimal_n_trees
)

print(rf_final_model)
rf_features <- importance(rf_final_model) %>%
  as.data.frame() %>%
  mutate(feature = rownames(.)) %>%
  arrange(desc("%IncMSE"))

# Show top features
print(rf_features)

# rename %IncMSE to feature importance
rf_features <- rf_features %>%
  rename(imp = "%IncMSE") %>% 
  #only retain first 11 observations arranged desc
  slice_max(imp, n = 20)

# ## Label variables in the full name
# #label vars in the full name
# rf_features$feature <- c("Proportion of Population with Less than High School Education", "Proportion of Non-White Population", 
#                          "Poverty Rate", "Proportion of Medicaid Eligible Population", "Proportion of Uninsured Population", 
#                          "Coronary Heart Disease Hospitalization Rate", "Median Household Income", "Population per Square Mile",
#                          "Hypertension Hospitalization Rate", "Rare Mask Adherence", "Frequent Mask Adherence")

###1.2.? Evaluate variable importance ----
rf_features %>%
  ggplot(aes(x = imp, y = reorder(feature, imp))) + 
  geom_point(color = "#2E86AB", size = 3) + 
  geom_segment(aes(xend = 0, yend = feature), color = "#2E86AB") +
  theme_minimal() +
  labs(x = "Variable Importance ", y = "Variables", 
       title = "Variable Importance in Random Forest Model")
