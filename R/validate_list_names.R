#' Validate defined list names between two XLSForms
#'
#' Checks that every list name *defined* in `target`'s choices sheet also
#' exists as a defined list in `dev`'s choices sheet. Returns a tibble row for
#' each list name present in `target`'s choices but absent from `dev`'s choices.
#'
#' ## Relationship to other checks
#'
#' This check is a prerequisite for [validate_choices()]: because
#' [validate_choices()] only compares options for lists that exist in *both*
#' forms' choices sheets, any list that `target` defines but `dev` omits would
#' be silently skipped. `validate_list_names()` catches those gaps explicitly.
#'
#' To verify that the same lists are also actively *used* in both forms' survey
#' questions (not just defined in choices), see [validate_survey_list_names()].
#'
#' @param target An `xlsform` object representing the authoritative reference
#'   form.
#' @param dev An `xlsform` object representing the form being validated.
#'
#' @return A tibble with columns `check`, `severity`, `name`, `list_name`, and
#'   `detail`. Has zero rows when all list names defined in `target`'s choices
#'   are also defined in `dev`'s choices.
#'
#' @seealso [validate_xlsform()] to run all checks together;
#'   [validate_survey_list_names()] for the complementary survey-side check;
#'   [xlsform_defined_list_names()] to extract defined list names from a form.
#'
#' @export
#'
#' @examples
#' target <- read_xlsform(system.file("extdata/form.xlsx", package = "idem"))
#'
#' # No issues: all lists defined in target's choices are also defined in dev
#' validate_list_names(target, target)
#'
#' # Issues found: dev has no choice lists at all, but target defines some
#' dev_empty_choices <- xlsform(
#'   survey  = target$survey,
#'   choices = data.frame(list_name = character(), name = character())
#' )
#' validate_list_names(target, dev_empty_choices)
validate_list_names <- function(target, dev) {
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

  missing <- setdiff(
    xlsform_defined_list_names(target),
    xlsform_defined_list_names(dev)
  )

  tibble::tibble(
    check = "list_names",
    severity = "error",
    name = missing,
    list_name = NA_character_,
    detail = paste0(
      "List '",
      missing,
      "' is defined in target's choices",
      " but not in dev's choices."
    )
  )
}
