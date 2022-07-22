# weather read 
# Hallie Rutten, Shelby Cline, Monae Scott

# load libraries -----
library(readxl)

#read in daily weather data -----
weather <- read_xlsx("../SUD Weather Station.xlsx") %>%
  dplyr::rename("Date" = "Timestamp*",
                AvgTemp='Air temp Avg (C)',
                Highest_Temp_Time='Time Air Temp Max',
                MaxTemp='Air Temp Max (C)',
                MinTemp='Air Temp Min',
                MaxWind='Wind Speed Max (low) (m/s)',
                AvgWind='Wind Speed Avg (high) (m/S)',
                MinWind='Wind Speed Min (low) (m/s)' )

#read in hourly weather data -----
hourly <- read_xlsx("../SUD Weather Station.xlsx", sheet=2) %>% 
  mutate( Date=date(Timestamp) )

#read in recorded rain data -----
rain <- read_xlsx("../SUD Weather Station.xlsx", sheet = 3)