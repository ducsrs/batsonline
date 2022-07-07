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
      #uiOutput("grouping.UI"),
      radioButtons(inputId="grouping", label="Display trends by:",
                   choices = c('species', 'species group', 'cave dependency'), 
                   selected = 'species'
      ),#end grouping UI
      
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
      )#end month multiple select
      
      # compartment filter -----
      #selectInput(inputId = "compartment", 
      #            label = "Select compartment(s):", 
      #            choices = c(1:16),
      #            multiple = TRUE 
      #)#end compartment multiple select
      
    )#end sidebar menu
    
  ),#--end sidebar--#
  
  #--body--====================================================================
  dashboardBody(
    
    # tabs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    tabItems(
      
      # About tab -----
      tabItem(tabName="about",
              
              fluidRow(
                column(width=9, h1("Introduction") ),
                column(width=3, h1("Tab Summaries") )
              ),#end titles row
              
              # about tab row 2
              fluidRow(
                
                box( title="About the Sewanee Bat Study", width=9,
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
                
                # tab summaries column
                column(width=3,
                       
                       box( title="Long-Term Trends", width=NULL,
                            solidHeader=TRUE, status='primary',
                            collapsible=TRUE, collapsed=TRUE,
                            "[Explain Long-Term tab]"
                       ),#end long-term summary
                       
                       box( title="Seasonal Trends", width=NULL,
                            solidHeader=TRUE, status='primary',
                            collapsible=TRUE, collapsed=TRUE,
                            "[Explain Seasonal tab]"
                       ),#end seasonal summary
                       
                       box( title="Circadian Trends", width=NULL,
                            solidHeader=TRUE, status='primary',
                            collapsible=TRUE, collapsed=TRUE,
                            "[Explain Circadian tab]"
                       ),#end circadian summary
                       
                       box( title="Spatial Trends", width=NULL,
                            solidHeader=TRUE, status='primary',
                            collapsible=TRUE, collapsed=TRUE,
                            "[Explain Spatial tab]"
                       ),#end spatial summary
                       
                       box( title="Diversity Trends", width=NULL,
                            solidHeader=TRUE, status='primary',
                            collapsible=TRUE, collapsed=TRUE,
                            "[Explain Diversity tab]"
                       ),#end diversity summary
                       
                       box( title="Sampling Activity", width=NULL,
                            solidHeader=TRUE, status='primary',
                            collapsible=TRUE, collapsed=TRUE,
                            "[Explain Sampling tab]"
                       )#end sampling summary
                       
                )#end tabs column
                
              )#end about tab row 2
              
      ),#end About ---
      
      # Long-Term (yearly) trends tab -----
      tabItem(tabName="yearly",
              
              # yearly row 1
              fluidRow(
                
                box( title="Long-Term Trends", width=9, 
                     solidHeader=TRUE, status='info',
                     plotOutput("yearly.plot") ),
                
                # controls column
                column( width=3,
                        
                        # graph controls box
                        box( title="Graph Controls", width=NULL,
                             status='primary', collapsible=TRUE, 
                             uiOutput("yearly.group.UI"),
                             
                             checkboxGroupInput(inputId="yearly.weather",
                                                label="Weather display:",
                                                choices=c('rain','temperature','wind')
                             ),#end weather check boxes
                             
                             radioButtons(inputId="yearly.wrapVar", 
                                          label="Wrap facets by:",
                                          choices = c('none','management'), 
                                          selected = 'none'
                             )#end wrap var selection
                             
                        ),#end graph controls box
                        
                        box( title="Aesthetic Controls", width=NULL,
                             status='primary', collapsible=TRUE )
                        
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
                        
                        # graph controls box
                        box( title="Graph Controls", width=NULL,
                             status='primary', collapsible=TRUE, 
                             
                             checkboxGroupInput(inputId="monthly.weather",
                                                label="Weather display:",
                                                choices=c('rain','temperature','wind')
                             ),#end weather check boxes
                             
                             radioButtons(inputId="monthly.wrapVar", 
                                          label="Wrap facets by:",
                                          choices = c('none','year','management'), 
                                          selected = 'none'
                             )#end wrap var selection
                             
                        ),#end graph controls box
                        
                        box( title="Aesthetic Controls", width=NULL,
                             status='primary', collapsible=TRUE )
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
                
                # controls column
                column( width=3,
                        
                        # graph controls box
                        box( title="Graph Controls", width=NULL,
                             status='primary', collapsible=TRUE, 
                             
                             #checkboxGroupInput(inputId="hourly.weather",
                             #                   label="Weather display:",
                             #                   choices=c('rain','temperature','wind')
                             #),#end weather check boxes
                             
                             radioButtons(inputId="hourly.wrapVar", 
                                          label="Wrap facets by:",
                                          choices = c('none','year','month','management'), 
                                          selected = 'none'
                             )#end wrap var selection
                             
                        ),#end graph controls box
                        
                        box( title="Aesthetic Controls", width=NULL,
                             status='primary', collapsible=TRUE )
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
                
                # controls column
                column( width=3,
                        
                        # graph controls box
                        box( title="Graph Controls", width=NULL,
                             status='primary', collapsible=TRUE, 
                             
                             radioButtons(inputId="site.display", 
                                          label="Display style:",
                                          choices = c('facet','multiple'), 
                                          selected = 'facet'
                             )#end wrap var selection
                             
                        ),#end graph controls box
                        
                        box( title="Aesthetic Controls", width=NULL,
                             status='primary', collapsible=TRUE )
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
                
                # controls column
                column( width=3,
                        
                        # graph controls box
                        box( title="Graph Controls", width=NULL,
                             status='primary', collapsible=TRUE, 
                             
                             radioButtons(inputId="diversity.wrapVar", 
                                          label="Wrap facets by:",
                                          choices = c('none','management'), 
                                          selected = 'none'
                             )#end wrap var selection
                             
                        ),#end graph controls box
                        
                        box( title="Aesthetic Controls", width=NULL,
                             status='primary', collapsible=TRUE )
                )#end controls column
                
              ),#end diversity row 1
              
      ),#end Diversity ---
      
      # Sampling Activity tab -----
      tabItem(tabName="sensor",
              
              # sampling row 
              fluidRow(
                
                box( title="Sampling Activity", width=9,
                     solidHeader=TRUE, status='primary',
                     plotOutput("sampling.plot") ),
                
                column( width=3,
                        
                        # graph controls box
                        box( title="Graph Controls", width=NULL,
                             status='info', collapsible=TRUE, 
                             
                             radioButtons(inputId="sampling.granularity", 
                                          label="Granularity:",
                                          choices = c('year','month','day'), 
                                          selected = 'year'
                             )#end wrap var selection
                             
                        ),#end graph controls box
                        
                        # aesthetic controls
                        box( title="Aesthetic Controls", width=NULL,
                             status='info', collapsible=TRUE,
                             
                             radioButtons(inputId="sampling.style", 
                                          label="Plot style:",
                                          choices = c('line','points'), 
                                          selected = 'line'
                             )#end wrap var selection
                             
                        )#end aesthetic controls
                        
                )#end controls column
                
              ),#end sampling row 
              
              # accuracy row
              fluidRow(
                
                box( title="Sensor Accuracy", width=9,
                     solidHeader=TRUE, status='primary',
                     plotOutput("sensor.plot") ),
                
                # controls column
                column( width=3,
                        
                        # graph controls box
                        box( title="Graph Controls", width=NULL,
                             status='info', collapsible=TRUE, 
                             
                             radioButtons(inputId="sensor.ob", 
                                          label="Focus:",
                                          choices = c('Noise','No.ID'), 
                                          selected = 'Noise'
                             )#end wrap var selection
                             
                        ),#end graph controls box
                        
                        # aesthetic controls
                        box( title="Aesthetic Controls", width=NULL,
                             status='info', collapsible=TRUE
                        )#end aesthetic controls
                        
                )#end controls column
                
              )# end accuracy row
              
      )#end Sampling ---
      
    )#end tabs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
  )#--end body--#
  
)#end UI

#--SERVER--####################################################################
server <- function(input, output) { 
  
  # dynamic inputs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  # grouping UI -----
  #output$grouping.UI <- renderUI({
  #  radioButtons(inputId="grouping", label="Display trends by:",
  #               choices = c('species', 'species group', 'cave dependency'), 
  #               selected = 'species')
  #})#end grouping UI
  
  # Long-Term (yearly) group UI -----
  output$yearly.group.UI <- renderUI({
    
    switch(input$grouping,
           
           "species"=selectInput(inputId="yearly.group", 
                                 label="Select species:",
                                 choices = c('species'), 
                                 multiple = TRUE
           ),#end species grouping UI
           
           "species group"=selectInput(inputId="yearly.group", 
                                       label="Select species group(s):",
                                       choices = c('species'), 
                                       multiple = TRUE
           ),#end species group grouping UI
           
           "cave dependency"=selectInput(inputId="yearly.group", 
                                         label="Select cave status:",
                                         choices = c('dependent','not dependent'), 
                                         multiple = TRUE
           )#end cave dependency grouping UI
           
    )#end grouping switch

  })#end long-term group UI
  
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
  output$sampling.plot <- renderPlot({
    ggplot() +
      labs(title="Sampling Activity",
           x="year/date", y="N Sensors",
           caption="Sewanee Bat Study, DataLab 2022")
  })#end sampling plot ---
  
  # Sensor Accuracy plot -----
  output$sensor.plot <- renderPlot({
    ggplot() +
      labs(title="Sensor Accuracy",
           x="Sensor", y="Accuracy",
           caption="Sewanee Bat Study, DataLab 2022")
  })#end accuracy plot ---
  
  # end plots ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
}#end server

#--RUN--#######################################################################
shinyApp(ui, server)
