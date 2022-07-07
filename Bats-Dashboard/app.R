# Sewanee Bat Study
# Hallie Rutten, Monae Scott, Shelby Cline

# More about building applications with Shiny at
# http://shiny.rstudio.com/

# More about building applications with Shiny Dashboard at
# https://rstudio.github.io/shinydashboard/index.html

#--PREP--######################################################################

library(shiny)
library(shinydashboard)

library(tidyverse)
library(readxl)
library(lubridate)
library(ggthemes)

#--UI--########################################################################
ui <- dashboardPage(
  skin="purple",
  
  #--header--==================================================================
  dashboardHeader(
    
    title="Sewanee Bat Study"
    
  ),#--end header--#
  
  #--sidebar--=================================================================
  dashboardSidebar(
    
    sidebarMenu(
      
      # menu tabs -----
      menuItem( text="About",             tabName="about",     icon=icon("home") ),
      menuItem( text="Long-Term Trends",  tabName="yearly",    icon=icon("calendar") ),
      menuItem( text="Seasonal Trends",   tabName="monthly",   icon=icon("snowflake") ),
      menuItem( text="Circadian Trends",  tabName="hourly",    icon=icon("clock") ),
      menuItem( text="Spatial Trends",    tabName="site",      icon=icon("map") ),
      menuItem( text="Diversity Trends",  tabName="diversity", icon=icon("pie-chart") ),
      menuItem( text="Sampling Activity", tabName="sensor",    icon=icon("gear") ),
      
      # grouping -----
      uiOutput("grouping.UI"),
      
      # year filter ----
      selectInput(inputId = "year", 
                  label = "Select year(s):", 
                  choices = c(2017:2022),
                  multiple = TRUE 
      ),#end year multiple select
      
      # month filter -----
      selectInput(inputId = "month", 
                  label = "Select month(s):", 
                  choices = month.abb[1:12],
                  multiple = TRUE 
      ),#end month multiple select
      
      # compartment filter
      selectInput(inputId = "compartment", 
                  label = "Select compartment(s):", 
                  choices = c(1:16),
                  multiple = TRUE 
      )#end compartment multiple select
      
    )#end sidebar menu
    
  ),#--end sidebar--#
  
  #--body--====================================================================
  dashboardBody(
    
    # tabs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    tabItems(
      
      # About tab -----
      tabItem(tabName="about",
              
              # row 1
              fluidRow(
                
                box( title="About Page", width=12,
                     solidHeader=TRUE, collapsible=TRUE, status='primary',
                     h1("Welcome!"), 
                     "Bats are a vital part of ecosystems and have been on the 
                     decline due to one of the worst wildlife diseases in modern 
                     history, white nose syndrome. Sewanee Bat Study has collected 
                     years of data on the behavior and habitats of local 
                     cave-dwelling bat species. We are analyzing the data and 
                     creating a dashboard to help make better data-driven forest 
                     management decisions that will help control the spread of 
                     white nose syndrome.",
                     hr(),
                     h2('Bats of Sewanee:'),
                     "[summarize bat species]",
                     hr(),
                     h3('Long-Term Trends'),
                     "[Explain Long-Term tab]",
                     hr(),
                     h3('Seasonal Trends'),
                     "[Explain Seasonal tab]",
                     hr(),
                     h3('Circadian Trends'),
                     "[Explain Circadian tab]",
                     hr(),
                     h3('Spatial Trends'),
                     "[Explain Spatial tab]",
                     hr(),
                     h3('Diversity Trends'),
                     "[Explain Diversity tab]",
                     hr(),
                     h3('Sampling Activity'),
                     "[Explain Sampling tab]",
                ),#end about box
                
              ),#end row 1
              
      ),#end About ---
      
      # Long-Term (yearly) trends tab -----
      tabItem(tabName="yearly",
              
              # yearly row 1
              fluidRow(
                
                box( title="Long-Term Trends", width=9, 
                     solidHeader=TRUE, status='info',
                     plotOutput("yearly.plot") ),
                
                column( width=3,
                        box( title="Graph Controls", width=NULL,
                             solidHeader=TRUE, collapsible=TRUE ),
                        box( title="Aesthetic Controls", width=NULL,
                             solidHeader=TRUE, collapsible=TRUE )
                )#end controls column
                
              ),#end yearly row 1
              
      ),#end Long-Term ---
      
      # Seasonal (monthly) trends tab -----
      tabItem(tabName="monthly",
              
              # monthly row 1
              fluidRow(
                
                box( title="Seasonal Trends", width=9,
                     solidHeader=TRUE, status='info',
                     plotOutput("monthly.plot") ),
                
                column( width=3,
                        box( title="Graph Controls", width=NULL,
                             solidHeader=TRUE, collapsible=TRUE ),
                        box( title="Aesthetic Controls", width=NULL,
                             solidHeader=TRUE, collapsible=TRUE )
                )#end controls column
                
              ),#end monthly row 1
              
      ),#end Seasonal ---
      
      # Circadian (hourly) trends tab -----
      tabItem(tabName="hourly",
              
              # hourly row 1
              fluidRow(
                
                box( title="Circadian Trends", width=9,
                     solidHeader=TRUE, status='info',
                     plotOutput("hourly.plot") ),
                
                column( width=3,
                        box( title="Graph Controls", width=NULL,
                             solidHeader=TRUE, collapsible=TRUE ),
                        box( title="Aesthetic Controls", width=NULL,
                             solidHeader=TRUE, collapsible=TRUE )
                )#end controls column
                
              ),#end hourly row 1
              
      ),#end Circadian ---
      
      # Spatial (site) trends tab -----
      tabItem(tabName="site",
              
              # sites row 1
              fluidRow(
                
                box( title="Spatial Trends", width=9,
                     solidHeader=TRUE, status='info',
                     plotOutput("site.plot") ),
                
                column( width=3,
                        box( title="Graph Controls", width=NULL,
                             solidHeader=TRUE, collapsible=TRUE ),
                        box( title="Aesthetic Controls", width=NULL,
                             solidHeader=TRUE, collapsible=TRUE )
                )#end controls column
                
              ),#end sites row 1
              
      ),#end Spatial ---
      
      # Diversity (species) trends tab -----
      tabItem(tabName="diversity",
              
              # diversity row 1
              fluidRow(
                
                box( title="Diversity Trends", width=9,
                     solidHeader=TRUE, status='info',
                     plotOutput("diversity.plot") ),
                
                column( width=3,
                        box( title="Graph Controls", width=NULL,
                             solidHeader=TRUE, collapsible=TRUE ),
                        box( title="Aesthetic Controls", width=NULL,
                             solidHeader=TRUE, collapsible=TRUE )
                )#end controls column
                
              ),#end diversity row 1
              
      ),#end Diversity ---
      
      # Sampling Activity tab -----
      tabItem(tabName="sensor",
              
              # sampling row 1
              fluidRow(
                
                box( title="Sampling Activity", width=9,
                     solidHeader=TRUE, status='info',
                     plotOutput("sensor.plot") ),
                
                column( width=3,
                        box( title="Graph Controls", width=NULL,
                             solidHeader=TRUE, collapsible=TRUE ),
                        box( title="Aesthetic Controls", width=NULL,
                             solidHeader=TRUE, collapsible=TRUE )
                )#end controls column
                
              ),#end sampling row 1
              
      )#end Sampling ---
      
    )#end tabs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
  )#--end body--#
  
)#end UI

