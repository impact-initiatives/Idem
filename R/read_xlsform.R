#' Read an XLSForm file
#'
#' Reads an XLSForm `.xlsx` file from disk and returns an `xlsform` object — a
#' named list of tibbles (one per sheet) with the source file path stored as an
#' attribute. This is the standard entry point for working with XLSForms in
#' idem.
#'
#' By default the `survey` and `choices` sheets are required. Pass additional
#' sheet names (e.g. `"external_choices"`) via `required_sheets`, or request
#' sheets that may not be present (e.g. `"settings"`) via `optional_sheets`.
#'
#' @param path Path to the `.xlsx` file.
#' @param required_sheets Character vector of sheet names that must be present
#'   in the workbook. Defaults to `c("survey", "choices")`. An absent required
#'   sheet is an error.
#' @param optional_sheets Character vector of sheet names to read if present.
#'   Defaults to `character()`. An absent optional sheet produces a warning and
#'   is silently excluded from the returned object.
#'
#' @return An `xlsform` object: a named list of tibbles, one per sheet
#'   successfully read, with a `path` attribute holding the source file path and
#'   class `c("xlsform", "list")`.
#'
#' @seealso [xlsform()] to construct an `xlsform` object from in-memory data
#'   frames.
#'
#' @importFrom stats setNames
#'
#' @export
#'
#' @examples
#' path <- system.file("extdata/form.xlsx", package = "idem")
#'
#' # Read the default sheets (survey + choices)
#' form <- read_xlsform(path)
#' form
#'
#' # Inspect the survey sheet directly
#' form$survey
#'
#' # Opportunistically read the settings sheet (no error if absent)
#' read_xlsform(path, optional_sheets = "settings")
read_xlsform <- function(
  path,
  required_sheets = c("survey", "choices"),
  optional_sheets = character()
) {
  xlsform_sheets <- readxl::excel_sheets(path)

  missing_required <- required_sheets[!required_sheets %in% xlsform_sheets]
  if (length(missing_required) > 0) {
    cli::cli_abort(c(
      "{length(missing_required)} required sheet{?s} not found in
      {.path {path}}.",
      "x" = "Missing: {.val {missing_required}}",
      "i" = "{length(xlsform_sheets)} available sheet{?s}:
      {.val {xlsform_sheets}}"
    ))
  }

  missing_optional <- optional_sheets[!optional_sheets %in% xlsform_sheets]
  if (length(missing_optional) > 0) {
    cli::cli_warn(c(
      "{length(missing_optional)} optional sheet{?s} not found in
      {.path {path}}.",
      "!" = "Excluded: {.val {missing_optional}}"
    ))
  }

  sheets_to_read <- c(
    required_sheets,
    optional_sheets[optional_sheets %in% xlsform_sheets]
  )

  data <- purrr::map(.x = sheets_to_read, .f = \(sheet) {
    readxl::read_excel(path, sheet = sheet)
  }) |>
    setNames(sheets_to_read)

  structure(data, path = path, class = c("xlsform", "list"))
}
