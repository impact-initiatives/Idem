devtools::load_all()
path <- system.file("extdata/form.xlsx", package = "idem")
trim_path <- here::here("inst/extdata/trim_form.xlsx")

survey <- readxl::read_excel(path, sheet = "survey") |>
  dplyr::filter(req == 1)
choices <- readxl::read_excel(path, sheet = "choices")

wb <- list(
  "survey" = survey,
  "choices" = choices
)

openxlsx2::write_xlsx(wb, file = trim_path, overwrite = TRUE, na = "")
