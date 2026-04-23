devtools::load_all()
library(stringr)

path <- system.file("extdata/form.xlsx", package = "idem")
trim_path <- here::here("inst/extdata/trim_form.xlsx")

survey_complete <- readxl::read_excel(path, sheet = "survey")

survey <- readxl::read_excel(path, sheet = "survey") |>
  dplyr::filter(req == 1)

complete_names <- survey_complete$name |>
  na.omit() |>
  unique()

required_names <- survey$name |>
  na.omit() |>
  unique()

potential_other <- stringr::str_c("other_", required_names) |>
  intersect(complete_names)


setdiff(potential_other, required_names)
