#' Get question names from an XLSForm
#'
#' Returns the `name` column of the `survey` sheet, excluding rows where
#' `name` is `NA`.
#'
#' @param x An `xlsform` object.
#' @param ... Ignored; present for S3 method compatibility.
#'
#' @return A character vector of question names.
#'
#' @export
#'
#' @examples
#' xlsform <- read_xlsform(system.file("extdata/form.xlsx", package = "Idem"))
#' xlsform_questions(xlsform)
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
