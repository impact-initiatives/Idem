#' Construct an xlsform object from data frames
#'
#' Builds an `xlsform` object directly from in-memory data frames, without
#' reading from a file. The resulting object is structurally identical to one
#' produced by [read_xlsform()], making it useful for testing, creating minimal
#' reproducible examples, or programmatically assembling forms.
#'
#' Most Idem functions expect at least a `survey` sheet and, for choice-related
#' operations, a `choices` sheet.
#'
#' @param ... Named data frames, one per sheet. Names become the sheet names
#'   (e.g. `survey =`, `choices =`). All arguments must be named and must be
#'   data frames.
#' @param path A string recording the (notional) source path. Defaults to
#'   `NA_character_` for in-memory objects.
#'
#' @return An `xlsform` object: a named list of data frames with class
#'   `c("xlsform", "list")` and a `path` attribute.
#'
#' @seealso [read_xlsform()] to load an `xlsform` object from an `.xlsx` file.
#'
#' @export
#'
#' @examples
#' # Minimal form with two select_one questions sharing a yes/no list
#' survey <- data.frame(
#'   type = c("select_one yn", "select_one yn", "text"),
#'   name = c("consent", "satisfied", "comments")
#' )
#' choices <- data.frame(
#'   list_name = c("yn", "yn"),
#'   name      = c("yes", "no"),
#'   label     = c("Yes", "No")
#' )
#' form <- xlsform(survey = survey, choices = choices)
#' form
#'
#' # In-memory forms can be passed directly to validate_xlsform()
#' validate_xlsform(form, form)
xlsform <- function(..., path = NA_character_) {
  sheets <- list(...)

  if (length(sheets) == 0L) {
    cli::cli_abort("At least one sheet must be provided.")
  }

  sheet_names <- names(sheets)
  if (is.null(sheet_names) || any(sheet_names == "")) {
    cli::cli_abort("All sheets must be named.")
  }

  not_df <- !purrr::map_lgl(.x = sheets, .f = is.data.frame)
  if (any(not_df)) {
    cli::cli_abort(c(
      "All sheets must be data frames.",
      "x" = "Not a data frame: {.val {sheet_names[not_df]}}"
    ))
  }

  structure(sheets, path = path, class = c("xlsform", "list"))
}
