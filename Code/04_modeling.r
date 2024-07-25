# 04_modeling.r

# 0. SETUP ----
## 0.1 Load Packages ----
pacman::p_load(dplyr, randomForest, tidyverse, caret, doParallel, here, pdp, vip)

## 0.2 Specify here using i_am() ----
#setwd("~/Desktop/ENABLE/ENABLE mask ban analysis/ENABLE-mask-ban-")
#here::i_am("Code/04_modeling.r")

# 1. LOAD DATA ----
## 1.1 Load in cleaned data ----
if (!file.exists(here("Data", "cleaned_data", "merged_data.csv"))) {
  source(here("code", "01_clean_data.r"))
}
model_data <- read.csv(here("data", "cleaned_data", "model_data.csv"))

# 2. MODELING ----
## 2.1 Create filter dataset for modeling ----

### 2.1.1 Select Important Columns from Data ----
selected_data <- model_data %>%
  select(
    # "population",
    "housing_per_sq_mile",
    # fips,
    # "county",
    "never",
    # "rarely",
    # "sometimes",
    # "frequently",
    # "always",
    # "mask_adherence_probability",
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
    # "prop_medicaid_eligible",
    "pop_per_sq_mile"
  )

### 2.1.2 Filter out rows with distinct values ----
selected_data <- selected_data %>%
  filter(!duplicated(selected_data))

## 2.2 Save selected data ----
write.csv(selected_data,
          here("data", "cleaned_data", "selected_data.csv"))

# 3. RANDOM FOREST MODEL ----
## 3.1 Set seed for reproducibility ----
set.seed(123)

## 3.2 Create a cluster with the number of cores available minus one ----
cl <- makeCluster(detectCores() - 1)
registerDoParallel(cl)

## 3.3 Prepare the data ----
X <- selected_data %>% select(-avg_prevalence)
y <- selected_data$avg_prevalence

## 3.4 Split the data ----
set.seed(42)
train_index <- createDataPartition(y, p = 0.8, list = FALSE)
X_train <- X[train_index, ]
X_test <- X[-train_index, ]
y_train <- y[train_index]
y_test <- y[-train_index]

## 3.5 Scale the features ----
preprocess_params <- preProcess(X_train, method = c("center", "scale"))
X_train_scaled <- predict(preprocess_params, X_train)
X_test_scaled <- predict(preprocess_params, X_test)

## 3.6 Define the parameter grid for tuning ----
param_grid <- expand.grid(
  mtry = seq(2, length(X_train_scaled), by = 1),
  min.node.size = seq(1, 10, by = 1),
  splitrule = c("variance", "extratrees")
)

## 3.7 Set up cross-validation ----
ctrl <- trainControl(method = "cv",
                     number = 5,
                     verboseIter = TRUE)

## 3.8 Perform grid search ----
set.seed(42)
rf_tuned <- train(
  x = X_train_scaled,
  y = y_train,
  method = "ranger",
  num.trees = 500,
  importance = "permutation",
  trControl = ctrl,
  tuneGrid = param_grid
)

## 3.9 Print best parameters ----
print(rf_tuned$bestTune)

## 3.10 Make predictions on the test set ----
y_pred <- predict(rf_tuned, X_test_scaled)

## 3.11 Calculate performance metrics ----
mse <- mean((y_test - y_pred) ^ 2)
rmse <- sqrt(mse)
mae <- mean(abs(y_test - y_pred))
r2 <- 1 - sum((y_test - y_pred) ^ 2) / sum((y_test - mean(y_test)) ^ 2)

cat("Mean Squared Error:", mse, "\n")
cat("Root Mean Squared Error:", rmse, "\n")
cat("Mean Absolute Error:", mae, "\n")
cat("R-squared Score:", r2, "\n")

## 3.12 Calculate feature importances ----
importance <- varImp(rf_tuned, scale = FALSE)
feature_imp <- importance$importance
feature_imp$Feature <- rownames(feature_imp)
feature_imp <- feature_imp[order(-feature_imp$Overall), ]
feature_imp <- feature_imp %>% slice_max(Overall, n = 10)

## 3.13 Create a mapping of variable names to full descriptions
var_descriptions <- c(
  "never" = "% Population Never Masking",
  "prop_poverty" = "% Population in Poverty",
  "p_nonwhite" = "% Population Non-White",
  "prop_diabetes" = "Diabetes Prevalence",
  "chd_hosp" = "CHD Hospitalization Rate",
  "ob_prev_adj" = "Obesity Prevalence",
  "hypertension_hosp" = "Hypertension Hospitalization Rate",
  "prop_edu_less_high_school" = "% Population with Less than High School Education",
  "prop_uninsured" = "% Population Uninsured",
  "pop_per_sq_mile" = "Population per Square Mile",
  "housing_per_sq_mile" = "Housing Units per Square Mile"
)

## 3.14 Add full descriptions to the feature_imp dataframe
feature_imp$FullDescription <- var_descriptions[feature_imp$Feature]


## 3.13 Print feature importances ----
print(feature_imp)

## 3.14 Plot feature importances ----
feature_imp %>%
  ggplot(aes(y = Overall, x = reorder(FullDescription, Overall))) +
  geom_bar(stat = "identity", fill = "#2E86AB") +
  coord_flip() +
  theme_minimal() +
  labs(x = "Variables", y = "Variable Importance",
       title = "Variable Importance in Random Forest Model") +
  # Multiple the importance by 10000 to make the values more interpretable 
  scale_y_continuous(labels = scales::number_format(scale = 1000000)) +
  theme(axis.text.y = element_text(size = 8))  # Adjust text size if needed

## 3.15 Model summary ----
cat("Model Summary:\n")
cat("Explained Variance:", rf_tuned$results$Rsquared[1], "\n")
cat("RMSE:", rf_tuned$results$RMSE[1], "\n")
cat("MAE:", rf_tuned$results$MAE[1], "\n")

