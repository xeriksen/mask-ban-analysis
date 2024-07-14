#install & import packages("usmap")
pacman::p_load(usmap, maps) #import the package
library(ggplot2) #use ggplot2 to add layer for visualization

#GET SUMMARY STATS FOR MAIN DATA
library(dplyr)
library(gtsummary)

##MAIN DATA SUMMARY DIFF OF CASE AND DEATHS
main_data_summary <-merged_data %>%
  group_by(county) %>%
  summarize(
    min_date = min(date),
    max_date = max(date),
    cases_diff = cases[date == max_date] - cases[date == min_date],
    deaths_diff = deaths[date == max_date] - deaths[date == min_date],
    never = mean(never, na.rm = TRUE),
    rarely = mean(rarely, na.rm = TRUE),
    sometimes = mean(sometimes, na.rm = TRUE),
    frequently = mean(frequently, na.rm = TRUE),
    always = mean(always, na.rm = TRUE),
    population = first(population),
    fips = first(fips) 
  )
 
plot_usmap(regions = "counties", include= c("NC"), data = main_data_summary, values = "cases_diff", labels = FALSE) + 
  scale_fill_continuous(low = "light blue", high = "blue", name = "Covid Rates") +
  labs(title = "North Carolina",
       subtitle = "Difference in Covid Rates in North Carolina from July 2, 2020 to  July 14, 2020")
  theme(legend.position = "left")
  
  maps::map('county', region = 'north carolina', col = "#5E610B")
  title(main = "Covid Rates in North Carolina by Counties",
        cex.lab = 0.8)
    nc <- subset(map, region =="north carolina", data = main_data_summary, values = "cases_diff", labels = FALSE)
  
  data<- main_data_summary)
  nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"))
  ggplot(nc) +
    geom_sf(aes(fill = AREA))
  map <- main_data_s("county")

  