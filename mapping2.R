library(tidyverse)
library(shiny)
library(ggmap)
library(ggplot2)
library(maptools)
library(maps)
library(leaflet)

signals<- read.csv("~/Desktop/BU/MA615/HW/Traffic_Signals.csv")

signals<- na.omit(signals)
signals<- signals %>% select(X, Y, Location, Dist) %>% rename("Lat"="Y", "Long"="X")

icons <- awesomeIcons(
    icon = 'disc',
    iconColor = 'black',
    library = 'ion',
    markerColor = 'blue',
    squareMarker = FALSE
)

ui<- fluidPage(
    titlePanel("Traffic Signals in Boston"), 
    sidebarLayout(
        sidebarPanel(
            selectInput("district", "Select District for the signals", unique(signals$Dist))
        ),
        mainPanel(
            leafletOutput(outputId = "mapping")
        )
    )
)

server<- function(input, output, session){
    output$mapping<- renderLeaflet({
        sig<- signals %>% filter(Dist== input$district)
        leaflet(sig) %>% addTiles() %>%
            fitBounds(~min(Long), ~min(Lat), ~max(Long), ~max(Lat)) %>% 
            addProviderTiles("OpenStreetMap", group = "Mapnik")%>%
            addAwesomeMarkers(lng = ~Long, lat = ~Lat, label = ~Location, icon=icons)
    })
}

shinyApp(ui, server)

