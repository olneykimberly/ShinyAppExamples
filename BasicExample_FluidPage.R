#install.pacakges("shiny")
library(shiny)
ui <- fluidPage(
  "Hello, my happy HPC colleagues"
)
server <- function(input, output, session){
}
shinyApp(ui, server)
