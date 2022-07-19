# Sewanee Bat Study
# Hallie Rutten, Monae Scott, Shelby Cline

# More about building applications with Shiny at
# http://shiny.rstudio.com/

# More about building applications with Shiny Dashboard at
# https://rstudio.github.io/shinydashboard/index.html

#--PREP--######################################################################

library(shiny)
library(shinydashboard)
library(plotly)

source('../dataRead.R')

bad <- c('no.ID','Noise')

grouping.ops <- c('species','species group','cave dependency')
species.ops <- sort(unique(bats$Common))
groups.ops <- sort(unique(bats$group_common))
cave.ops <- sort(unique(bats$obligate))

weather.ops <- c('rain','temperature','wind')
year.ops <- c( min(bats$year):max(bats$year) )
month.ops <- month.abb[1:12]

compartment.ops <- sort(unique(bats$COMPARTMENT))

cbPalette <- c("#600047", "#d7a8d4", "#f5dfef", "#fe5f00", 
               "#fed457", "#c2c527", "#9ae825", "#6f9c01", 
               "#c5d5ea", "#d3ffe2", "#a2c2c6", "#087d93",
               "#0c3660", "#133139")

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
      menuItem( text="Diversity Trends",  tabName="diversity", icon=icon("chart-pie") ),
      menuItem( text="Sampling Activity", tabName="sensor",    icon=icon("gear") ),
      
      # grouping -----
      #uiOutput("grouping.UI"),
      radioButtons(inputId="grouping", label="Display trends by:",
                   choices = grouping.ops, 
                   selected = grouping.ops[2]
      ),#end grouping UI
      uiOutput("group.UI"),
      
      # year filter ----
      selectInput(inputId = "year", 
                  label = "Select year(s):", 
                  choices = year.ops,
                  multiple = TRUE,
                  selected = year.ops
      ),#end year multiple select
      
      # month filter -----
      selectInput(inputId = "month", 
                  label = "Select month(s):", 
                  choices = month.ops,
                  multiple = TRUE, 
                  selected = month.ops
      )#end month multiple select
      
    )#end sidebar menu
    
  ),#--end sidebar--#
  
  #--body--====================================================================
  dashboardBody(
    
    # tabs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    tabItems(
      
      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      # About tab -----
      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      tabItem(tabName="about",
              
              # titles row -----
              fluidRow(
                column(width=9, h1("Introduction") ),
                column(width=3, h1("Tab Summaries") )
              ),#end titles row
              
              # about tab row -----
              fluidRow(
                
                # About box -----
                box( title="About the Sewanee Bat Study", width=9,
                     solidHeader=TRUE, collapsible=TRUE, status='primary',
                     h1("Welcome!"), 
                     "Bats are a vital part of ecosystems, but many species are 
                     declining due to 'white-nose syndrome', one of the worst 
                     wildlife diseases in modern history. Dr. Amy Turner and 
                     her team have worked together over the last six years on 
                     the Sewanee Bat Study to monitor Sewanee’s bat populations 
                     and make land management decisions in an effort to 
                     conserve. The goals of this project include: analyzing the 
                     trends in frequencies in bat activity across time and 
                     management areas to see which locations are crucial for 
                     bats, what land management practices are harmful or 
                     helpful, and what species seem to be thriving or not. We 
                     are analyzing the data and creating a dashboard to help 
                     make data-driven forest management decisions in 
                     collaboration with",
                     tags$a(href='https://new.sewanee.edu/offices/university-offices/environmental-stewardship-sustainability/',
                            "The Office of Environmental Stewardship and 
                            Sustainability and Domain Management."),
                     hr(),
                     h2('Key Terms & Definitions:'),
                     p( strong(em("Cave Obligate")), 
                     "means that a particular species of bat requires a cave 
                     year-round to roost in. Cave obligate bat species are the 
                     most vulnerable to white-nose syndrome."),
                     p( strong(em("Non Cave Obligate")),
                     "means that a species of a bat does not require a cave at 
                     all, and may rarely/never use one. These bats live 
                     primarily in the forest instead."),
                     p( strong(em("Seasonal Cave Obligate")),
                     "means that a species of bat requires a cave for 
                     hibernation only and spends the warmer months roosting 
                     in the forest."),
                     hr(),
                     h2('Bats of Sewanee:'),
                     img(src='Species.png', width="100%", height="auto"),
                     hr(),
                     h2('Land Management Practices:'),
                     "Our land management strategies are currently broken up 
                     into three categories: Managed, Unmanaged, and Cove. 
                     Managed land means that the land has experienced some type 
                     of alteration, such as a controlled burn or logging. 
                     Unmanaged land indicates that the land hasn’t received any 
                     management for several years. Coves are a separate entity, 
                     as it’s a small bay or inlet, and cannot be managed in the 
                     same ways that forest land can.", 
                     hr(),
                     h2('Further resources:'),
                     tags$a(href='http://www.tnbwg.org',
                            "Tennessee Bat Working Group"),
                     br(),
                     tags$a(href='https://www.nabatmonitoring.org',
                            "The North American Bat Monitoring Program"),
                     br(),
                     tags$a(href='https://www.tn.gov/twra/wildlife-management-areas/cumberland-plateau-r3/oak-ridge-wma.html',
                            "The Tennessee Wildlife Resources Agency"),
                     br(),
                     tags$a(href='https://www.fws.gov',
                            "The United States Fish and Wildlife Service")
                ),#end about box
                
                # tab summaries column -----
                column(width=3,
                       
                       box( title="Long-Term Trends", width=NULL,
                            solidHeader=TRUE, status='primary',
                            collapsible=TRUE, collapsed=TRUE,
                            "This tab will display an overview of bat activity 
                            trends across all recorded years, with the option
                            to compare across forest management types. Also
                            available are optional weather overlays tracking 
                            average wind, rain, and temperature in each year."
                       ),#end long-term summary
                       
                       box( title="Seasonal Trends", width=NULL,
                            solidHeader=TRUE, status='primary',
                            collapsible=TRUE, collapsed=TRUE,
                            "This tab will display bat activity trends by month 
                            of the year, with the option to compare across years 
                            or forest management types. Also available are 
                            optional weather overlays tracking the average 
                            wind, rain, and temperature in each month."
                       ),#end seasonal summary
                       
                       box( title="Circadian Trends", width=NULL,
                            solidHeader=TRUE, status='primary',
                            collapsible=TRUE, collapsed=TRUE,
                            "This tab will display bat activity trends by hour 
                            of the day on a 24-hour cycle, with the option to 
                            compare across months, years, or forest management
                            types."
                       ),#end circadian summary
                       
                       box( title="Spatial Trends", width=NULL,
                            solidHeader=TRUE, status='primary',
                            collapsible=TRUE, collapsed=TRUE,
                            "This tab will display the annual bat activity in
                            any given geographical compartment, with the option
                            to compare across sampling sites."
                       ),#end spatial summary
                       
                       box( title="Diversity Trends", width=NULL,
                            solidHeader=TRUE, status='primary',
                            collapsible=TRUE, collapsed=TRUE,
                            "This tab will display the proportion of bat 
                            activity accounted for by each species in each year,
                            with the option to compare across forest management
                            types."
                       ),#end diversity summary
                       
                       box( title="Sampling Activity", width=NULL,
                            solidHeader=TRUE, status='primary',
                            collapsible=TRUE, collapsed=TRUE,
                            "This tab will display a graph of sampling activity 
                            over time, as well as the proportions of noise and
                            unidentifiable bat calls for each sensor and 
                            microphone."
                       )#end sampling summary
                       
                )#end tabs column
                
              )#end about tab row -
              
      ),#end About ---
      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      
      
      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      # Long-Term (yearly) trends tab -----
      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      tabItem(tabName="yearly",
              
              # yearly row -----
              fluidRow(
                
                box( title="Long-Term Trends", width=9, 
                     solidHeader=TRUE, status='info',
                     plotOutput("yearly.plot") ),
                
                # controls column --
                column( width=3,
                        
                        # graph controls box
                        box( title="Graph Controls", width=NULL,
                             status='primary', collapsible=TRUE, 
                             #radioButtons(inputId="yearly.grouping", 
                             #             label="Display trends by:",
                             #             choices = grouping.ops, 
                             #             selected = grouping.ops[2]
                             #),#end grouping UI
                             #uiOutput("yearly.group.UI"),
                             checkboxGroupInput(inputId="yearly.weather",
                                                label="Weather display:",
                                                choices=weather.ops
                             ),#end weather check boxes
                             radioButtons(inputId="yearly.wrapVar", 
                                          label="Wrap facets by:",
                                          choices = c('none','management'), 
                                          selected = 'none'
                             )#end wrap var selection
                        ),#end graph controls box
                        
                        # aesthetic controls
                        box( title="Aesthetic Controls", width=NULL,
                             status='primary', collapsible=TRUE 
                        )#end aesthetics box
                        
                )#end controls column
                
              ),#end yearly row -
              
      ),#end Long-Term ---
      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      
      
      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      # Seasonal (monthly) trends tab -----
      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      tabItem(tabName="monthly",
              
              # monthly row -----
              fluidRow(
                
                box( title="Seasonal Trends", width=9,
                     solidHeader=TRUE, status='info',
                     plotOutput("monthly.plot") ),
                
                # controls column --
                column( width=3,
                        
                        # graph controls box
                        box( title="Graph Controls", width=NULL,
                             status='primary', collapsible=TRUE, 
                             #radioButtons(inputId="monthly.grouping", 
                             #             label="Display trends by:",
                             #             choices = grouping.ops, 
                             #             selected = grouping.ops[2]
                             #),#end grouping UI
                             #uiOutput("monthly.group.UI"),
                             checkboxGroupInput(inputId="monthly.weather",
                                                label="Weather display:",
                                                choices=weather.ops
                             ),#end weather check boxes
                             radioButtons(inputId="monthly.wrapVar", 
                                          label="Wrap facets by:",
                                          choices = c('none','year','management'), 
                                          selected = 'none'
                             )#end wrap var selection
                        ),#end graph controls box
                        
                        # aesthetic controls
                        box( title="Aesthetic Controls", width=NULL,
                             status='primary', collapsible=TRUE 
                        )#end aesthetics box
                        
                )#end controls column
                
              ),#end monthly row -
              
      ),#end Seasonal ---
      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      
      
      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      # Circadian (hourly) trends tab -----
      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      tabItem(tabName="hourly",
              
              # hourly row -----
              fluidRow(
                
                box( title="Circadian Trends", width=9,
                     solidHeader=TRUE, status='info',
                     plotOutput("hourly.plot") ),
                
                # controls column --
                column( width=3,
                        
                        # graph controls box
                        box( title="Graph Controls", width=NULL,
                             status='primary', collapsible=TRUE, 
                             #radioButtons(inputId="hourly.grouping", 
                             #             label="Display trends by:",
                             #             choices = grouping.ops, 
                             #             selected = grouping.ops[2]
                             #),#end grouping UI
                             #uiOutput("hourly.group.UI"),
                             radioButtons(inputId="hourly.wrapVar", 
                                          label="Wrap facets by:",
                                          choices = c('none','year','month','management'), 
                                          selected = 'none'
                             )#end wrap var selection
                        ),#end graph controls box
                        
                        # aesthetics controls
                        box( title="Aesthetic Controls", width=NULL,
                             status='primary', collapsible=TRUE 
                        )#end aesthetics box
                        
                )#end controls column
                
              ),#end hourly row -
              
      ),#end Circadian ---
      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      
      
      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      # Spatial (site) trends tab -----
      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      tabItem(tabName="site",
              
              # sites row -----
              fluidRow(
                
                box( title="Spatial Trends", width=9,
                     solidHeader=TRUE, status='info',
                     plotOutput("site.plot") ),
                
                # controls column --
                column( width=3,
                        
                        # graph controls box
                        box( title="Graph Controls", width=NULL,
                             status='primary', collapsible=TRUE, 
                             selectInput(inputId = "site.comp", 
                                         label = "Select compartment:", 
                                         choices = compartment.ops,
                                         #multiple = TRUE, 
                                         selected = compartment.ops[1]
                             ),#end compartment multiple select
                             radioButtons(inputId="site.wrapVar", 
                                          label="Wrap facets by:",
                                          choices = c('none','site'), 
                                          selected = 'none'
                             ),#end wrap var selection
                             radioButtons(inputId="site.granularity", 
                                          label="Granularity:",
                                          choices = c('year','month','day'), 
                                          selected = 'year'
                             )#end wrap var selection
                        ),#end graph controls box
                        
                        # aesthetic controls
                        box( title="Aesthetic Controls", width=NULL,
                             status='primary', collapsible=TRUE 
                        )#end aesthetics box
                        
                )#end controls column
                
              ),#end sites row -
              
      ),#end Spatial ---
      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      
      
      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      # Diversity (species) trends tab -----
      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      tabItem(tabName="diversity",
              
              # diversity row -----
              fluidRow(
                
                box( title="Diversity Trends", width=9,
                     solidHeader=TRUE, status='info',
                     plotlyOutput("diversity.plot") ),
                
                # controls column --
                column( width=3,
                        
                        # graph controls box
                        box( title="Graph Controls", width=NULL,
                             status='primary', collapsible=TRUE, 
                             #radioButtons(inputId="diversity.grouping", 
                             #             label="Display trends by:",
                             #             choices = grouping.ops, 
                             #             selected = grouping.ops[2]
                             #),#end grouping UI
                             #uiOutput("diversity.group.UI"),
                             radioButtons(inputId="diversity.wrapVar", 
                                          label="Wrap facets by:",
                                          choices = c('none','management'), 
                                          selected = 'none'
                             )#end wrap var selection
                        ),#end graph controls box
                        
                        # aesthetic controls
                        box( title="Aesthetic Controls", width=NULL,
                             status='primary', collapsible=TRUE 
                        )#end aesthetics box
                        
                )#end controls column
                
              ),#end diversity row -
              
      ),#end Diversity ---
      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      
      
      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      # Sampling Activity tab -----
      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      tabItem(tabName="sensor",
              
              # sampling row -----
              fluidRow(
                
                box( title="Sampling Activity", width=9,
                     solidHeader=TRUE, status='primary',
                     plotOutput("sampling.plot") ),
                
                # controls column --
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
                
              ),#end sampling row -
              
              # accuracy row -----
              fluidRow(
                
                tabBox(
                  title="Equipment Accuracy", width=9,
                  #solidHeader=TRUE, status='primary',
                  tabPanel("Recorder", plotOutput("sensor.plot") ),
                  tabPanel("Microphone", plotOutput("mic.plot") )
                ),#end tab box
                
                # controls column --
                column( width=3,
                        
                        # graph controls box
                        box( title="Graph Controls", width=NULL,
                             status='info', collapsible=TRUE, 
                             radioButtons(inputId="sensor.ob", 
                                          label="Focus:",
                                          choices = c('Noise','No.ID'), 
                                          selected = 'Noise'
                             ),#end focus selection
                             radioButtons(inputId="sensor.wrapVar", 
                                          label="Wrap facets by:",
                                          choices = c('none','year','month'), 
                                          selected = 'none'
                             )#end wrap var selection
                        ),#end graph controls box
                        
                        # aesthetic controls
                        box( title="Aesthetic Controls", width=NULL,
                             status='info', collapsible=TRUE
                        )#end aesthetic controls
                        
                )#end controls column
                
              )# end accuracy row -
              
      )#end Sampling ---
      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      
    )#end tabs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
  )#--end body--#
  
)#end UI

#--SERVER--####################################################################
server <- function(input, output) { 
  
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # grouping UI -----
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  output$grouping.UI <- renderUI({
    radioButtons(inputId="grouping", label="Display trends by:",
                 choices = grouping.ops, 
                 selected = grouping.ops[2])
  })#end grouping UI
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Group UI -----
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  output$group.UI <- renderUI({
    switch(input$grouping,
           "species"=selectInput(inputId="group",
                                 label="Select species:",
                                 choices = species.ops,
                                 multiple = TRUE,
                                 selected = species.ops[-which(species.ops%in%bad)]
           ),#end species grouping UI
           "species group"=selectInput(inputId="group", 
                                       label="Select species group(s):",
                                       choices = groups.ops, 
                                       multiple = TRUE,
                                       selected = groups.ops[-which(groups.ops%in%bad)]
           ),#end species group grouping UI
           "cave dependency"=selectInput(inputId="group", 
                                       label="Select cave status:",
                                       choices = cave.ops, 
                                       multiple = TRUE,
                                       selected = cave.ops[-which(cave.ops%in%bad)]
           )#end cave dependency grouping UI
    )#end grouping switch
  })#end group UI ---
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # reactive data -----
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  rv <- reactiveValues()
  observe({
    
    # standard bats filter -----
    bats.sub <- bats %>% 
      filter( year %in% input$year, month %in% input$month )
    
    # assign data for sensor accuracy -----
    rv$bats.acc <- bats.sub
    
    # make group and species columns -----
    if( input$grouping == grouping.ops[1] ){ 
      rv$legendTitle <- "Common Name"
      bats.sub <- bats.sub %>% 
        mutate( group=Common, species=Scientific )
    } else if( input$grouping == grouping.ops[2] ){
      rv$legendTitle <- "Common Name"
      bats.sub <- bats.sub %>% 
        mutate( group=group_common, species=group_species )
    } else if( input$grouping == grouping.ops[3] ){
      rv$legendTitle <- "Cave Status"
      bats.sub <- bats.sub %>% 
        mutate( group=obligate, species=obligate )
    }
    # grouping filter and assign main rv data -----
    rv$bats.sub <- bats.sub %>% filter( group %in% input$group )
    
    # filter and assign weather data -----
    rv$weather.sub <- weather %>% 
      filter( year %in% input$year, month %in% input$month )
    
  })
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Long-Term (yearly) plot -----
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  output$yearly.plot <- renderPlot({
    
    # summarize weather data -----
    weather.yr <- rv$weather.sub %>% 
      group_by(year) %>% 
      summarize( AvgTemp = mean(AvgTemp, na.rm=TRUE),
                 AvgWind = mean(AvgWind, na.rm=TRUE),
                 rain.intensity = mean(rain.intensity, na.rm=TRUE))
    
    # set wrapV by input wrap var -----
    if(input$yearly.wrapVar=='management'){ 
      bats.yr <- rv$bats.sub %>% mutate(wrapV=habitat) 
    }
    
    # summarize by appropriate groups -----
    if(input$yearly.wrapVar == 'none'){
      bats.yr <- rv$bats.sub %>% 
        group_by(year) %>% 
        mutate( nSensors = length(unique(siteDate)) )
      bats.yr <- bats.yr %>% 
        group_by(year,group,species) %>% 
        summarize( count=n(), relFreq=count/nSensors )
      bats.yr <- distinct(bats.yr)
    } else {
      bats.yr <- bats.yr %>% 
        group_by(year,wrapV) %>% 
        mutate( nSensors = length(unique(siteDate)) )
      bats.yr <- bats.yr %>% 
        group_by(year,wrapV,group,species) %>% 
        summarize( count=n(), relFreq=count/nSensors )
      bats.yr <- distinct(bats.yr)
    }
    
    # scale weather data -----
    yr.temp.ratio <- max(bats.yr$relFreq)/max(weather.yr$AvgTemp)
    yr.wind.ratio <- max(bats.yr$relFreq)/max(weather.yr$AvgWind)
    yr.rain.ratio <- max(bats.yr$relFreq)/max(weather.yr$rain.intensity)
    weather.yr <- weather.yr %>% 
      mutate( AvgTemp = AvgTemp*yr.temp.ratio,
              AvgWind = AvgWind*yr.wind.ratio,
              rain.intensity = rain.intensity*yr.rain.ratio )
    
    # make base plot -----
    yearly.p <- ggplot() +
      scale_fill_manual(values = cbPalette) +
      labs(title="Yearly Bat Activity",
           x="Year", y ="Relative Frequency",
           caption="Sewanee Bat Study, DataLab 2022",
           color=rv$legendTitle )
    
    # add weather geom -----
    if('rain' %in% input$yearly.weather){
      yearly.p <- yearly.p + 
        geom_area( data=weather.yr, 
                   aes(x=year, y=rain.intensity), fill='blue', alpha=0.1 )
    }
    if('wind' %in% input$yearly.weather){
      yearly.p <- yearly.p + 
        geom_area( data=weather.yr, 
                   aes(x=year, y=AvgWind), fill='yellow', alpha=0.1 )
    }
    if('temperature' %in% input$yearly.weather){
      yearly.p <- yearly.p + 
        geom_area( data=weather.yr, 
                   aes(x=year, y=AvgTemp), fill='red', alpha=0.1 )
    }
    
    # add activity line geom -----
    yearly.p <- yearly.p + 
      geom_line( data=bats.yr, aes(x=year, y=relFreq, color=group) )
    
    # wrap if appropriate -----
    if(input$yearly.wrapVar != 'none'){
      yearly.p <- yearly.p + 
        facet_wrap(~wrapV, ncol=round(sqrt(length(unique(bats.yr$wrapV)))) )
    }
    
    # make plot with plotly ----
    #aes(x=year, y=relFreq, color=group, text=paste("Group:",group))
    #ggplotly( yearly.p, hovertemplate=paste() )
    #ggplotly( yearly.p, tooltip=c("fill", "text"))
    yearly.p
    
  })#end long-term plot ---
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Seasonal (monthly) plot -----
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  output$monthly.plot <- renderPlot({
    
    # base weather data -----
    if(input$monthly.wrapVar=='year'){
      weather.mon <- rv$weather.sub %>% 
        group_by(year,month,monthN) %>% 
        summarize( AvgTemp = mean(AvgTemp, na.rm=TRUE),
                   AvgWind = mean(AvgWind, na.rm=TRUE),
                   rain.intensity = mean(rain.intensity, na.rm=TRUE))
    } else {
      weather.mon <- rv$weather.sub %>% 
        group_by(month,monthN) %>% 
        summarize( AvgTemp = mean(AvgTemp, na.rm=TRUE),
                   AvgWind = mean(AvgWind, na.rm=TRUE),
                   rain.intensity = mean(rain.intensity, na.rm=TRUE))
    }
    
    # set wrapV by input wrap var -----
    if(input$monthly.wrapVar=='year'){ 
      bats.mon <- rv$bats.sub %>% mutate(wrapV=year) }
    if(input$monthly.wrapVar=='management'){ 
      bats.mon <- rv$bats.sub %>% mutate(wrapV=habitat) }
    
    # summarize by appropriate groups -----
    if(input$monthly.wrapVar == 'none'){
      bats.mon <- rv$bats.sub %>% 
        group_by(monthN,month) %>% 
        mutate( nSensors = length(unique(siteDate)) )
      bats.mon <- bats.mon %>% 
        group_by(monthN,month,group,species) %>% 
        summarize( count=n(), relFreq=count/nSensors )
    } else {
      bats.mon <- bats.mon %>% 
        group_by(monthN,month,wrapV) %>% 
        mutate( nSensors = length(unique(siteDate)) )
      bats.mon <- bats.mon %>% 
        group_by(monthN,month,wrapV,group,species) %>% 
        summarize( count=n(), relFreq=count/nSensors )
    }
    bats.mon <- distinct(bats.mon)
    
    # scale weather data -----
    mon.temp.ratio <- max(bats.mon$relFreq)/max(weather.mon$AvgTemp, na.rm=TRUE)
    mon.wind.ratio <- max(bats.mon$relFreq)/max(weather.mon$AvgWind, na.rm=TRUE)
    mon.rain.ratio <- max(bats.mon$relFreq)/max(weather.mon$rain.intensity, na.rm=TRUE)
    weather.mon <- weather.mon %>% 
      mutate( AvgTemp = AvgTemp*mon.temp.ratio,
              AvgWind = AvgWind*mon.wind.ratio,
              rain.intensity = rain.intensity*mon.rain.ratio )
    
    # for the year wrap -----
    if(input$monthly.wrapVar=='year'){
      weather.mon <- weather.mon %>% mutate(wrapV=year) }
    
    # make base plot -----
    monthly.p <- ggplot() +
      scale_x_discrete(limits=month.abb[1:12]) +
      scale_fill_manual(values = cbPalette) +
      theme(axis.text.x = element_text(angle = 90)) +
      labs(title="Seasonal Bat Activity",
           x="Month", y="Relative Frequency",
           caption="Sewanee Bat Study, DataLab 2022",
           color=rv$legendTitle )
    
    # add weather -----
    if('rain' %in% input$monthly.weather){
      monthly.p <- monthly.p + 
        geom_area( data=weather.mon, 
                   aes(x=monthN, y=rain.intensity), fill='blue', alpha=0.1 )
    }
    if('wind' %in% input$monthly.weather){
      monthly.p <- monthly.p + 
        geom_area( data=weather.mon, 
                   aes(x=monthN, y=AvgWind), fill='yellow', alpha=0.1 )
    }
    if('temperature' %in% input$monthly.weather){
      monthly.p <- monthly.p + 
        geom_area( data=weather.mon, 
                   aes(x=monthN, y=AvgTemp), fill='red', alpha=0.1 )
    }
    
    # add activity line geom -----
    monthly.p <- monthly.p + 
      geom_line( data=bats.mon, aes(x=monthN, y=relFreq, color=group) )
    
    # wrap if appropriate -----
    if(input$monthly.wrapVar != 'none'){
      monthly.p <- monthly.p + facet_wrap(~wrapV)
    }
    
    # plot -----
    monthly.p
    
  })#end seasonal plot ---
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Circadian (hourly) plot -----
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  output$hourly.plot <- renderPlot({
    
    # set wrapV by input wrap var -----
    if(input$hourly.wrapVar=='year'){ 
      bats.hr <- rv$bats.sub %>% mutate(wrapV=year) 
    } else if(input$hourly.wrapVar=='month'){ 
      bats.hr <- rv$bats.sub %>% mutate(wrapV=factor(month,levels=month.abb[1:12]))
    } else if(input$hourly.wrapVar=='management'){ 
      bats.hr <- rv$bats.sub %>% mutate(wrapV=habitat) 
    }
    
    # summarize by appropriate groupings -----
    if(input$hourly.wrapVar == 'none'){
      bats.hr <- rv$bats.sub %>% 
        group_by(hour) %>% 
        mutate( nSensors = length(unique(siteDate)) )
      bats.hr <- bats.hr %>% 
        group_by(hour,group,species) %>% 
        summarize( count = n(), relFreq = count/nSensors )
    } else {
      bats.hr <- bats.hr %>% 
        group_by(hour, wrapV) %>% 
        mutate( nSensors = length(unique(siteDate)) )
      bats.hr <- bats.hr %>% 
        group_by(hour,wrapV,group,species) %>% 
        summarize( count = n(), relFreq = count/nSensors )
    }
    
    # make base plot -----
    hourly.p <- ggplot( bats.hr, aes(x=hour, y=relFreq, color=group) ) +
      scale_fill_manual(values = cbPalette) +
      labs(title="Circadian Bat Activity",
           x="Hour", y="Relative Frequency",
           caption="Sewanee Bat Study, DataLab 2022",
           color=rv$legendTitle )
    
    # wrap if appropriate -----
    if(input$hourly.wrapVar != 'none'){
      hourly.p <- hourly.p + facet_wrap(~wrapV)
    }
    
    # add line geom -----
    hourly.p <- hourly.p + geom_line()
    
    # make plot -----
    #aes(x=xVar, y=yVar, color=colVar, text=paste(content))
    #ggplotly( plot, hovertemplate=paste() )
    #ggplotly( plot, tooltip=c("color", "text"))
    hourly.p 
    
  })#end circadian plot ---
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Spatial (site) plot -----
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  output$site.plot <- renderPlot({
    
    # set granularity level -----
    if(input$site.granularity == 'year'){
      bats.map <- rv$bats.sub %>% mutate( div=year )
    } else if(input$site.granularity == 'month'){
      bats.map <- rv$bats.sub %>% 
        mutate( div=as.Date(paste(year(DATE),month(DATE),1,sep='-')) )
    } else { bats.map <- rv$bats.sub %>% mutate( div=DATE ) }
    
    # set wrapV by input wrap var -----
    if(input$site.wrapVar=='site'){ bats.map <- bats.map %>% mutate(wrapV=SITE) }
    
    # summarize by appropriate groups -----
    if(input$site.wrapVar == 'none'){
      bats.map <- bats.map %>% 
        group_by(COMPARTMENT,div) %>% 
        mutate( nSensors = length(unique(siteDate)) )
      bats.map <- bats.map %>% 
        group_by(COMPARTMENT,div,group,species) %>% 
        summarize( count=n(), relFreq=count/nSensors )
    } else {
      bats.map <- bats.map %>% 
        group_by(COMPARTMENT,div,wrapV) %>% 
        mutate( nSensors = length(unique(siteDate)) )
      bats.map <- bats.map %>% 
        group_by(COMPARTMENT,div,group,species,wrapV) %>% 
        summarize( count=n(), relFreq=count/nSensors )
    }
    bats.map <- distinct(bats.map)
    
    # graphing loop -----
    #for(comp in input$site.comp){
      
      # generate graph title -----
      comp.T <- paste("Compartment",input$site.comp,"Bat Activity")
      
      # make base plot -----
      site.p <- ggplot( bats.map %>% filter(COMPARTMENT==input$site.comp), 
                        aes(x=div, y=relFreq, color=group) ) +
        scale_fill_manual(values = cbPalette) +
        labs(title=comp.T,
             x="Date", y ="Relative Frequency",
             caption="Sewanee Bat Study, DataLab 2022",
             color=rv$legendTitle )
      
      # add line and point geoms -----
      site.p <- site.p + geom_line() + geom_point()
      
      # make year graph neat -----
      if(input$site.granularity == 'year'){
        site.p <- site.p + 
          scale_x_continuous( breaks = c(min(bats.map$div):max(bats.map$div)) )
      }
      
      # wrap if appropriate -----
      if(input$site.wrapVar != 'none'){ 
        site.p <- site.p + 
          facet_wrap(~wrapV) +
          theme(axis.text.x = element_text(angle = 90)) 
      }
      
      # plot -----
      print(site.p)
      
    #}# end graphing loop
    
  })#end spatial plot ---
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Diversity (species) plot -----
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  output$diversity.plot <- renderPlotly({
    
    # set wrapV by input wrap var -----
    if(input$diversity.wrapVar=='management'){ 
      bats.div <- rv$bats.sub %>% mutate(wrapV=habitat) }
    
    # summarize by appropriate groups -----
    if(input$diversity.wrapVar=='none'){
      bats.div <- rv$bats.sub %>% 
        group_by(year) %>% 
        mutate( total=n() )
      bats.div <- bats.div %>% 
        mutate( year=factor(year, levels=min(year):max(year)) ) %>% 
        group_by(year,group,species) %>% 
        summarise( prop = n()/total, 
                   perc = prop*100 )
    } else {
      bats.div <- bats.div %>% 
        group_by(year,wrapV) %>% 
        mutate( total=n() )
      bats.div <- bats.div %>% 
        mutate( year=factor(year, levels=min(year):max(year)) ) %>% 
        group_by(year,wrapV,group,species) %>% 
        summarise( prop = n()/total, 
                   perc = prop*100 )
    }
    bats.div <- distinct(bats.div)
    
    # make base plot -----
    diversity.p <- ggplot( bats.div, 
                           aes(x=year, y=perc, fill=group,
                               text=paste0("Percentage: ",round(perc,2),"% ")) ) +
      scale_fill_manual(values = cbPalette) +
      labs(title='Bat Species Proportions',
           x='Year', y='Percent of Total Activity',
           caption="Sewanee Bat Study, DataLab 2022",
           fill=rv$legendTitle )
    
    # add geom col -----
    diversity.p <- diversity.p + geom_col()
    
    # wrap if appropriate -----
    if(input$diversity.wrapVar != 'none'){
      diversity.p <- diversity.p + 
        facet_wrap(~wrapV) +
        theme(axis.text.x = element_text(angle = 90))
    }
    
    # make plot -----
    #aes(x=xVar, y=yVar, color=colVar, text=paste(content))
    #ggplotly( diversity.p, hovertemplate=paste0() )
    ggplotly( diversity.p, tooltip=c("text") )
    #diversity.p
    
  })#end diversity plot ---
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Sampling Activity plot -----
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  output$sampling.plot <- renderPlot({
    
    # group by granularity level -----
    if(input$sampling.granularity == 'year'){
      sensorDates <- sensorDates %>% mutate( div=year(DATE) )
    } else if(input$sampling.granularity == 'month'){
      sensorDates <- sensorDates %>% 
        mutate( div=as.Date(paste(year(DATE),month(DATE),1,sep='-')) )
    } else if(input$sampling.granularity == 'day'){
      sensorDates <- sensorDates %>% mutate( div=DATE )
    }
    
    # summarize number of sites -----
    sampling.days <- sensorDates %>% 
      filter( !is.na(project) | !is.na(monitor) ) %>% 
      group_by(div) %>% 
      summarize( trapNights = n() )
    
    # create base plot -----
    sample.plot <- ggplot( sampling.days, aes(x=div, y=trapNights) )
    
    # add plot geoms based on plot style input -----
    if(input$sampling.style == 'line'){
      sample.plot <- sample.plot + geom_line()
    }
    if(input$sampling.style == 'points'){
      sample.plot <- sample.plot + geom_point(alpha=0.4)
    }
    
    # make plot with labels -----
    sample.plot +
      labs(title="Sampling Activity",
           x=input$sampling.granularity, y="Sampling nights",
           caption="Sewanee Bat Study, DataLab 2022")
    
  })#end sampling plot ---
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Sensor Accuracy plot -----
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  output$sensor.plot <- renderPlot({
    
    # set wrapV by the input wrap var -----
    if(input$sensor.wrapVar == 'year'){
      bats.monitor <- rv$bats.acc %>% mutate( wrapV=year)
    } else if(input$sensor.wrapVar == 'month'){
      bats.monitor <- rv$bats.acc %>% mutate( wrapV=month)
    } 
    
    # summarize by appropriate groups -----
    if(input$sensor.wrapVar == 'none'){
      bats.monitor <- rv$bats.acc %>% 
        group_by(monitor) %>% 
        summarize( nBats = sum(as.numeric(!grepl('no.ID|Noise',AUTO.ID))),
                   unID  = sum(as.numeric(grepl('no.ID',AUTO.ID))),
                   noise = sum(as.numeric(grepl("Noise",AUTO.ID))),
                   total = n() )
    } else {
      bats.monitor <- bats.monitor %>% 
        group_by(monitor,wrapV) %>% 
        summarize( nBats = sum(as.numeric(!grepl('no.ID|Noise',AUTO.ID))),
                   unID  = sum(as.numeric(grepl('no.ID',AUTO.ID))),
                   noise = sum(as.numeric(grepl("Noise",AUTO.ID))),
                   total = n() )
    }
    bats.monitor <- bats.monitor %>% mutate(p.unID=unID/total, p.noise=noise/total)
    
    # create base plots by plot focus -----
    if(input$sensor.ob == 'Noise'){
      monitor.p <- ggplot( bats.monitor, aes(x=monitor, y=p.noise, fill=-p.noise) )
    } else {
      monitor.p <- ggplot( bats.monitor, aes(x=monitor, y=p.unID, fill=-p.unID) )
    }
    
    # add the column geom -----
    monitor.p <- monitor.p +
      geom_col() +
      theme(legend.position='none') +
      theme(axis.text.x = element_text(angle = 90))
    
    # facet wrap if appropriate -----
    if(input$sensor.wrapVar != 'none'){
      monitor.p <- monitor.p + facet_wrap(~wrapV)
    }
    
    # make plot title -----
    monitor.ttl <- paste("Monitor Detections:",input$sensor.ob)
    
    # make plot with labels -----
    monitor.p +
      labs(title=monitor.ttl,
           x="Monitor Serial", y="Proportion",
           caption="Sewanee Bat Study, DataLab 2022")
    
  })#end sensor plot ---
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Microphone Accuracy plot -----
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  output$mic.plot <- renderPlot({
    
    # set wrapV by the input wrap var -----
    if(input$sensor.wrapVar == 'year'){
      bats.mic <- rv$bats.acc %>% mutate( wrapV=year)
    } else if(input$sensor.wrapVar == 'month'){
      bats.mic <- rv$bats.acc %>% mutate( wrapV=month)
    } 
    
    # summarize by appropriate groups -----
    if(input$sensor.wrapVar == 'none'){
      bats.mic <- rv$bats.acc %>% 
        group_by(mic) %>% 
        summarize( nBats = sum(as.numeric(!grepl('no.ID|Noise',AUTO.ID))),
                   unID  = sum(as.numeric(grepl('no.ID',AUTO.ID))),
                   noise = sum(as.numeric(grepl("Noise",AUTO.ID))),
                   total = n() )
    } else {
      bats.mic <- bats.mic %>% 
        group_by(mic,wrapV) %>% 
        summarize( nBats = sum(as.numeric(!grepl('no.ID|Noise',AUTO.ID))),
                   unID  = sum(as.numeric(grepl('no.ID',AUTO.ID))),
                   noise = sum(as.numeric(grepl("Noise",AUTO.ID))),
                   total = n() )
    }
    bats.mic <- bats.mic %>% mutate(p.unID=unID/total, p.noise=noise/total)
    
    # create base plots by plot focus -----
    if(input$sensor.ob == 'Noise'){
      mic.p <- ggplot( bats.mic, aes(x=mic, y=p.noise, fill=-p.noise) )
    } else {
      mic.p <- ggplot( bats.mic, aes(x=mic, y=p.unID, fill=-p.unID) )
    }
    
    # add the column geom -----
    mic.p <- mic.p +
      geom_col() +
      theme(legend.position='none') +
      theme(axis.text.x = element_text(angle = 90))
    
    # facet wrap if appropriate -----
    if(input$sensor.wrapVar != 'none'){
      mic.p <- mic.p + facet_wrap(~wrapV)
    }
    
    # make plot title -----
    mic.ttl <- paste("Microphone Detections:",input$sensor.ob)
    
    # make plot with labels -----
    mic.p +
      labs(title=mic.ttl,
           x="Mic Serial", y="Accuracy",
           caption="Sewanee Bat Study, DataLab 2022")
    
  })#end mic plot ---
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
}#end server

#--RUN--#######################################################################
shinyApp(ui, server)
