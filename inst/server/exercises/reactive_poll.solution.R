library(shiny)
library(httr)
library(xml2)
library(magrittr)

feedUrl <- "https://jchengdemo.wordpress.com/feed/"
# Or use http://lorem-rss.herokuapp.com/feed?unit=second&interval=5 for
# more frequently updating (but less realistic) data

ui <- fluidPage(
  tableOutput("entries")
)

server <- function(input, output, session) {
  feed_data <- reactivePoll(5000, session,
    function() {
      httr::HEAD(feedUrl)$headers[c("last-modified", "etag")]
    },
    function() {
      feed_xml <- read_xml(feedUrl)
      title <- xml_find_all(feed_xml, "/rss/channel/item/title") %>% xml_text()
      date <- xml_find_all(feed_xml, "/rss/channel/item/pubDate") %>% xml_text()
      link <- xml_find_all(feed_xml, "/rss/channel/item/link") %>% xml_text()
      data.frame(stringsAsFactors = FALSE,
        title = title, date = date, link = link
      )
    }
  )
  
  output$entries <- renderTable({
    feed_data()
  })
}

shinyApp(ui, server)