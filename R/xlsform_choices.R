#' Get choice options from an XLSForm
#'
#' Returns a named list of character vectors, where each name is a list name and
#' each element contains the choice option `name` values for that list. Both the
#' `choices` sheet and, when present, the `external_choices` sheet are combined.
#'
#' This is useful for inspecting which options are available for a given
#' `select_one` or `select_multiple` question, and is used internally by
#' [validate_choices()] to compare option sets across two forms.
#'
#' @param x An `xlsform` object.
#' @param ... Ignored; present for S3 method compatibility.
#'
#' @return A named list of character vectors. Each name is a list name; each
#'   element is the character vector of option `name` values for that list. Rows
#'   with `NA` in either `list_name` or `name` are silently dropped.
#'
#' @seealso [xlsform_defined_list_names()] for just the list names;
#'   [validate_choices()] to compare choice options across two forms.
#'
#' @export
#'
#' @examples
#' form <- read_xlsform(system.file("extdata/form.xlsx", package = "idem"))
#'
#' # All choice options, organised by list name
#' xlsform_choices(form)
#'
#' # Options for a specific list
#' xlsform_choices(form)[["yn"]]
xlsform_choices <- function(x, ...) {
  UseMethod("xlsform_choices")
}

#' @export
#' @rdname xlsform_choices
xlsform_choices.default <- function(x, ...) {
  cli::cli_abort(
    "{.arg x} must be an {.cls xlsform} object, not {.obj_type_friendly {x}}."
  )
}

#' @export
#' @rdname xlsform_choices
xlsform_choices.xlsform <- function(x, ...) {
  choices_sheets <- intersect(c("choices", "external_choices"), names(x))

  combined <- purrr::map(.x = choices_sheets, .f = \(sheet) {
    x[[sheet]][, c("list_name", "name")]
  }) |>
    purrr::list_rbind()

  combined <- combined[!is.na(combined$list_name) & !is.na(combined$name), ]

  split(combined$name, combined$list_name)
}
