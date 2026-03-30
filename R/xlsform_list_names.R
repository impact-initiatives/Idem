#' Get list names referenced in an XLSForm's survey sheet
#'
#' Extracts the unique list names that are actively *referenced* in the `type`
#' column of the `survey` sheet — that is, the second space-separated token for
#' question types that link to a choices list:
#'
#' | Question type | Example type value | Extracted list name |
#' |---|---|---|
#' | `select_one` | `select_one yn` | `yn` |
#' | `select_multiple` | `select_multiple colors` | `colors` |
#' | `select_one_external` | `select_one_external regions` | `regions` |
#' | `select_multiple_external` | `select_multiple_external items` | `items` |
#' | `rank` | `rank priority` | `priority` |
#'
#' `select_one_from_file` and `select_multiple_from_file` are excluded because
#' they reference external CSV/XML/GeoJSON files rather than any in-workbook
#' choices sheet.
#'
#' @param x An `xlsform` object.
#' @param ... Ignored; present for S3 method compatibility.
#'
#' @return A character vector of unique list names referenced in the survey.
#'
#' @seealso [xlsform_choices_list_names()] for list names *defined* in the
#'   choices sheet; [validate_survey_list_names()] to compare referenced lists
#'   across two forms.
#'
#' @export
#'
#' @examples
#' form <- read_xlsform(system.file("extdata/form.xlsx", package = "idem"))
#'
#' # Lists actively used by survey questions
#' xlsform_list_names(form)
#'
#' # Compare with lists defined in the choices sheet
#' xlsform_choices_list_names(form)
xlsform_list_names <- function(x, ...) {
  UseMethod("xlsform_list_names")
}

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
  list_referencing_types <- c(
    "select_one",
    "select_multiple",
    "select_one_external",
    "select_multiple_external",
    "rank"
  )

  separated <- tidyr::separate_wider_delim(
    x$survey[, "type", drop = FALSE],
    cols = "type",
    delim = " ",
    names = c("type_prefix", "list_name"),
    too_few = "align_start",
    too_many = "drop"
  )

  list_names <- separated[["list_name"]][
    separated[["type_prefix"]] %in%
      list_referencing_types &
      !is.na(separated[["list_name"]])
  ]

  unique(list_names)
}
