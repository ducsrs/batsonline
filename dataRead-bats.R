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
         AUTO.ID = gsub("CORTOW", "CORRAF", AUTO.ID),
         AUTO.ID = ifelse(grepl('noID',AUTO.ID,ignore.case=TRUE),'no.ID',AUTO.ID) )
# Any bat listed as CORTOW should be listed as CORRAF (Amy text)

# cave status column -----
cave_obligate = c('MYOLEI','MYOAUS','MYOLUC','MYOSOD','MYOGRI','MYOSEP')
seasonal_cave_obligate = c('PERSUB',"EPTFUS", "CORRAF")
non_cave_obligate = c('LASBOR','NYCHUM','LASNOC','LASCIN')
bats <- bats %>%
  mutate( obligate = ifelse(AUTO.ID %in% cave_obligate, "cave obligate", AUTO.ID),
          obligate = ifelse(AUTO.ID %in% non_cave_obligate, "not cave obligate", obligate),
          obligate = ifelse(AUTO.ID %in% seasonal_cave_obligate, "seasonal cave obligate", obligate))

# species group column -----
EPTFUS.LASNOC = c("EPTFUS", "LASNOC")
LASBOR.NYCHUM = c("LASBOR", "NYCHUM")
bats <- bats %>% 
  mutate(ID_group = ifelse(grepl("^MYO", AUTO.ID), "MYOTIS", AUTO.ID),
         ID_group = ifelse(AUTO.ID %in% EPTFUS.LASNOC, "EPTFUS.LASNOC", ID_group),
         ID_group = ifelse(AUTO.ID %in% LASBOR.NYCHUM, "LASBOR.NYCHUM", ID_group))
