# Simulate age x sex data for four outcomes: memory performance, speed test
# score, weight, and systolic blood pressure. Patterns are loosely based on
# typical aging trends (not fit to any real dataset) and are for
# demonstration purposes only.

library(tidyverse)

set.seed(7461)

n_per_group <- 300

ages <- runif(n_per_group * 2, min = 18, max = 110)
sex <- rep(c("Female", "Male"), each = n_per_group)

sim_data <- tibble(
  age = ages,
  sex = sex
) |>
  mutate(
    # Memory performance: declines with age; small female advantage
    memory_score = 100 +
      ifelse(sex == "Female", 3, 0) -
      0.35 * (age - 18) +
      rnorm(n(), sd = 8),

    # Speed test score (higher = faster/better): declines with age;
    # small male advantage on average
    speed_score = 90 +
      ifelse(sex == "Male", 4, 0) -
      0.45 * (age - 18) +
      rnorm(n(), sd = 7),

    # Weight (kg): men heavier on average; rises then plateaus with age
    weight_kg = ifelse(sex == "Male", 82, 68) +
      0.25 * pmin(age - 18, 40) +
      rnorm(n(), sd = 9),

    # Systolic blood pressure: rises with age; men higher until ~55,
    # then converges/slightly reverses (post-menopausal rise in women)
    systolic_bp = 110 +
      0.45 * (age - 18) +
      ifelse(sex == "Male" & age < 55, 6, 0) +
      ifelse(sex == "Female" & age >= 55, 5, 0) +
      rnorm(n(), sd = 8)
  ) |>
  mutate(across(c(memory_score, speed_score, weight_kg, systolic_bp), \(x) round(x, 1)),
         age = round(age, 1))

dir.create("data", showWarnings = FALSE)
write_csv(sim_data, "data/simulated_data.csv")
