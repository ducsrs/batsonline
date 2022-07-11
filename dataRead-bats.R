# Hallie Rutten, Monae Scott, Shelby Cline
# DataLab 2022, Sewanee Bat Study

# load libraries -----
library(tidyverse)
library(lubridate)
library(readxl)
library(scales)
library(plotly)
library(ggthemes)

# read bat acoustic data -----
bats <- readRDS('bats.RData')

# calculate new vars -----
bats <- bats %>% 
  mutate(year = year(DATE), 
         monthN = month(DATE),
         month = month.abb[monthN],
         hour = hour(TIME),
         sensor = paste(COMPARTMENT,SITE, sep='_'),
         AUTO.ID = gsub("CORTOW", "CORRAF", AUTO.ID))
# Any bat listed as CORTOW should be listed as CORRAF (Amy text)