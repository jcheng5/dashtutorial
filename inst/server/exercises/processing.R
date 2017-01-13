library(shiny)
library(dplyr)

# This app shows an auto-updating table of fake stock data.
# The table contains the following columns:
# 
# - symbol  (the ticker symbol)
# - prev    (the share price at the previous day's closing)
# - price   (the share price right now)
# 
# It also shows the symbol and price of the stocks with the
# highest and lowest share prices.
# 
# ASSIGNMENT:
# 
# Add two columns to the table output:
# 
# - change     (price change since previous day's closing, in $)
# - change_pct (price change since previous day's closing, in %)
# 
# Also, showing the stocks with highest and lowest share price
# is pretty useless. Change those to the biggest gainer and loser,
# by change_pct.

source("helpers/mockdaq.R", local = TRUE)

ui <- fluidPage(
  
  tableOutput("all"),
  
  div(
    strong("Highest price:"),
    textOutput("max_price", inline = TRUE)
  ),
  
  div(
    strong("Lowest price:"),
    textOutput("min_price", inline = TRUE)
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

  output$all <- renderTable({
    raw_data()
  })
  
  output$max_price <- renderText({
    max_price <- raw_data() %>% top_n(1, price)
    paste(max_price$symbol, formatC(max_price$price))
  })
  
  output$min_price <- renderText({
    min_price <- raw_data() %>% top_n(1, -price)
    paste(min_price$symbol, formatC(min_price$price))
  })
  
}

shinyApp(ui, server)