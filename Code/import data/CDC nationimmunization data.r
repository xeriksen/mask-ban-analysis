#IMPORT CDC DATA - National Immunization data 2024 
CDC_National_Immunization_data_2024 <- import("~/Desktop/ENABLE/ENABLE mask ban analysis/National_Immunization_Survey_Adult_COVID_Module__NIS-ACM___COVIDVaxViews__Data___Centers_for_Disease_Control_and_Prevention__cdc.gov__20240627.csv")

#FILTER NC FAROM CDC DATA - National Immunization data 2024 
CDC_nc_Immunization_data_2024 <- CDC_National_Immunization_data_2024 %>%
  filter(Geography == "North Carolina")

#CLEAN NAMES CDC DATA 
CDC_data_2024 <- CDC_nc_Immunization_data_2024 %>%
  janitor::clean_names()

#FILTER CDC DATA
CDC_data_current <- CDC_data_2024 %>%
  filter(indicator_category == "Healthcare provider recommended I get a COVID-19 vaccine"|
  indicator_category == "Concerned about COVID-19 disease"|
  indicator_category == "Received a 2023-2024 COVID-19 vaccine dose (among all adults 18+)"|
  indicator_category == "Confidence that COVID-19 vaccine is important to protect me (somewhat or very important)"|
  indicator_category == "Probably will get a second dose of the updated COVID-19 vaccine or unsure (among adults 65+ with >= 1 dose)"|
  indicator_category == "Received two doses of the 2023-2024 COVID-19 vaccine (among adults 65+)"|
  indicator_category == "Received a 2023-2024 COVID-19 vaccine dose (among all adults 18+)")