#--SERVER--####################################################################
server <- function(input, output) { 
  
  # dynamic inputs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  output$grouping.UI <- renderUI({
    radioButtons(inputId="grouping", label="Display trends by:",
                 choices = c('species', 'species group', 'cave dependency'), 
                 selected = 'species')
  })#end grouping UI
  
  # end inputs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  # plots ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  # Long-Term (yearly) plot -----
  output$yearly.plot <- renderPlot({
    ggplot() +
      labs(title="Long-Term Bat Activity",
           x="Year", y="Relative Frequency",
           caption="Sewanee Bat Study, DataLab 2022")
  })#end long-term plot ---
  
  # Seasonal (monthly) plot -----
  output$monthly.plot <- renderPlot({
    ggplot() +
      labs(title="Seasonal Bat Activity",
           x="Month", y="Relative Frequency",
           caption="Sewanee Bat Study, DataLab 2022")
  })#end seasonal plot ---
  
  # Circadian (hourly) plot -----
  output$hourly.plot <- renderPlot({
    ggplot() +
      labs(title="Circadian Bat Activity",
           x="Hour", y="Relative Frequency",
           caption="Sewanee Bat Study, DataLab 2022")
  })#end circadian plot ---
  
  # Spatial (site) plot -----
  output$site.plot <- renderPlot({
    ggplot() +
      labs(title="Spatial Bat Activity",
           x="Compartment", y="Relative Frequency",
           caption="Sewanee Bat Study, DataLab 2022")
  })#end spatial plot ---
  
  # Diversity (species) plot -----
  output$diversity.plot <- renderPlot({
    ggplot() +
      labs(title="Bat Species Trends",
           x="year/month", y="Proportion",
           caption="Sewanee Bat Study, DataLab 2022")
  })#end diversity plot ---
  
  # Sampling Activity plot -----
  output$sensor.plot <- renderPlot({
    ggplot() +
      labs(title="Sampling Activity",
           x="Sensor", y="Accuracy",
           caption="Sewanee Bat Study, DataLab 2022")
  })#end sampling plot ---
  
  # end plots ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
}#end server

#--RUN--#######################################################################
shinyApp(ui, server)
