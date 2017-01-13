library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Awesome dashboard"),
  dashboardSidebar(),
  dashboardBody()
)

server <- function(input, output) { }

shinyApp(ui, server)
