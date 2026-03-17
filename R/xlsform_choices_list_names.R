#' Get list names defined in the choices sheets of an XLSForm
#'
#' Extracts unique list names from the `list_name` column of all available
#' in-workbook choices sheets. Two sheets are recognised:
#'
#' - `choices` — the standard sheet used by `select_one`, `select_multiple`,
#'   and `rank`.
#' - `external_choices` — the optional sheet used by `select_one_external` and
#'   `select_multiple_external` (database-backed fast external itemsets,
#'   compiled into `itemsets.csv` at form conversion time). Included
#'   automatically when present in the loaded form.
#'
#' Questions of type `select_one_from_file` or `select_multiple_from_file`
#' reference external CSV/XML/GeoJSON files rather than any in-workbook choices
#' sheet. These are not handled by this function; a warning is raised for each
#' such type encountered so the caller is aware.
#'
#' @param x An `xlsform` object.
#' @param ... Ignored; present for S3 method compatibility.
#'
#' @return A character vector of unique list names drawn from all available
#'   in-workbook choices sheets (`choices` and, if present, `external_choices`).
#'
#' @export
#'
#' @examples
#' xlsform <- read_xlsform(system.file("extdata/form.xlsx", package = "Idem"))
#' xlsform_choices_list_names(xlsform)
xlsform_choices_list_names <- function(x, ...) {
  UseMethod("xlsform_choices_list_names")
}

#' @export
#' @rdname xlsform_choices_list_names
xlsform_choices_list_names.default <- function(x, ...) {
  cli::cli_abort(
    "{.arg x} must be an {.cls xlsform} object, not {.obj_type_friendly {x}}."
  )
}

#' @export
#' @rdname xlsform_choices_list_names
xlsform_choices_list_names.xlsform <- function(x, ...) {
  from_file_types <- c("select_one_from_file", "select_multiple_from_file")
  from_file_used <- x$survey$type[
    !is.na(x$survey$type) &
      stringr::str_extract(x$survey$type, "^\\S+") %in% from_file_types
  ]
  if (length(from_file_used) > 0) {
    cli::cli_warn(c(
      "Some question types reference external files and are not handled by \\
      {.fn xlsform_choices_list_names}.",
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
