library(shiny)
library(bslib)
library(tidyverse)

sim_data <- read_csv("data/simulated_data.csv", show_col_types = FALSE)

outcome_choices <- c(
  "Memory performance" = "memory_score",
  "Speed test score" = "speed_score",
  "Weight (kg)" = "weight_kg",
  "Systolic blood pressure" = "systolic_bp"
)

ui <- page_sidebar(
  title = "Sex Differences Across the Lifespan (Simulated Data)",
  sidebar = sidebar(
    selectInput("outcome", "Outcome variable", choices = outcome_choices),
    checkboxInput("show_smooth", "Show trend line by sex", value = TRUE),
    sliderInput(
      "age_range", "Age range",
      min = floor(min(sim_data$age)), max = ceiling(max(sim_data$age)),
      value = c(floor(min(sim_data$age)), ceiling(max(sim_data$age)))
    ),
    hr(),
    p(
      "Data are simulated for demonstration purposes and do not represent",
      "real measurements.",
      class = "text-muted small"
    )
  ),
  card(
    card_header(
      "Outcome vs. age, by sex",
      span(
        HTML(
          '&#9679;&nbsp;Female &nbsp; <span style="color:orange;">&#9632;</span>&nbsp;Male'
        ),
        style = "float:right; font-weight:normal; color:purple;"
      )
    ),
    plotOutput("scatter_plot")
  ),
  card(
    card_header("Summary by sex"),
    tableOutput("summary_table")
  )
)

server <- function(input, output) {
  filtered_data <- reactive({
    sim_data |>
      filter(age >= input$age_range[1], age <= input$age_range[2])
  })

  output$scatter_plot <- renderPlot({
    outcome_label <- names(outcome_choices)[outcome_choices == input$outcome]

    p <- ggplot(filtered_data(), aes(x = age, y = .data[[input$outcome]], color = sex, shape = sex)) +
      geom_point(alpha = 0.5) +
      scale_color_manual(values = c(Female = "purple", Male = "orange")) +
      scale_shape_manual(values = c(Female = 16, Male = 15)) +
      labs(x = "Age", y = outcome_label, color = "Sex", shape = "Sex") +
      theme_minimal(base_size = 14)

    if (input$show_smooth) {
      p <- p + geom_smooth(method = "loess", se = TRUE)
    }

    p
  })

  sex_colors <- c(Female = "purple", Male = "orange")

  output$summary_table <- renderTable({
    filtered_data() |>
      group_by(Sex = sex) |>
      summarise(
        n = n(),
        Mean = mean(.data[[input$outcome]]),
        SD = sd(.data[[input$outcome]]),
        .groups = "drop"
      ) |>
      mutate(
        Sex = sprintf(
          '<span style="color:%s; font-weight:600;">%s</span>',
          sex_colors[Sex], Sex
        )
      )
  }, sanitize.text.function = identity)
}

shinyApp(ui = ui, server = server)
