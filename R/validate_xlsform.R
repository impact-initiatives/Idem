#' Validate an XLSForm against a reference form
#'
#' Runs one or more validation checks comparing a `dev` (work-in-progress)
#' XLSForm against a `target` (authoritative reference) XLSForm. The default
#' direction checks that everything present in `target` also exists in `dev`
#' — i.e., `target` is a valid subset of `dev`.
#'
#' This is the main entry point for form validation. It delegates to the
#' individual `validate_*()` functions and combines their results into a single
#' tibble.
#'
#' ## Available checks
#'
#' | Check name | What it tests |
#' |---|---|
#' | `"question_names"` | Every question name in `target` must exist in `dev`. |
#' | `"list_names"` | Every list name *defined* in `target`'s choices sheet must also be defined in `dev`'s choices sheet. |
#' | `"survey_list_names"` | Every list name *referenced* in `target`'s survey questions must also be referenced in `dev`'s survey questions. |
#' | `"choices"` | For every shared list, every choice option in `target` must exist in the same list in `dev`. |
#'
#' ## Return value structure
#'
#' Each row in the returned tibble represents one validation issue:
#'
#' | Column | Description |
#' |---|---|
#' | `check` | Which check produced this issue. |
#' | `severity` | Currently always `"error"`. |
#' | `name` | The name of the offending question or choice option. |
#' | `list_name` | The choices list involved (`NA` for question-level checks). |
#' | `detail` | A human-readable description of the problem. |
#'
#' @param target An `xlsform` object representing the authoritative reference
#'   form.
#' @param dev An `xlsform` object representing the form being validated.
#' @param checks A character vector of check names to run. Defaults to all
#'   four checks:
#'   `c("question_names", "list_names", "survey_list_names", "choices")`.
#'
#' @return A tibble with columns `check`, `severity`, `name`, `list_name`, and
#'   `detail`. Has zero rows when no issues are found.
#'
#' @seealso [validate_question_names()], [validate_list_names()],
#'   [validate_survey_list_names()], [validate_choices()] for the individual
#'   checks.
#'
#' @export
#'
#' @examples
#' target <- read_xlsform(system.file("extdata/form.xlsx", package = "idem"))
#'
#' # No issues: a form is always a valid subset of itself
#' validate_xlsform(target, target)
#'
#' # Run only a subset of checks
#' validate_xlsform(target, target, checks = c("question_names", "choices"))
#'
#' # Introduce issues: dev is missing a question and a choice option that
#' # target requires
#' dev_trimmed <- xlsform(
#'   survey  = target$survey[-nrow(target$survey), ],
#'   choices = target$choices[-nrow(target$choices), ]
#' )
#' issues <- validate_xlsform(target, dev_trimmed)
#' issues
validate_xlsform <- function(
  target,
  dev,
  checks = c("question_names", "list_names", "survey_list_names", "choices")
) {
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

  valid_checks <- c(
    "question_names",
    "list_names",
    "survey_list_names",
    "choices"
  )
  unknown <- setdiff(checks, valid_checks)
  if (length(unknown) > 0L) {
    cli::cli_abort(c(
      "Unknown check{?s}: {.val {unknown}}.",
      "i" = "Valid checks are: {.val {valid_checks}}."
    ))
  }

  checks <- match.arg(checks, valid_checks, several.ok = TRUE)

  runners <- list(
    question_names = validate_question_names,
    list_names = validate_list_names,
    survey_list_names = validate_survey_list_names,
    choices = validate_choices
  )

  results <- purrr::map(
    .x = checks,
    .f = \(check) runners[[check]](target, dev)
  ) |>
    purrr::list_rbind()

  if (nrow(results) == 0L) {
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
