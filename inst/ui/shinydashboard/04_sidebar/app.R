library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(
    sliderInput("s", "Slider", 1, 100, 20),
    dateInput("d", "Date")
  ),
  dashboardBody()
)

server <- function(input, output) {
  output$plot1 <- renderPlot({
    plot(cars)
  })
  output$plot2 <- renderPlot({
    plot(pressure)
  })
  output$table1 <- renderTable({
    cars
  })
}

shinyApp(ui, server)
