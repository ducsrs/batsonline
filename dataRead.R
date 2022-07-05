# basic bat data read -----

library(tidyverse)
library(lubridate)
library(readxl)
library(scales)
library(plotly)
library(ggthemes)

bats <- readRDS('bats.RData')

bats <- bats %>% 
  mutate(year = year(DATE), 
         monthN = month(DATE),
         month = month.abb[monthN],
         hour = hour(TIME),
         sensor = paste(COMPARTMENT,SITE, sep='_') )

# Any bat listed as CORROW should be listed as the secondary species (document)
# Any bat listed as CORTOW should be listed as CORRAF (Amy text)
bats <- bats %>% 
  mutate( AUTO.ID = gsub("CORTOW", "CORRAF", AUTO.ID) )
