#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny) ; library(leaflet) ; library(rgdal) ; library(readr) ; library(dplyr)




# Define UI for application that draws a histogram
ui <- navbarPage("Non-domestic EPC Recommendations", id="nav",
                 
                 tabPanel("MAP",
                          div(class="outer",
                              
                              tags$head(
                                # Include our custom CSS
                                includeCSS("styles.css")
                                
                                #includeScript("gomap.js")
                              ),
                              
                              leafletOutput("map", width="100%", height="100%"),
                              
                              # Shiny versions prior to 0.11 should use class="modal" instead.
                              absolutePanel(id = "controls",style = " height: 100vh; overflow-y: auto; ", class = "panel panel-default", fixed = TRUE,
                                            draggable = TRUE, top = 60, left = "auto", right = 30, bottom = "auto",
                                            width = 450, height = "auto",
                                            
                                            dateRangeInput("dates", label = h3("Date range")),
                                            
                                            hr(),
                                            fluidRow(column(4, verbatimTextOutput("value"))),
                                            checkboxInput("check_EPCC1", label = "The default chiller efficiency is chosen. It is recommended that the chiller system be investigated to gain an understanding of its efficiency and possible improvements.", value = TRUE),
                                            checkboxInput("check_EPCC2", label = "Chiller efficiency is low. Consider upgrading chiller plant."),
                                            checkboxInput("check_EPCC3", label = "Ductwork leakage is high. Inspect and seal ductwork."),
                                            checkboxInput("check_EPCE1", label = "Some floors are poorly insulated - introduce and/or improve insulation. Add insulation to the exposed surfaces of floors adjacent to underground, unheated spaces or exterior."),
                                            checkboxInput("check_EPCE2", label = "Roof is poorly insulated. Install or improve insulation of roof."),
                                            checkboxInput("check_EPCE3", label = "Some solid walls are poorly insulated - introduce or improve internal wall insulation."),
                                            checkboxInput("check_EPCE4", label = "Some walls have uninsulated cavities - introduce cavity wall insulation."),
                                            checkboxInput("check_EPCE5", label = "Some windows have high U-values - consider installing secondary glazing."),
                                            checkboxInput("check_EPCE6", label = "Some loft spaces are poorly insulated - install/improve insulation."),
                                            checkboxInput("check_EPCE7", label = "Carry out a pressure test, identify and treat identified air leakage."),
                                            checkboxInput("check_EPCE8", label = "Some glazing is poorly insulated. Replace/improve glazing and/or frames."),
                                            
                                            checkboxGroupInput("checkGroup", label = h3("Show recommendations"), 
                                                               choices = list("Wind Turbine" = 1, "Solar Panels" = 2, "Insulation" = 3))
                                            
                                         
                              ),
                              
                              tags$div(id="cite",
                                       'Data compiled for: ', tags$em('Non-domestic EPC recommendations, OpenDataCommunities'), ' by Jamie Whyte / Swirrl (2017).'
                              )
                          )
                 ),
                 
                 tabPanel("DATA",
                          fluidRow(
                            column(3,
                                   div(h3("Datatable")),
                                   DT::dataTableOutput("table")
                            )
                          )
                 )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  gmlas <- readOGR("gmauthoritiessimp2perc4326.geojson", "OGRGeoJSON")
  mancrecs <- readOGR("manchesterrecs.geojson", "OGRGeoJSON")
  #geomergeddata <- read_csv("geomergeddata.csv")
  EPCC1dat <- subset(mancrecs, RecommendationCode =='EPC-C1')
  EPCC2dat <- subset(mancrecs, RecommendationCode =='EPC-C2')
  EPCC3dat <- subset(mancrecs, RecommendationCode =='EPC-C3')
  
  
  #print(nrow(turbines))
  # Put the default map co-ordinates and zoom level into variables
  lat <- 53.442788
  lng <- -2.084708
  zoom <- 10
  
  # Draw the map
  output$map <- renderLeaflet({
    
    leaflet() %>% 
      addProviderTiles("Esri.WorldStreetMap") %>% 
      setView(lat = lat, lng = lng, zoom = zoom) %>%
      addPolylines(data = gmlas, opacity=1, color = "#444444", weight = 2, layerId = gmlas$CODE) %>%
      addCircleMarkers(data=EPCC1dat,lng = ~X, lat = ~Y, popup = ~Address, color="#3da23a",stroke = FALSE, fillOpacity = 0.3, group = 'EPCC1') %>%
      addCircleMarkers(data=EPCC2dat,lng = ~X, lat = ~Y, popup = ~Address, color="#5ea23a",stroke = FALSE, fillOpacity = 0.3, group = 'EPCC2')
      addCircleMarkers()
      
  })
  
  observe({
    
    if (input$check_EPCC1 == TRUE) {
    leafletProxy("map") %>%
        showGroup('EPCC1')
    } else {
     
       leafletProxy("map") %>%
        hideGroup('EPCC1')
    }
    
    if (input$check_EPCC2 == TRUE) {
      leafletProxy("map") %>%
        hideGroup('EPCC2')
    } else {
      
      leafletProxy("map") %>%
        hideGroup('EPCC2')
    }
  
    
    })
    

  
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)

