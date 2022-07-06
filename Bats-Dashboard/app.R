# Sewanee Bat Study
# Hallie Rutten, Monae Scott, Shelby Cline

# More about building applications with Shiny at
# http://shiny.rstudio.com/

# More about building applications with Shiny Dashboard at
# https://rstudio.github.io/shinydashboard/index.html

#--PREP--######################################################################

library(shiny)
library(shinydashboard)

#--UI--########################################################################
ui <- dashboardPage(
  
  #--header--==================================================================
  dashboardHeader(
    title="Sewanee Bat Study"
  ),#--end header--#
  
  #--sidebar--=================================================================
  dashboardSidebar(
    
    sidebarMenu(
      menuItem( text="About", tabName="about", icon=icon("th") ),
      menuItem( text="Long-Term Trends",  tabName = "yearly",    icon=icon("th") ),
      menuItem( text="Seasonal Trends",   tabName = "monthly",   icon=icon("th") ),
      menuItem( text="Circadian Trends",  tabName = "hourly",    icon=icon("th") ),
      menuItem( text="Spatial Trends",    tabName = "site",      icon=icon("th") ),
      menuItem( text="Diversity Trends",  tabName = "diversity", icon=icon("th") ),
      menuItem( text="Sampling Activity", tabName = "sensor",    icon=icon("th") )
    )
    
  ),#--end sidebar--#
  
  #--body--====================================================================
  dashboardBody(
    
    # tabs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    tabItems(
      
      # About tab -----
      tabItem(tabName="about",
              
              # row 1
              fluidRow(
                
                box( title="About Page" )
                
              ),#end row 1
              
      ),#end About ---
      
      # Long-Term (yearly) trends tab -----
      tabItem(tabName="yearly",
              
              # row 1
              fluidRow(
                
                box( plotOutput("yearly.plot") ),
                
                box( title="Custom Controls" )
                
              ),#end row 1
              
      ),#end Long-Term ---
      
      # Seasonal (monthly) trends tab -----
      tabItem(tabName="monthly",
              
              # row 1
              fluidRow(
                
                box( plotOutput("monthly.plot") ),
                
                box( title="Custom Controls" )
                
              ),#end row 1
              
      ),#end Seasonal ---
      
      # Circadian (hourly) trends tab -----
      tabItem(tabName="hourly",
              
              # row 1
              fluidRow(
                
                box( plotOutput("hourly.plot") ),
                
                box( title="Custom Controls" )
                
              ),#end row 1
              
      ),#end Circadian ---
      
      # Spatial (site) trends tab -----
      tabItem(tabName="site",
              
              # row 1
              fluidRow(
                
                box( plotOutput("site.plot") ),
                
                box( title="Custom Controls" )
                
              ),#end row 1
              
      ),#end Spatial ---
      
      # Diversity (species) trends tab -----
      tabItem(tabName="diversity",
              
              # row 1
              fluidRow(
                
                box( plotOutput("diversity.plot") ),
                
                box( title="Custom Controls" )
                
              ),#end row 1
              
      ),#end Diversity ---
      
      # Sampling Activity tab -----
      tabItem(tabName="sensor",
              
              # row 1
              fluidRow(
                
                box( plotOutput("sensor.plot") ),
                
                box( title="Custom Controls" )
                
              ),#end row 1
              
      )#end Sampling ---
      
    )#end tabs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
  )#--end body--#
  
)#end UI

#--SERVER--####################################################################
server <- function(input, output) { 
  
  # Long-Term (yearly) plot -----
  output$yearly.plot <- renderPlot({
    ggplot()
  })#end long-term plot ---
  
  # Seasonal (monthly) plot -----
  output$monthly.plot <- renderPlot({
    ggplot()
  })#end seasonal plot ---
  
  # Circadian (hourly) plot -----
  output$hourly.plot <- renderPlot({
    ggplot()
  })#end circadian plot ---
  
  # Spatial (site) plot -----
  output$site.plot <- renderPlot({
    ggplot()
  })#end spatial plot ---
  
  # Diversity (species) plot -----
  output$diversity.plot <- renderPlot({
    ggplot()
  })#end diversity plot ---
  
  # Sampling Activity plot -----
  output$sensor.plot <- renderPlot({
    ggplot()
  })#end sampling plot ---
  
}#end server

#--RUN--#######################################################################
shinyApp(ui, server)
