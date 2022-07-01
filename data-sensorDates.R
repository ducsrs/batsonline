# libraries -----
library(readr)

# read sensor site and date data -----
sensors <- read_csv('sensorCSdates.csv', show_col_types=FALSE) 
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
