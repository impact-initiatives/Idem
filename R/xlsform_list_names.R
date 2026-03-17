#' Get list names referenced in an XLSForm
#'
#' Extracts the unique list names referenced in the `type` column of the
#' `survey` sheet. List names are the second token (separated by a space) in
#' question types that reference a choices list: `select_one`,
#' `select_multiple`, and `rank`.
#'
#' `select_one_from_file` and `select_multiple_from_file` are excluded because
#' they reference external files, not lists defined in the `choices` sheet.
#'
#' @param x An `xlsform` object.
#' @param ... Ignored; present for S3 method compatibility.
#'
#' @return A character vector of unique list names.
#'
#' @export
#'
#' @examples
#' xlsform <- read_xlsform(system.file("extdata/form.xlsx", package = "Idem"))
#' xlsform_list_names(xlsform)
xlsform_list_names <- function(x, ...) UseMethod("xlsform_list_names")

#' @export
#' @rdname xlsform_list_names
xlsform_list_names.default <- function(x, ...) {
  cli::cli_abort(
    "{.arg x} must be an {.cls xlsform} object, not {.obj_type_friendly {x}}."
  )
}

#' @export
#' @rdname xlsform_list_names
xlsform_list_names.xlsform <- function(x, ...) {
  list_referencing_types <- c("select_one", "select_multiple", "rank")

  separated <- tidyr::separate_wider_delim(
    x$survey[, "type", drop = FALSE],
    cols = "type",
    delim = " ",
    names = c("type_prefix", "list_name"),
    too_few = "align_start",
    too_many = "drop"
  )

  list_names <- separated[["list_name"]][
    separated[["type_prefix"]] %in% list_referencing_types &
      !is.na(separated[["list_name"]])
  ]

  unique(list_names)
}
