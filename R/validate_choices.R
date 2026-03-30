#' Validate choice options between two XLSForms
#'
#' For every list name that exists in *both* `target` and `dev`'s choices
#' sheets, checks that each choice option name present in `target` also exists
#' in `dev`. Returns a tibble row for each option found in `target` that is
#' absent from `dev` for the same list.
#'
#' ## Scope of this check
#'
#' This check only compares lists that are defined in *both* forms. Lists that
#' appear in `target` but are entirely absent from `dev` are not reported here
#' — use [validate_list_names()] to catch those gaps first.
#'
#' A typical validation workflow runs [validate_list_names()] before
#' `validate_choices()`, or simply calls [validate_xlsform()] which runs both.
#'
#' @param target An `xlsform` object representing the authoritative reference
#'   form.
#' @param dev An `xlsform` object representing the form being validated.
#'
#' @return A tibble with columns `check`, `severity`, `name`, `list_name`, and
#'   `detail`. Has zero rows when all choice options in `target` are present in
#'   `dev` for every shared list.
#'
#' @seealso [validate_xlsform()] to run all checks together;
#'   [validate_list_names()] for checking that lists themselves exist in `dev`;
#'   [xlsform_choices()] to extract choice options from a form.
#'
#' @export
#'
#' @examples
#' target <- read_xlsform(system.file("extdata/form.xlsx", package = "idem"))
#'
#' # No issues: all choice options in target also exist in dev
#' validate_choices(target, target)
#'
#' # Issues found: dev is missing the last choice option that target defines
#' dev_trimmed <- xlsform(
#'   survey  = target$survey,
#'   choices = target$choices[-nrow(target$choices), ]
#' )
#' validate_choices(target, dev_trimmed)
validate_choices <- function(target, dev) {
  if (!inherits(target, "xlsform")) {
    cli::cli_abort(
      "{.arg target} must be an {.cls xlsform} object, not \\
      {.obj_type_friendly {target}}."
    )
  }
  if (!inherits(dev, "xlsform")) {
    cli::cli_abort(
      "{.arg dev} must be an {.cls xlsform} object, not \\
      {.obj_type_friendly {dev}}."
    )
  }

  target_choices <- xlsform_choices(target)
  dev_choices <- xlsform_choices(dev)

  shared_lists <- intersect(names(target_choices), names(dev_choices))

  results <- purrr::map(.x = shared_lists, .f = \(list_nm) {
    missing_opts <- setdiff(target_choices[[list_nm]], dev_choices[[list_nm]])
    if (length(missing_opts) == 0L) {
      return(NULL)
    }
    tibble::tibble(
      check = "choices",
      severity = "error",
      name = missing_opts,
      list_name = list_nm,
      detail = paste0(
        "Choice '",
        missing_opts,
        "' in list '",
        list_nm,
        "' is present in target but not in dev."
      )
    )
  }) |>
    purrr::list_rbind()

  if (is.null(results) || nrow(results) == 0L) {
    return(tibble::tibble(
      check = character(),
      severity = character(),
      name = character(),
      list_name = character(),
      detail = character()
    ))
  }

  results
}
