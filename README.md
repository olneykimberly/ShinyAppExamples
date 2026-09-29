# ShinyAppExamples

A collection of small, self-contained [Shiny](https://shiny.posit.co/) examples in R,
built to demonstrate how interactive web apps are structured and how they work.

## What is a Shiny app?

Shiny is an R package for building **interactive web applications directly from R** —
no HTML, CSS, or JavaScript required. You write R code, and Shiny turns it into a
web page that users can interact with: selecting inputs, filtering data, and viewing
plots, tables, and summaries that update automatically.

Shiny apps are useful for dashboards, data exploration tools, teaching demos, and
sharing analyses with people who don't code.

## How a Shiny app works

Every Shiny app has two pieces that work together:

1. **UI (user interface)** — *how the app looks.* It defines the layout: the input
   controls (dropdowns, sliders, checkboxes) and the output placeholders (plots,
   tables, text).
2. **Server** — *how the app works.* It's the recipe that takes the user's inputs,
   runs R code, and builds the outputs.

These are combined and launched with `shinyApp(ui, server)`.

```r
library(shiny)

# 1. UI: what the user sees
ui <- fluidPage(
  selectInput("dataset", "Dataset", choices = ls("package:datasets")),
  verbatimTextOutput("summary")
)

# 2. Server: what the app does
server <- function(input, output, session) {
  output$summary <- renderPrint({
    summary(get(input$dataset, "package:datasets"))
  })
}

# 3. Combine and launch
shinyApp(ui, server)
```

### Reactivity: the key idea

Shiny is **reactive**. Inputs and outputs are connected by name: an output like
`output$summary` reads an input like `input$dataset`. When the user changes that input,
Shiny automatically re-runs only the code that depends on it and refreshes the affected
output. You describe *what* each output should show; Shiny handles *when* to update it.

The wiring always follows this pattern:

- **Inputs** are read in the server as `input$<inputId>` (the ID comes from the UI).
- **Outputs** are assigned in the server as `output$<outputId>` and displayed in the
  UI by a matching `*Output()` function (e.g. `verbatimTextOutput("summary")` pairs
  with `output$summary`).

The IDs must match exactly on both sides, and R is case-sensitive.

## Running an app

From an R console:

```r
shiny::runApp("SimulatedDataTableExample")
```

Or open the app's `.R` file in Positron/RStudio and click **Run App**. The app opens
in a browser or viewer pane; stop it by closing the window or interrupting the console.

## Examples in this repo

| File / folder | What it shows |
|---|---|
| [BasicShiny.R](BasicShiny.R) | A minimal `page_sidebar()` app skeleton using `bslib`. |
| [BasicExample_FluidPage.R](BasicExample_FluidPage.R) | The simplest possible `fluidPage()` app. |
| [DatasetUIExample/](DatasetUIExample/) | Pick a built-in dataset and view its summary and table; includes a version using reactive expressions to avoid repeated work. |
| [SimulatedDataTableExample/](SimulatedDataTableExample/) | Simulates reproducible age/sex data, saves it to CSV, and visualizes sex differences across four outcomes. |
| [HowToDeployTheApp.R](HowToDeployTheApp.R) | Notes on deploying an app. |

Each app folder contains its own `app.R` so it can be launched independently.

## Resources

- [Shiny Gallery](https://shiny.posit.co/r/gallery/) — live example apps with source code
- [Shiny for R documentation](https://shiny.posit.co/r/getstarted/)
- [Mastering Shiny](https://mastering-shiny.org/) (free online book)
- [bslib](https://rstudio.github.io/bslib/) — modern Bootstrap layouts and theming for Shiny
