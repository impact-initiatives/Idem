#' Print an xlsform object
#'
#' Displays a summary of a loaded XLSForm: the source file path and, for each
#' sheet, its name and row count.
#'
#' @param x An `xlsform` object.
#' @param ... Ignored; present for S3 method compatibility.
#'
#' @return `x`, invisibly.
#'
#' @export
#'
#' @examples
#' xlsform <- read_xlsform(system.file("extdata/form.xlsx", package = "Idem"))
#' print(xlsform)
print.xlsform <- function(x, ...) {
  cli::cli_text("{.cls xlsform} {.path {attr(x, 'path')}}")
  cli::cli_ul()
  purrr::walk(.x = names(x), .f = \(sheet) {
    cli::cli_li("{.field {sheet}}: {nrow(x[[sheet]])} row{?s}")
  })
  cli::cli_end()
  invisible(x)
}
