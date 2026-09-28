library(shiny)

# User interface - how the app looks
ui <- fluidPage( # the layout function 
  selectInput("dataset", label = "Dataset", choices = ls("package:datasets")), # input control
  verbatrimTextOutput("Dataset Summary"), # output controls
  tableOutput("table")  # output controls
)

# Server - how the app works. Its the recipe of how to make the cake. 
server <- function(input, output, session){
  output$summary <- renderPrint({ # to display a stastical summary with fixed-width verbatim text
    dataset <- get(input$dataset, "package:datasets")
    summary(dataset)
  })
  output$table <- renderTable( # to show the input data in a table format
    dataset <- get(input$dataset, "package:datasets")
    dataset
  )
}
shinyApp(ui, server)


