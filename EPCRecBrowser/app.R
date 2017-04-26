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
  turbines <- subset(mancrecs, RecommendationCode == 'EPC-R2')
  solarpanels <- subset(mancrecs, RecommendationCode =='EPC-R4')
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
      addPolylines(data = gmlas, opacity=1, color = "#444444", weight = 2, layerId = gmlas$CODE)
      #addCircleMarkers(data=turbines,lng = ~X, lat = ~Y, popup = ~Address, color="#165eee", stroke = FALSE, fillOpacity = 0.3) %>%
      #addCircleMarkers(data=solarpanels,lng = ~X, lat = ~Y, popup = ~Address, color="#3da23a",stroke = FALSE, fillOpacity = 0.3)
      
  })
  
  observeEvent(input$checkGroup, {
    print("YES!")
    
    leafletProxy("map") %>%
      addCircleMarkers(data=solarpanels,lng = ~X, lat = ~Y, popup = ~Address, color="#3da23a",stroke = FALSE, fillOpacity = 0.3)
        
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

