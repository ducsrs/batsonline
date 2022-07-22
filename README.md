# Protecting the Bat Population
Com-BAT-ing Ecological Challenges

The Sewanee Bat Study has collected years of data on the behavior and habitats of local forest-dwelling bat species. We are analyzing the data and creating 
a dashboard to help make data-driven forest management decisions.  Dr. Turner has invited us to help organize the data to monitor trends in bats over time,
ask which forest management practices are best for bats, and allocate resources accordingly. We decided that an interactive dashboard would be the best way 
to display such a rich dataset, as this allows Dr. Turner and her team to manipulate graphs as they wish to paint a picture of crucial management areas, 
species proportions, and much more. 

## About Tab
The opening page of our dashboard showcases a small paragraph that gives context to our dashboards purpose. There's a list of key definitions that help the 
user understand certain technical terms used in our graphs. Also included is a list of bats found in Sewanee with their associated species code, an 
explanation of the land management practices, links to further research conducted by other organizations, and a section for introducing our team. On the 
right-most side of our dashboard is a list of the sections we have available to explore on the dashboard with a small description so it's easier to 
navigate.

## Long-term Trends
This tab will display an overview of bat activity trends across all recorded years, with the option to compare across forest management types. Also 
available are optional weather overlays tracking average wind, rain, and temperature in each year.

## Seasonal Trends
This tab will display bat activity trends by month of the year, with the option to compare across years or forest management types. Also available are 
optional weather overlays tracking the average wind, rain, and temperature in each month.

## Circadian Trends
This tab will display bat activity trends by hour of the day on a 24-hour cycle, with the option to compare across months, years, or forest management 
types.

## Spatial Trends 
This tab will display the annual bat activity in any given geographical compartment, with the option to compare across sampling sites.

## Diversity Trends
This tab will display the proportion of bat activity accounted for by each species in each year, with the option to compare across forest management types.

## Sampling Activity
This tab will display a graph of sampling activity over time, as well as the proportions of noise and unidentifiable bat calls for each sensor and 
microphone.

## To Run the Code:
First, the you will need to ensure... 
- you have R (available free at https://cran.r-project.org/) 
- you have RStudio (available free at https://www.rstudio.com/products/rstudio/download/)

Then, before running, make sure...
- you have a main folder that contains two subfolders; 'Data' and 'Code'
- the subfolder called 'Data' holds all the data files, sorted into a folder tree containing paths of the following format: 
- /Compartment #/C#_S#/... , 
  where the first subfolder stands for compartment number, 
  and the second subfolder stands for site ID composed of compartment number and site number separated by an underscore
- the subfolder called 'Code' holds all the code files from this repository, such as the data read, the exploratory markdowns, and the dashboard
- you set your RStudio session working directory to the 'Code' folder (top of the RStudio interface: Session > Set Working Directory > Choose Directory) 
