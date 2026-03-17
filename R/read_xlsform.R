#' Read an XLSForm file
#'
#' Reads specified sheets from an XLSForm `.xlsx` file and returns them as an
#' `xlsform` object — a named list of tibbles with the file path recorded as an
#' attribute.
#'
#' @param path Path to the `.xlsx` file.
#' @param sheets Character vector of sheet names to read. Defaults to
#'   `c("survey", "choices")`.
#'
#' @return An `xlsform` object: a named list of tibbles, one per sheet, with a
#'   `path` attribute holding the source file path.
#'
#' @export
#'
#' @examples
#' xlsform <- read_xlsform(system.file("extdata/form.xlsx", package = "Idem"))
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
