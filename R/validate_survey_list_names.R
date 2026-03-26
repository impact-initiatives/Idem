#' Validate survey-referenced list names between two XLSForms
#'
#' Checks that every list name *referenced* in `target`'s survey questions is
#' also referenced in `dev`'s survey questions. Returns a tibble row for each
#' list name actively used by `target`'s survey that is absent from `dev`'s
#' survey.
#'
#' ## How it differs from `validate_list_names()`
#'
#' [validate_list_names()] compares the lists *defined* in each form's choices
#' sheet. `validate_survey_list_names()` compares the lists actively *used* by
#' survey questions — the second token in `type` values like
#' `select_one list_a`.
#'
#' The two checks are complementary. A list can be defined in choices but
#' never used in the survey (orphaned list), or — after a question type change
#' from `select_one list_a` to `text` — it may still be defined in choices
#' while no longer referenced in any survey question. This check surfaces the
#' latter case.
#'
#' @param target An `xlsform` object representing the authoritative reference
#'   form.
#' @param dev An `xlsform` object representing the form being validated.
#'
#' @return A tibble with columns `check`, `severity`, `name`, `list_name`, and
#'   `detail`. Has zero rows when all list names referenced by `target`'s survey
#'   are also referenced by `dev`'s survey.
#'
#' @seealso [validate_xlsform()] to run all checks together;
#'   [validate_list_names()] for the complementary choices-side check;
#'   [xlsform_list_names()] to extract referenced list names from a form.
#'
#' @export
#'
#' @examples
#' target <- read_xlsform(system.file("extdata/form.xlsx", package = "Idem"))
#'
#' # No issues: all lists target's survey uses are also used in dev's survey
#' validate_survey_list_names(target, target)
#'
#' # Issues found: dev's survey has all select questions replaced by text,
#' # so none of target's referenced lists appear in dev's survey
#' dev_no_selects <- xlsform(
#'   survey = data.frame(
#'     type = rep("text", nrow(target$survey)),
#'     name = target$survey$name
#'   ),
#'   choices = target$choices
#' )
#' validate_survey_list_names(target, dev_no_selects)
validate_survey_list_names <- function(target, dev) {
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
    xlsform_list_names(target),
    xlsform_list_names(dev)
  )

  tibble::tibble(
    check = "survey_list_names",
    severity = "error",
    name = missing,
    list_name = NA_character_,
    detail = paste0(
      "List '", missing,
      "' is referenced in target's survey but not in dev's survey."
    )
  )
}
