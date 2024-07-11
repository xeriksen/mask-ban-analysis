#IMPORT NYTIMES DATA - MASK USE BY COUNTY
nyt_mask_use_by_county <- import("~/Desktop/ENABLE/ENABLE mask ban analysis/ENABLE-mask-ban-/Data/nyt- covid-19-data-master/mask-use/mask-use-by-county.csv")

#FILTER NC FROM NYTIMES DATA - MASK USE BY COUNTY
nyt_mask_use_by_nc_county <- nyt_mask_use_by_county %>%
  filter(COUNTYFP >= 37000 & COUNTYFP < 38000)

#RENAME COLUMN COUNTFP TO FIPS IN NYT MASK USE BY NC COUNTY 
nyt_mask_use_by_nc_county_fips <- nyt_mask_use_by_nc_county%>%
  rename(fips= COUNTYFP)

#CLEAN NAMES NYT MASK USE BY NC COUNTY
mask_use_study <- nyt_mask_use_by_nc_county_fips %>%
    janitor::clean_names()

