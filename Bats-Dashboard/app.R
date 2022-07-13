# Sewanee Bat Study
# Hallie Rutten, Monae Scott, Shelby Cline

# More about building applications with Shiny at
# http://shiny.rstudio.com/

# More about building applications with Shiny Dashboard at
# https://rstudio.github.io/shinydashboard/index.html

#--PREP--######################################################################

library(shiny)
library(shinydashboard)

source('../dataRead.R')

grouping.ops <- c('species','species group','cave dependency')
species.ops <- sort(unique(bats$AUTO.ID))
groups.ops <- sort(unique(bats$species_group))
cave.ops <- sort(unique(bats$obligate))

weather.ops <- c('rain','temperature','wind')
year.ops <- c( min(bats$year):max(bats$year) )
month.ops <- month.abb[1:12]

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
      
      # compartment filter -----
      #selectInput(inputId = "compartment", 
      #            label = "Select compartment(s):", 
      #            choices = unique(bats$COMPARTMENT),
      #            multiple = TRUE 
      #)#end compartment multiple select
      
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
                     "[summarize bat species]"
                ),#end about box
                
                # tab summaries column -----
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
                             #radioButtons(inputId="site.grouping", 
                             #             label="Display trends by:",
                             #             choices = grouping.ops, 
                             #             selected = grouping.ops[2]
                             #),#end grouping UI
                             #uiOutput("site.group.UI"),
                             radioButtons(inputId="site.display", 
                                          label="Display style:",
                                          choices = c('facet','multiple'), 
                                          selected = 'facet'
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
                     plotOutput("diversity.plot") ),
                
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
                                       selected = species.ops
           ),#end species grouping UI
           "species group"=selectInput(inputId="group", 
                                       label="Select species group(s):",
                                       choices = groups.ops, 
                                       multiple = TRUE,
                                       selected = groups.ops
           ),#end species group grouping UI
           "cave dependency"=selectInput(inputId="group", 
                                       label="Select cave status:",
                                       choices = cave.ops, 
                                       multiple = TRUE,
                                       selected = cave.ops
           )#end cave dependency grouping UI
    )#end grouping switch
  })#end group UI ---
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Long-Term (yearly) group UI -----
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #output$yearly.group.UI <- renderUI({
  #  switch(input$yearly.grouping,
  #         "species"=selectInput(inputId="yearly.group", 
  #                               label="Select species:",
  #                               choices = c('species'), 
  #                               multiple = TRUE
  #         ),#end species grouping UI
  #         "species group"=selectInput(inputId="yearly.group", 
  #                                     label="Select species group(s):",
  #                                     choices = c('species'), 
  #                                     multiple = TRUE
  #         ),#end species group grouping UI
  #         "cave dependency"=selectInput(inputId="yearly.group", 
  #                                       label="Select cave status:",
  #                                       choices = c('dependent','not dependent'), 
  #                                       multiple = TRUE
  #         )#end cave dependency grouping UI
  #  )#end grouping switch
  #})#end long-term group UI ---
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Seasonal (monthly) group UI -----
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #output$monthly.group.UI <- renderUI({
  #  switch(input$monthly.grouping,
  #         "species"=selectInput(inputId="monthly.group", 
  #                               label="Select species:",
  #                               choices = c('species'), 
  #                               multiple = TRUE
  #         ),#end species grouping UI
  #         "species group"=selectInput(inputId="monthly.group", 
  #                                     label="Select species group(s):",
  #                                     choices = c('species'), 
  #                                     multiple = TRUE
  #         ),#end species group grouping UI
  #         "cave dependency"=selectInput(inputId="monthly.group", 
  #                                       label="Select cave status:",
  #                                       choices = c('dependent','not dependent'), 
  #                                       multiple = TRUE
  #         )#end cave dependency grouping UI
  #  )#end grouping switch
  #})#end seasonal group UI ---
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Circadian (hourly) group UI -----
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #output$hourly.group.UI <- renderUI({
  #  switch(input$hourly.grouping,
  #         "species"=selectInput(inputId="hourly.group", 
  #                               label="Select species:",
  #                               choices = c('species'), 
  #                               multiple = TRUE
  #         ),#end species grouping UI
  #         "species group"=selectInput(inputId="hourly.group", 
  #                                     label="Select species group(s):",
  #                                     choices = c('species groups'), 
  #                                     multiple = TRUE
  #         ),#end species group grouping UI
  #         "cave dependency"=selectInput(inputId="hourly.group", 
  #                                       label="Select cave status:",
  #                                       choices = c('dependent','not dependent'), 
  #                                       multiple = TRUE
  #         )#end cave dependency grouping UI
  #  )#end grouping switch
  #})#end circadian group UI ---
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Spatial (site) group UI -----
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #output$site.group.UI <- renderUI({
  #  switch(input$site.grouping,
  #         "species"=selectInput(inputId="site.group", 
  #                               label="Select species:",
  #                               choices = c('species'), 
  #                               multiple = TRUE
  #         ),#end species grouping UI
  #         "species group"=selectInput(inputId="site.group", 
  #                                     label="Select species group(s):",
  #                                     choices = c('species groups'), 
  #                                     multiple = TRUE
  #         ),#end species group grouping UI
  #         "cave dependency"=selectInput(inputId="site.group", 
  #                                       label="Select cave status:",
  #                                       choices = c('dependent','not dependent'), 
  #                                       multiple = TRUE
  #         )#end cave dependency grouping UI
  #  )#end grouping switch
  #})#end spatial group UI ---
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Diversity (species) group UI -----
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #output$diversity.group.UI <- renderUI({
  #  switch(input$diversity.grouping,
  #         "species"=selectInput(inputId="diversity.group", 
  #                               label="Select species:",
  #                               choices = c('species'), 
  #                               multiple = TRUE
  #         ),#end species grouping UI
  #         "species group"=selectInput(inputId="diversity.group", 
  #                                     label="Select species group(s):",
  #                                     choices = c('species groups'), 
  #                                     multiple = TRUE
  #         ),#end species group grouping UI
  #         "cave dependency"=selectInput(inputId="diversity.group", 
  #                                       label="Select cave status:",
  #                                       choices = c('dependent','not dependent'), 
  #                                       multiple = TRUE
  #         )#end cave dependency grouping UI
  #  )#end grouping switch
  #})#end diversity group UI ---
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # reactive data -----
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  rv <- reactiveValues()
  observe({
    
    # standard year filter -----
    bats.sub <- bats %>% 
      filter( year %in% input$year )
    # make group column -----
    if( input$grouping == grouping.ops[1] ){ 
      bats.sub <- bats.sub %>% mutate( group = AUTO.ID )
    } else if( input$grouping == grouping.ops[2] ){
      bats.sub <- bats.sub %>% mutate( group = species_group )
    } else if( input$grouping == grouping.ops[3] ){
      bats.sub <- bats.sub %>% mutate( group = obligate )
    }
    # grouping filter -----
    bats.sub <- bats.sub %>% filter( group %in% input$group )
    # assign rv -----
    rv$bats.sub <- bats.sub
    
  })
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Long-Term (yearly) plot -----
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  output$yearly.plot <- renderPlot({
    ggplot() +
      labs(title="Long-Term Bat Activity",
           x="Year", y="Relative Frequency",
           caption="Sewanee Bat Study, DataLab 2022")
  })#end long-term plot ---
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Seasonal (monthly) plot -----
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  output$monthly.plot <- renderPlot({
    ggplot() +
      labs(title="Seasonal Bat Activity",
           x="Month", y="Relative Frequency",
           caption="Sewanee Bat Study, DataLab 2022")
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
      bats.hr <- rv$bats.sub %>% mutate(wrapV=month)
    } else if(input$hourly.wrapVar=='management'){ 
      bats.hr <- rv$bats.sub %>% mutate(wrapV=habitat) 
    }
    
    # summarize by appropriate groupings -----
    if(input$hourly.wrapVar == 'none'){
      bats.hr <- rv$bats.sub %>% 
        group_by(hour) %>% 
        mutate( nSensors = length(unique(siteID)) )
      bats.hr <- bats.hr %>% 
        group_by(hour,group) %>% 
        summarize( count = n(), relFreq = count/nSensors )
    } else {
      bats.hr <- bats.hr %>% 
        group_by(hour, wrapV) %>% 
        mutate( nSensors = length(unique(siteID)) )
      bats.hr <- bats.hr %>% 
        group_by(hour,wrapV,group) %>% 
        summarize( count = n(), relFreq = count/nSensors )
    }
    
    # make base plot -----
    hourly.p <- ggplot( bats.hr ) +
      geom_line( aes(x=hour, y=relFreq, color=group) )
    
    # wrap if appropriate -----
    if(input$hourly.wrapVar != 'none'){
      hourly.p <- hourly.p + facet_wrap(~wrapV)
    }
    
    # make plot with labels -----
    hourly.p +
      labs(title="Circadian Bat Activity",
           x="Hour", y="Relative Frequency",
           caption="Sewanee Bat Study, DataLab 2022")
    
  })#end circadian plot ---
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Spatial (site) plot -----
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  output$site.plot <- renderPlot({
    ggplot() +
      labs(title="Spatial Bat Activity",
           x="Compartment", y="Relative Frequency",
           caption="Sewanee Bat Study, DataLab 2022")
  })#end spatial plot ---
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Diversity (species) plot -----
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  output$diversity.plot <- renderPlot({
    ggplot() +
      labs(title="Bat Species Trends",
           x="year/month", y="Proportion",
           caption="Sewanee Bat Study, DataLab 2022")
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
      bats.monitor <- rv$bats.sub %>% mutate( wrapV=year)
    } else if(input$sensor.wrapVar == 'month'){
      bats.monitor <- rv$bats.sub %>% mutate( wrapV=month)
    } 
    
    # summarize by appropriate groups -----
    if(input$sensor.wrapVar == 'none'){
      bats.monitor <- rv$bats.sub %>% 
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
      bats.mic <- rv$bats.sub %>% mutate( wrapV=year)
    } else if(input$sensor.wrapVar == 'month'){
      bats.mic <- rv$bats.sub %>% mutate( wrapV=month)
    } 
    
    # summarize by appropriate groups -----
    if(input$sensor.wrapVar == 'none'){
      bats.mic <- rv$bats.sub %>% 
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
