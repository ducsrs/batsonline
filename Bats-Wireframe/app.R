# Find out more about building applications with Shiny here: http://shiny.rstudio.com/

#--Prep--#======================================================================

library(shiny)
library(tidyverse)
library(lubridate)
library(DT)

bats <- readRDS('../bats.RData')

bats <- bats %>% 
  mutate(year = year(DATE), 
         monthN = month(DATE),
         month = month.abb[monthN],
         hour = hour(TIME) )

# Any bat listed as CORROW should be listed as the secondary species
bats <- bats %>% 
  mutate( AUTO.ID = gsub("CORTOW", 
                         unlist(strsplit(ALTERNATES, split=';', fixed=TRUE))[1],
                         AUTO.ID) )

# Range slider -----
#sliderInput("variable", label = h3("label"), 
#            min=min, max=max, 
#            value = c(start, end) 
#            )#end slider input

# Check multiple list -----
#checkboxGroupInput(inputId = "compartment", 
#                   label = "Select compartments:", 
#                   choices = sort(unique(bats$COMPARTMENT)) 
#),#end compartment check boxes

# Drop down menu -----
#selectInput("variable", label = h3("label"), 
#            choices = list("Choice 1" = 1, "Choice 2" = 2, "Choice 3" = 3), 
#            selected = 1)
#selectInput(inputId = "country", 
#            label = "Select country:", 
#            choices = unique(gm$country),
#            selected = unique(gm$country)[1],
#            multiple = TRUE )

#date range -----
#dateRangeInput("variable", label = h3("lable"),
#               min='yyyy-mm-dd', max='yyyy-mm-dd')

#--UI--#========================================================================

ui <- fluidPage(
  
  # Application title
  titlePanel("Protecting the Bat Population"),
  
  # Sidebar - inputs and main
  sidebarLayout(
    
    # Sidebar inputs
    sidebarPanel(
      
      # species -----
      selectInput(inputId = "species", 
                  label = "Select species:", 
                  choices = sort(unique(bats$AUTO.ID)),
                  multiple = TRUE 
      ),#end species multiple select
      
      # species group -----
      #checkboxGroupInput(inputId = "speciesGroup", 
      #                   label = "Select species group:", 
      #                   choices = sort(unique(bats$AUTO.ID)) 
      #),#end species group check boxes
      
      # year -----
      #sliderInput(inputId = "yearRange", 
      #            label = "Select year range:", 
      #            min=min(bats$year), max=max(bats$year), 
      #            value = c(min(bats$year), max(bats$year)) 
      #),#end year slider input
      selectInput(inputId = "years", 
                  label = "Select year(s):", 
                  choices = sort(unique(bats$year)),
                  multiple = TRUE 
      ),#end year multiple select
      
      # month -----
      selectInput(inputId = "month", 
                  label = "Select month(s):", 
                  choices = month.abb[1:12],
                  multiple = TRUE 
      ),#end month multiple select
      
      # date range -----
      dateRangeInput("dateRange", 
                     label = "Choose a date range:",
                     start=min(bats$DATE), end=max(bats$DATE),
                     min=min(bats$DATE), max=max(bats$DATE)
      ),#end date range selection
      
      # compartment -----
      selectInput(inputId = "compartment2", 
                  label = "Select compartment(s):", 
                  choices = sort(unique(bats$COMPARTMENT)),
                  multiple = TRUE 
      ),#end compartment multiple select
      
      # season -----
      checkboxGroupInput(inputId = "season", 
                         label = "Select season(s):", 
                         choices = c('Spring','Summer','Fall','Winter')
      ),#end season check boxes
      
    ),#end sidebar inputs
    
    # main panel
    mainPanel(
      # tabs
      tabsetPanel(
        
        # About: the intro tab -----
        tabPanel( h4('About'),
                  fluidRow(h1("Welcome!"), 
                           hr(),
                           br(),
                           "Bats are a vital part of ecosystems and have been on the decline due to one of the worst wildlife diseases in modern history, white nose syndrome. Sewanee Bat Study has collected years of data on the behavior and habitats of local cave-dwelling bat species. We are analyzing the data and creating a dashboard to help make better data-driven forest management decisions that will help control the spread of white nose syndrome."),
                  fluidRow(h2('Long-Term Trends'),
                           hr(),
                           br(),
                           "Any trend that can be found across all years available in our dataset can be found here! IDK this needs work"),
                  fluidRow(h2('Seasonal Trends'))),
        
        
        # Long-Term: trends by year tab -----
        tabPanel( h4('Long-Term Trends'),
                  plotOutput('yearly') ),
        
        # Seasonal: trends by month tab -----
        tabPanel( h4('Seasonal Trends'),
                  plotOutput('monthly') ),
        
        # Circadian: trends by hour tab -----
        tabPanel( h4('Circadian Trends'),
                  plotOutput('hourly') ),
        
        # Spatial: trends by compartment tab -----
        tabPanel( h4('Spatial Trends'),
                  plotOutput('compartment') ),
        
        # Climate: trends by weather tab -----
        tabPanel( h4('Climate Trends'),
                  plotOutput('climate') ),
        
        # Diversity: trends by species tab -----
        tabPanel( h4('Diversity Trends'),
                  plotOutput('diversity') ),
        
        # raw data tab -----
        tabPanel( h4('Raw Data'),
                  DT::dataTableOutput('table') )
        
      ),#end tabs
    )#end main panel
    
  )#end sidebar
  
)#end UI

