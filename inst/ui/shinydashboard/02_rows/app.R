library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(),
  dashboardBody(
    fluidRow(
      box(
        plotOutput("plot1")
      ),
      box(
        tableOutput("table1")
      )
    )
  )
)

server <- function(input, output) {
  output$plot1 <- renderPlot({
    plot(cars)
  })

  output$table1 <- renderTable({
    cars
  })
}

shinyApp(ui, server)
