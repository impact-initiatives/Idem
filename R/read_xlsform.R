#' Read an XLSForm file
#'
#' Reads an XLSForm `.xlsx` file from disk and returns an `xlsform` object — a
#' named list of tibbles (one per sheet) with the source file path stored as an
#' attribute. This is the standard entry point for working with XLSForms in
#' Idem.
#'
#' By default the `survey` and `choices` sheets are read, which cover the vast
#' majority of use cases. Pass additional sheet names (e.g.
#' `"external_choices"`, `"settings"`) via `sheets` when you need them.
#'
#' @param path Path to the `.xlsx` file.
#' @param sheets Character vector of sheet names to read. Must all be present in
#'   the workbook. Defaults to `c("survey", "choices")`.
#'
#' @return An `xlsform` object: a named list of tibbles, one per requested
#'   sheet, with a `path` attribute holding the source file path and class
#'   `c("xlsform", "list")`.
#'
#' @seealso [xlsform()] to construct an `xlsform` object from in-memory data
#'   frames.
#'
#' @importFrom stats setNames
#'
#' @export
#'
#' @examples
#' path <- system.file("extdata/form.xlsx", package = "Idem")
#'
#' # Read the default sheets (survey + choices)
#' form <- read_xlsform(path)
#' form
#'
#' # Inspect the survey sheet directly
#' form$survey
#'
#' # Read only the survey sheet
#' read_xlsform(path, sheets = "survey")
read_xlsform <- function(
  path,
  sheets = c("survey", "choices")
) {
  xlsform_sheets <- readxl::excel_sheets(path)

  missing_sheets <- sheets[!sheets %in% xlsform_sheets]
  if (length(missing_sheets) > 0) {
    cli::cli_abort(c(
      "{length(missing_sheets)} sheet{?s} not found in {.path {path}}.",
      "x" = "Missing: {.val {missing_sheets}}",
      "i" = "{length(xlsform_sheets)} available sheet{?s}: {.val {xlsform_sheets}}"
    ))
  }

  data <- purrr::map(.x = sheets, .f = \(sheet) {
    readxl::read_excel(path, sheet = sheet)
  }) |>
    setNames(sheets)

  structure(data, path = path, class = c("xlsform", "list"))
}
