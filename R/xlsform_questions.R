#' Get question names from an XLSForm
#'
#' Returns the values of the `name` column from the `survey` sheet, excluding
#' any rows where `name` is `NA` (such as `begin_group` / `end_group` rows that
#' carry no name).
#'
#' The returned vector is used internally by [validate_question_names()] to
#' compare question inventories across two forms.
#'
#' @param x An `xlsform` object.
#' @param ... Ignored; present for S3 method compatibility.
#'
#' @return A character vector of non-`NA` question names from the survey sheet.
#'
#' @seealso [xlsform_list_names()] for list names referenced in the survey;
#'   [xlsform_choices_list_names()] for list names defined in the choices sheet.
#'
#' @export
#'
#' @examples
#' form <- read_xlsform(system.file("extdata/form.xlsx", package = "idem"))
#'
#' # All question names in the form
#' xlsform_questions(form)
#'
#' # Count questions
#' length(xlsform_questions(form))
xlsform_questions <- function(x, ...) UseMethod("xlsform_questions")

#' @export
#' @rdname xlsform_questions
xlsform_questions.default <- function(x, ...) {
  cli::cli_abort(
    "{.arg x} must be an {.cls xlsform} object, not {.obj_type_friendly {x}}."
  )
}

#' @export
#' @rdname xlsform_questions
xlsform_questions.xlsform <- function(x, ...) {
  names <- x$survey$name
  names[!is.na(names)]
}
