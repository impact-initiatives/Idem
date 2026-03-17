#' @export
print.xlsform <- function(x, ...) {
  cli::cli_text("{.cls xlsform} {.path {attr(x, 'path')}}")
  cli::cli_ul()
  purrr::walk(.x = names(x), .f = \(sheet) {
    cli::cli_li("{.field {sheet}}: {nrow(x[[sheet]])} row{?s}")
  })
  cli::cli_end()
  invisible(x)
}
