#IMPORT NYTIMES DATA - COVID RATES BY COUNTY
nyt_covid_rates_by_county <- import("~/Desktop/ENABLE/ENABLE mask ban analysis/ENABLE-mask-ban-/Data/nyt- covid-19-data-master/us-counties-2020.csv")

#FILTER NC FROM NYTIMES DATA - COVID RATES BY COUNTY
nyt_covid_rates_by_nc_county <- nyt_covid_rates_by_county%>%
  filter(state == "North Carolina")

#FILTER 2020-07-02 to 2020-07-14 FROM NYTIMES NC DATA - COVID RATES BY COUNTY
"nyt_covid_rates_by_nc_county_during_mask_study" <- nyt_covid_rates_by_nc_county %>%
  filter(date >= as.Date("2020-07-02") & date <= as.Date("2020-07-14"))

#CLEAN NAMES COVID RATES DURING MASK STUDY DATA BY COUNTY
rates_during_study <- nyt_covid_rates_by_nc_county_during_mask_study  %>%
  janitor::clean_names()