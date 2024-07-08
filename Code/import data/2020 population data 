#IMPORT 2020 POPULATION DATA NC BY COUNTY 
nc_population_data_by_county <- import("~/Desktop/ENABLE/ENABLE mask ban analysis/ENABLE-mask-ban-/Data/county-population-totals-2.csv")

#DELETE UNNECESSARY COLUMNS FROM NC POPULATION DATA
nc_population_data_by_county <- nc_population_data_by_county %>%
  select(-Variable, -`Council of Government Region`, -`Metropolitan Statistical Area (2013)`, -Vintage, -`Estimate/Projection`)

#RENAME VALUE TO POPULATION IN DATA
nc_population_data_by_county <- nc_population_data_by_county%>%
  rename(Population = Value)

#RENAME VALUE TO POPULATION IN DATA
nc_population_data_by_county <- nc_population_data_by_county%>%
 select(-County)

#CLEAN NAMES POPULATION DATA BY COUNTY
nc_population <- nc_population_data_by_county  %>%
    janitor::clean_names()
