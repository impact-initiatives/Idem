#' Translatable XLSForm fields
#'
#' A character vector of column name prefixes that support per-language
#' translations in XLSForm. Each field can be suffixed with a language tag
#' (e.g. `label::English (en)`, `hint::French (fr)`) following the
#' [XLSForm multiple language convention](
#' https://xlsform.org/en/#multiple-language-support).
#'
#' @examples
#' translatable_fields
#'
#' @export
translatable_fields <- c(
  "label",
  "hint",
  "guidance_hint",
  "constraint_message",
  "required_message",
  "image",
  "audio",
  "video"
)

#' Check translation consistency of an XLSForm
#'
#' Inspects the column names of the `survey` sheet (and the `choices` sheet for
#' `label`) to enforce that all [translatable_fields] are explicitly declared
#' with a language suffix and that the set of languages is consistent across
#' fields.
#'
#' Column matching is done after stripping leading and trailing whitespace from
#' column names, so `" label::English (en) "` is treated the same as
#' `"label::English (en)"`.
#'
#' ## Checks performed
#'
#' **Bare field (error)** — A translatable field is present as a plain column
#' (e.g. `label`, `hint`) with no `::language` suffix. The user must replace
#' it with an explicitly language-tagged column such as
#' `label::English (en)`. Applies to `label` in both the `survey` and
#' `choices` sheets; applies to all other fields in `survey` only.
#'
#' **Language mismatch (error)** — A non-`label` translatable field is
#' declared with a language that was not declared for `label`. For example,
#' if labels are declared in French and English but a `hint` column appears
#' in Spanish, that Spanish `hint` is an error. The languages detected on
#' `label` columns form the reference set.
#'
#' @param x An `xlsform` object as returned by [read_xlsform()] or
#'   [xlsform()].
#' @param ... Ignored; present for S3 method compatibility.
#'
#' @return A tibble with columns `check`, `severity`, `name`, `list_name`,
#'   and `detail`. Has zero rows when no issues are found.
#'
#' @seealso [translatable_fields] for the full list of field prefixes
#'   inspected; [validate_xlsform()] to run cross-form checks.
#'
#' @export
#'
#' @examples
#' # No issues: the fixture form uses valid translated columns throughout
#' form <- read_xlsform(system.file("extdata/form.xlsx", package = "Idem"))
#' check_labels(form)
#'
#' # Bare label column (no language suffix) — error
#' bare <- xlsform(
#'   survey = tibble::tibble(
#'     type  = "text",
#'     name  = "q1",
#'     label = "What is your name?"
#'   )
#' )
#' check_labels(bare)
#'
#' # Malformed translation attempt (missing ISO code) — error
#' malformed <- xlsform(
#'   survey = tibble::tibble(
#'     type             = "text",
#'     name             = "q1",
#'     `label::English` = "What is your name?"
#'   )
#' )
#' check_labels(malformed)
#'
#' # Language mismatch: hint in Spanish but label only in English — error
#' mismatch <- xlsform(
#'   survey = tibble::tibble(
#'     type                  = "text",
#'     name                  = "q1",
#'     `label::English (en)` = "What is your name?",
#'     `hint::Spanish (es)`  = "Tu nombre"
#'   )
#' )
#' check_labels(mismatch)
check_labels <- function(x, ...) UseMethod("check_labels")

#' @export
#' @rdname check_labels
check_labels.default <- function(x, ...) {
  cli::cli_abort(
    "{.arg x} must be an {.cls xlsform} object, not {.obj_type_friendly {x}}."
  )
}

#' @export
#' @rdname check_labels
check_labels.xlsform <- function(x, ...) {
  empty <- tibble::tibble(
    check = character(),
    severity = character(),
    name = character(),
    list_name = character(),
    detail = character()
  )

  field_prefix_pattern <- paste0(
    "^(",
    paste(translatable_fields, collapse = "|"),
    ")"
  )

  # ── Check A: malformed translation columns ────────────────────────────────
  # Sheets to inspect: survey (all fields), choices (label only)
  sheets_to_check <- intersect(c("survey", "choices"), names(x))

  malformed <- purrr::map(
    .x = sheets_to_check,
    .f = \(sheet) {
      cols <- names(x[[sheet]])
      is_mal <- is_malformed_translation_col(cols)

      if (sheet == "choices") {
        label_prefix <- paste0("^label($|:)")
        is_mal <- is_mal &
          stringr::str_detect(stringr::str_trim(cols), label_prefix)
      }

      if (!any(is_mal)) {
        return(empty)
      }

      bad_cols <- cols[is_mal]
      field <- stringr::str_extract(
        stringr::str_trim(bad_cols),
        field_prefix_pattern
      )

      tibble::tibble(
        check = "labels",
        severity = "error",
        name = field,
        list_name = NA_character_,
        detail = bad_cols
      )
    }
  ) |>
    purrr::list_rbind()

  # ── Check B: language mismatch ────────────────────────────────────────────
  # Languages declared on label columns (survey) form the reference set.
  # Any other translatable field using a language outside that set is an error.
  translations <- xlsform_translations(x)
  survey_translations <- translations[translations$sheet == "survey", ]

  label_languages <- unique(
    survey_translations$language[survey_translations$field == "label"]
  )

  non_label <- survey_translations[survey_translations$field != "label", ]

  if (length(label_languages) > 0L && nrow(non_label) > 0L) {
    mismatched <- non_label[!non_label$language %in% label_languages, ]

    if (nrow(mismatched) > 0L) {
      mismatch_rows <- tibble::tibble(
        check = "labels",
        severity = "error",
        name = mismatched$field,
        list_name = NA_character_,
        detail = mismatched$column
      )
      return(purrr::list_rbind(list(malformed, mismatch_rows)))
    }
  }

  malformed
}
