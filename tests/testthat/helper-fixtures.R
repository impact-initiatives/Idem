fixture_xlsform <- function(
  survey_names = c("q1", "q2", "q3"),
  survey_types = c("select_one list_a", "select_one list_b", "text"),
  choice_lists = c("list_a", "list_a", "list_b", "list_b"),
  choice_names = c("opt1", "opt2", "opt3", "opt4")
) {
  xlsform(
    survey = tibble::tibble(type = survey_types, name = survey_names),
    choices = tibble::tibble(list_name = choice_lists, name = choice_names)
  )
}
