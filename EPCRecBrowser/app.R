#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny) ; library(leaflet)

# Define UI for application that draws a histogram
ui <- navbarPage("ONS Linked Data", id="nav",
                 
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
                                            
                                            h2("Choose Data to compare")
                                            
                                         
                              ),
                              
                              tags$div(id="cite",
                                       'Data compiled for: ', tags$em('Demonstration ONS & Scottish Government Linked Data'), ' by Jamie Whyte / Swirrl (2017).'
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
  
  # Put the default map co-ordinates and zoom level into variables
  lat <- 57.542788
  lng <- 0.144708
  zoom <- 6
  
  # Draw the map
  output$map <- renderLeaflet({
    
    leaflet() %>% 
      addProviderTiles("Esri.WorldStreetMap") %>% 
      setView(lat = lat, lng = lng, zoom = zoom) 
      #addPolygons(data = scotcouncil, opacity=1, color = "black", weight = 1, fillOpacity=0.8, layerId = scotcouncil$CODE)
    
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

