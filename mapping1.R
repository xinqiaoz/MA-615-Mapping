
library(shiny)
library(ggmap)
library(maptools)
library(maps)

mapWorld <- map_data("world")

mp1 <- ggplot(mapWorld, aes(x=long, y=lat, group=group))+
    geom_polygon(fill="white", color="black")

projections<- c("cylindrical", "mercator", "sinusoidal", "gnomonic")

ui<- fluidPage(
    titlePanel("World map in different projections"), 
    sidebarLayout(
        sidebarPanel(
            selectInput("proj", "Select projection for the map", projections)
        ),
        mainPanel(
            plotOutput(outputId = "mapping")
        )
    )
)


server<- function(input, output, session){
    output$mapping<- renderPlot({
        mp1 + coord_map(input$proj, xlim=c(-180,180), ylim=c(-60, 90))
    })
}

shinyApp(ui, server)




