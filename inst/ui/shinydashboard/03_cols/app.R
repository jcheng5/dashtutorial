library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(),
  dashboardBody(
    fluidRow(
      column(width = 6,
        box(plotOutput("plot1"), width = NULL),
        box(plotOutput("plot2"), width = NULL)
      ),
      column(width = 6,
        box(tableOutput("table1"), width = NULL)
      )
    )
  )
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
