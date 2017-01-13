# A simulated stock price data source.
# 
# md <- mockdaqConnect()
# 
# > md$last_modified()
# [1] "2017-01-06 18:42:30 PST"
# 
# > md$fetch_prices()
#     symbol  prev price
# 1      BAC 22.68 22.94
# 2      JCP  7.57  7.58
# 3     NYRT  9.77  9.72
# 4        F 12.76 12.83
# 5      CHK  7.01  7.01
# 6        T 41.32 41.34
mockdaqConnect <- function() {
  # Starting values
  stocks <- read.csv(text = 'symbol,prev
    "BAC",22.68
    "JCP",7.57
    "NYRT",9.77
    "F",12.76
    "CHK",7.01
    "T",41.32', stringsAsFactors=FALSE)
  
  # Config parameters
  interval <- 5      # How many seconds to wait between updates
  drift_sd <- 0.005  # Std dev of how much to drift prices by
  
  # Mutable state
  last_modified <- Sys.time() - interval
  factors <- rep.int(1, nrow(stocks))
  
  # Simulation loop
  run <- function() {
    while (last_modified + interval <= Sys.time()) {
      factors <<- factors + rnorm(nrow(stocks), sd = drift_sd)
      last_modified <<- last_modified + interval
    }
  }
  
  list(
    last_modified = function() {
      run() # Run simulation if necessary
      Sys.sleep(0.1) # Simulate latency
      last_modified
    },
    fetch_prices = function() {
      run() # Run simulation if necessary
      Sys.sleep(0.7) # Simulate latency
      
      result <- cbind(
        stocks,
        price = round(pmax(0, stocks$prev * factors), digits = 2)
      )
      result
    },
    close = function() {
    }
  )
}
