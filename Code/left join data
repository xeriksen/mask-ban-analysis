#LEFT JOIN COVID RATES BY NC COUNTY TO MASK USE BY NC COUNTY 
rates_during_study <- mask_use_study %>%
  left_join(covid_during_mask_study, by = "fips")

#LEFT JOIN NC POPULATION AND MASK DATA BY FIPS
main_data <- covid_during_mask_study %>%
  left_join(nc_population, by = "fips")