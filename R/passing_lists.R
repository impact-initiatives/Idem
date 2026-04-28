#' Default list names skipped by [validate_choices()]
#'
#' A character vector of XLSForm list names whose choice options are expected
#' to differ between forms (admin boundaries, cluster IDs, enumerator IDs).
#' Used as the default for the `passing_lists` argument of
#' [validate_choices()] and [validate_xlsform()].
#'
#' @examples
#' idem_passing_lists
#' @export
idem_passing_lists <- c(
  "l_admin1",
  "l_admin2",
  "l_admin3",
  "l_enum_id"
)