#--Server--#====================================================================

server <- function(input, output) {
  
  # About: the into -----
  output$about <- renderPlot({
    
  })#end intro
  
  # reactive data subset -----
  rv <- reactiveValues()
  observe({
    rv$bats.sub <- bats %>% 
      filter(AUTO.ID %in% input$species,
             DATE >= input$dateRange[1],
             DATE <= input$dateRange[2])
  })
  
  # Long-Term: yearly trends -----
  output$yearly <- renderPlot({
    
    print(nrow(rv$bats.sub))
    print(head(rv$bats.sub))
    
    ggplot(data = rv$bats.sub %>% 
             mutate(year.week = paste(year(DATE), ".", week(DATE))) %>% 
             group_by(AUTO.ID, year.week) %>% 
             summarize(n = length(DATE), 
                       dt = DATE[1]) 
    )+
      geom_line(aes(x = dt,
                    y = n,
                    color = AUTO.ID))+
      labs(title = 'MYOTIS Species Over Time',
           x = 'Time',
           y = 'Number of Recordings')
  })#end yearly trends
  
  # Seasonal: monthly trends -----
  output$monthly <- renderPlot({
    ggplot( rv$bats.sub ) +
      labs(title="Seasonal Bat Activity Trends",
           subtitle="By month",
           caption="DataLab 2022")
  })#end monthly trends
  
  # Circadian: hourly trends -----
  output$hourly <- renderPlot({
    ggplot( rv$bats.sub ) +
      labs(title="Circadian Bat Activity Trends",
           subtitle="By hour",
           caption="DataLab 2022")
  })#end hourly trends
  
  # Spatial: compartment/site trends -----
  output$compartment <- renderPlot({
    # leaflet?
    ggplot( rv$bats.sub ) +
      labs(title="Spatial Bat Activity Trends",
           subtitle="By compartment",
           caption="DataLab 2022")
  })#end compartment trends/map
  
  # Climate: weather trends -----
  output$climate <- renderPlot({
    ggplot( rv$bats.sub ) +
      labs(title="Bat Activity Trends",
           subtitle="By temperature/weather",
           caption="DataLab 2022")
  })#end weather trends
  
  # Diversity: yearly trends -----
  output$diversity <- renderPlot({
    ggplot( rv$bats.sub ) +
      labs(title="Bat Activity Trends",
           subtitle="By species",
           caption="DataLab 2022")
  })#end yearly trends
  
  # raw data -----
  output$table <- DT::renderDataTable( rv$bats.sub )
  
}#end server

#--Run--#=======================================================================

shinyApp(ui = ui, server = server)