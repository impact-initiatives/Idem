#' Get list names defined in the choices sheets of an XLSForm
#'
#' Extracts unique list names from the `list_name` column of all available
#' in-workbook choices sheets. Two sheets are recognised:
#'
#' - `choices` — the standard sheet used by `select_one`, `select_multiple`,
#'   and `rank`.
#' - `external_choices` — the optional sheet used by `select_one_external` and
#'   `select_multiple_external`. Included automatically when present in the
#'   loaded form.
#'
#' ## Note on file-based question types
#'
#' `select_one_from_file` and `select_multiple_from_file` reference external
#' CSV/XML/GeoJSON files rather than any in-workbook sheet. This function cannot
#' resolve those references and emits a warning for each such type it encounters.
#'
#' ## Difference from `xlsform_referenced_list_names()`
#'
#' [xlsform_referenced_list_names()] returns lists *referenced* by survey
#' questions;
#' `xlsform_defined_list_names()` returns lists *defined* in the choices sheets.
#' The two sets should match for a well-formed form, but can diverge when a
#' question type is changed without updating the choices sheet (or vice versa).
#'
#' @param x An `xlsform` object.
#' @param ... Ignored; present for S3 method compatibility.
#'
#' @return A character vector of unique list names drawn from all available
#'   in-workbook choices sheets.
#'
#' @seealso [xlsform_referenced_list_names()] for list names referenced in the
#'   survey sheet; [xlsform_choices()] for the full choice options per list;
#'   [validate_list_names()] to compare defined lists across two forms.
#'
#' @export
#'
#' @examples
#' form <- read_xlsform(system.file("extdata/form.xlsx", package = "idem"))
#'
#' # All list names defined in the choices sheet
#' xlsform_defined_list_names(form)
#'
#' # Cross-check: lists defined in choices vs. lists used in survey
#' # (both should be identical for a well-formed form)
#' all.equal(
#'   sort(xlsform_defined_list_names(form)),
#'   sort(xlsform_referenced_list_names(form))
#' )
xlsform_defined_list_names <- function(x, ...) {
  UseMethod("xlsform_defined_list_names")
}

#' @export
#' @rdname xlsform_defined_list_names
xlsform_defined_list_names.default <- function(x, ...) {
  cli::cli_abort(
    "{.arg x} must be an {.cls xlsform} object, not {.obj_type_friendly {x}}."
  )
}

#' @export
#' @rdname xlsform_defined_list_names
xlsform_defined_list_names.xlsform <- function(x, ...) {
  from_file_types <- c("select_one_from_file", "select_multiple_from_file")
  from_file_used <- x$survey$type[
    !is.na(x$survey$type) &
      stringr::str_extract(x$survey$type, "^\\S+") %in% from_file_types
  ]
  if (length(from_file_used) > 0) {
    cli::cli_warn(c(
      "Some question types reference external files and are not handled by \\
      {.fn xlsform_defined_list_names}.",
      "i" = "Unhandled type{?s}: {.val {unique(from_file_used)}}"
    ))
  }

  choices_sheets <- intersect(c("choices", "external_choices"), names(x))

  list_names <- purrr::map(.x = choices_sheets, .f = \(sheet) {
    x[[sheet]][["list_name"]]
  }) |>
    unlist()

  unique(list_names[!is.na(list_names)])
}
