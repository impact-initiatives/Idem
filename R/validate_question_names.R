#' Validate question names between two XLSForms
#'
#' Checks that every question name present in `target`'s survey sheet also
#' exists in `dev`'s survey sheet. Returns a tibble row for each question
#' name found in `target` but absent from `dev`.
#'
#' This check catches situations where the authoritative `target` form contains
#' questions that the work-in-progress `dev` form has not yet included — for
#' example, a localised adaptation that dropped required questions, or a form
#' version that has fallen behind the central reference.
#'
#' @param target An `xlsform` object representing the authoritative reference
#'   form.
#' @param dev An `xlsform` object representing the form being validated.
#'
#' @return A tibble with columns `check`, `severity`, `name`, `list_name`, and
#'   `detail`. Has zero rows when all question names in `target` are present in
#'   `dev`.
#'
#' @seealso [validate_xlsform()] to run all checks together;
#'   [xlsform_questions()] to extract question names from a form.
#'
#' @export
#'
#' @examples
#' target <- read_xlsform(system.file("extdata/form.xlsx", package = "Idem"))
#'
#' # No issues: every question in target also exists in dev
#' validate_question_names(target, target)
#'
#' # Issues found: target has a question that dev is missing
#' extra_row <- target$survey[1L, ]
#' extra_row$name <- "required_question"
#' target_extra <- xlsform(
#'   survey  = rbind(target$survey, extra_row),
#'   choices = target$choices
#' )
#' validate_question_names(target_extra, target)
validate_question_names <- function(target, dev) {
  if (!inherits(target, "xlsform")) {
    cli::cli_abort(
      "{.arg target} must be an {.cls xlsform} object, not \\
      {.obj_type_friendly {target}}."
    )
  }
  if (!inherits(dev, "xlsform")) {
    cli::cli_abort(
      "{.arg dev} must be an {.cls xlsform} object, not \\
      {.obj_type_friendly {dev}}."
    )
  }

  missing <- setdiff(xlsform_questions(target), xlsform_questions(dev))

  tibble::tibble(
    check     = "question_names",
    severity  = "error",
    name      = missing,
    list_name = NA_character_,
    detail    = paste0(
      "Question '", missing, "' is present in target but not in dev."
    )
  )
}
