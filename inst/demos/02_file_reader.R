library(shiny)
library(ggplot2)

ui <- fluidPage(
  plotOutput("plot"),
  tableOutput("table")
)

server <- function(input, output, session) {
  dataset <- reactiveFileReader(1000, session, "data.csv",
    read.csv, stringsAsFactors = FALSE)
  
  output$plot <- renderPlot({
    ggplot(dataset(), aes(Sepal.Width, Sepal.Length)) +
      geom_point()
  })
  
  output$table <- renderTable({
    dataset()
  })
}

shinyApp(ui, server)
