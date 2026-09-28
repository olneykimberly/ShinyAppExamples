# Shiny example of exploring different datasets in the datasets package
# shows the data in the table and a summary statistic 
# this code uses reactive expressions to reduce redundancy and for overall improved efficiency. Critical for larger apps. 
library(shiny)

# User interface - how the app looks
ui <- fluidPage( # the layout function 
  selectInput("dataset", label = "Dataset", choices = ls("package:datasets")), # input control
  verbatimTextOutput("summary"), # output controls
  tableOutput("table")  # output controls
)

# Server - how the app works. Its the recipe of how to make the cake. 
server <- function(input, output, session){
  # Create a reactive expression
  dataset <- reactive({
    get(input$dataset, "package:datasets")
  })
  output$summary <- renderPrint({ # to display a statistical summary with fixed-width verbatim text
    summary(dataset())
  })
  output$table <- renderTable({ # to show the input data in a table format
    dataset()
  })
}

# Combines a UI definition and a server function into a single, runnable web application object
shinyApp(ui, server)


