library(shiny)
library(dplyr)

source("helpers/mockdaq.R")

ui <- fluidPage(
  tableOutput("all"),
  
  div(
    strong("Biggest gainer:"),
    textOutput("max_gainer", inline = TRUE)
  ),
  
  div(
    strong("Biggest loser:"),
    textOutput("max_loser", inline = TRUE)
  )
)

server <- function(input, output, session) {
  conn <- mockdaqConnect()
  session$onSessionEnded(function() {
    conn$close()
  })
  
  raw_data <- reactivePoll(1000, session,
    conn$last_modified,
    conn$fetch_prices
  )
  
  # Introduce a reactive expression to add the columns.
  # This is especially valuable because we're going to
  # use these columns from three different outputs.
  full_data <- reactive({
    df <- raw_data() %>% mutate(
      change = price - prev,
      change_pct = (price - prev) / prev * 100
    )
  })
  
  output$all <- renderTable({
    # Now using full_data() instead of raw_data()
    full_data()
  })
  
  output$max_gainer <- renderText({
    # Now using full_data() and change_pct
    max_gainer <- full_data() %>% top_n(1, change_pct)
    paste(max_gainer$symbol, formatC(max_gainer$change_pct))
  })
  
  output$max_loser <- renderText({
    # Now using full_data() and change_pct
    max_loser <- full_data() %>% top_n(-1, change_pct)
    paste(max_loser$symbol, formatC(max_loser$change_pct))
  })
  
}

shinyApp(ui, server)