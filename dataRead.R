# Hallie Rutten, Monae Scott, Shelby Cline
# DataLab 2022, Sewanee Bat Study

#--PREP--######################################################################

# load libraries -----
library(tidyverse)
library(lubridate)
library(readxl)
library(scales)
library(plotly)
library(ggthemes)

#--BATS--######################################################################

# read bat acoustic data -----
bats <- readRDS('../bats.RData')

# calculate new vars -----
bats <- bats %>% 
  mutate(year = year(DATE), 
         monthN = month(DATE),
         month = month.abb[monthN],
         hour = hour(TIME),
         siteID = paste(COMPARTMENT,SITE, sep='_'),
         AUTO.ID = gsub("CORTOW", "CORRAF", AUTO.ID),
         AUTO.ID = ifelse(grepl('noID',AUTO.ID,ignore.case=TRUE),'no.ID',AUTO.ID) )
# Any bat listed as CORTOW should be listed as CORRAF (Amy text)

# cave status column -----
cave_obligate = c('PERSUB','MYOLEI','MYOAUS','MYOLUC','MYOSOD','MYOGRI','MYOSEP')
non_cave_obligate = c('LASBOR','NYCHUM','EPTFUS','LASNOC','LASCIN','CORRAF')
bats <- bats %>%
  mutate( obligate = ifelse(AUTO.ID %in% cave_obligate, TRUE, NA),
          obligate = ifelse(AUTO.ID %in% non_cave_obligate, FALSE, obligate) )

# species group column -----
EPTFUS.LASNOC = c("EPTFUS", "LASNOC")
LASBOR.NYCHUM = c("LASBOR", "NYCHUM")
bats <- bats %>% 
  mutate(species_group = ifelse(grepl("^MYO", AUTO.ID), "MYOTIS", AUTO.ID),
         species_group = ifelse(AUTO.ID %in% EPTFUS.LASNOC, "EPTFUS.LASNOC", species_group),
         species_group = ifelse(AUTO.ID %in% LASBOR.NYCHUM, "LASBOR.NYCHUM", species_group))



#--SENSORS--###################################################################

# read sensor site and date data -----
sensors <- read_csv('../sensorCSdates.csv', show_col_types=FALSE) 
sensors <- sensors %>% 
  mutate( siteID = gsub('-','_',siteID),
          LONGITUDE = -abs(LONGITUDE), 
          LATITUDE = abs(LATITUDE),
          habitat = toupper(habitat),
          habitat = gsub(" FOREST","",habitat),
          habitat = gsub("UNAMANAGED","UNMANAGED",habitat),
          habitat = gsub("UNAMANGED","UNMANAGED",habitat) )

# make each date one entry -----
sns <- sensors %>% select(-startDate,-endDate)
sensorDates <- data.frame()
for(i in 1:nrow(sensors) ){
  temp <- data.frame()
  if( is.na(sensors$endDate[i]) ){ sensors$endDate[i] <- as.Date(Sys.Date()) }
  DATE <- seq(sensors$startDate[i], sensors$endDate[i], by="days")
  temp <- data.frame(DATE)
  for(var in names(sns) ){
    temp[var] <- sns[i,which(names(sns)==var)]
  }
  sensorDates <- rbind(sensorDates,temp)
}

# clean environment -----
rm(sns,temp,DATE,i,var)



#--SPECIES--###################################################################

batspecies <- read_excel("../BatSpecies.xlsx")



#--WEATHER--###################################################################

# daily weather data -----
weather <- read_xlsx("../SUD Weather Station.xlsx") %>%
  dplyr::rename(DATE = "Timestamp*",
                AvgTemp='Air temp Avg (C)',
                Highest_Temp_Time='Time Air Temp Max',
                MaxTemp='Air Temp Max (C)',
                MinTemp='Air Temp Min',
                MaxWind='Wind Speed Max (low) (m/s)',
                AvgWind='Wind Speed Avg (high) (m/S)',
                MinWind='Wind Speed Min (low) (m/s)')

# hourly weather data -----
hourly <- read_xlsx("../SUD Weather Station.xlsx", sheet=2) %>% 
  mutate( DATE=date(Timestamp),
          monthN=month(Timestamp),
          month = month.abb[monthN],
          year=year(Timestamp) )

# recorded rain data -----
rain <- read_xlsx("../SUD Weather Station.xlsx", sheet = 3)



#--MANAGEMENT--################################################################

# waiting on Amy's data



#--JOINS--#####################################################################

# join bats and sensor site data -----
bats <- left_join(bats,sensorDates, by=c('siteID','DATE'))

# join bats and species names data -----
bats<- left_join(bats,batspecies, by="AUTO.ID")

# weather? -----

# join bats and management data -----
