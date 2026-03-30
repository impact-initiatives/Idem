#' Translatable XLSForm fields
#'
#' A character vector of column name prefixes that support per-language
#' translations in XLSForm. Each field can be suffixed with a language tag
#' (e.g. `label::English (en)`, `hint::French (fr)`) following the
#' [XLSForm multiple language convention](
#' https://xlsform.org/en/#multiple-language-support).
#'
#' The parenthesised code at the end of the suffix (e.g. `en`, `fr`) should be
#' a valid IANA language subtag. The full registry is available at
#' <https://www.iana.org/assignments/language-subtag-registry>.
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
#' **Bare or malformed column (error)** — A translatable field is present
#' either as a plain column with no suffix (e.g. `label`, `hint`) or as a
#' malformed translation attempt that does not follow the
#' `field::Language (code)` convention (e.g. `label::English` without an ISO
#' code, `label::French (FR)` with an uppercase code, `label:Kreyol` with a
#' single colon). The user must use an explicitly language-tagged column such
#' as `label::English (en)`. Applies to `label` in both the `survey` and
#' `choices` sheets; applies to all other fields in `survey` only.
#'
#' **Survey–choices label language mismatch (error)** — The set of languages
#' declared on `label` columns in the `survey` sheet must exactly match the
#' set declared on `label` columns in the `choices` sheet. Any language
#' present in one sheet but absent from the other is an error. This check is
#' skipped when the form has no `choices` sheet.
#'
#' **Non-label field language mismatch (error)** — A non-`label` translatable
#' field in the `survey` sheet (e.g. `hint`, `constraint_message`) is declared
#' with a language that was not declared for any `label` column in `survey`.
#' The languages detected on survey `label` columns form the reference set.
#'
#' **Missing `default_language` (warning)** — When a form declares more than
#' one label language, XLSForm best practice requires a `default_language`
#' entry in the `settings` sheet so that data collection tools know which
#' translation to show by default. This warning fires when the `settings`
#' element is absent from the `xlsform` object, when it has no
#' `default_language` column, or when `default_language` is `NA` or empty.
#' To suppress the warning, load the form with
#' `read_xlsform(path, optional_sheets = "settings")` and ensure the
#' `settings` sheet contains a non-empty `default_language` value.
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
#' form <- read_xlsform(system.file("extdata/form.xlsx", package = "idem"))
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

  issues <- list()

  # ── Check A: bare or malformed translation columns ────────────────────────
  # Sheets to inspect: survey (all fields), choices (label only)
  sheets_to_check <- intersect(c("survey", "choices"), names(x))

  issues$malformed <- purrr::map(
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
      trimmed <- stringr::str_trim(bad_cols)
      field <- stringr::str_extract(trimmed, field_prefix_pattern)

      # Distinguish bare fields (exactly the field name) from malformed
      # translation attempts (field name followed by a colon).
      is_bare <- trimmed == field
      detail <- ifelse(
        is_bare,
        paste0(
          "\"",
          bad_cols,
          "\" is a bare field — use a language suffix, ",
          "e.g. ",
          field,
          "::English (en)"
        ),
        paste0(
          "\"",
          bad_cols,
          "\" is not a valid translated column — ",
          "expected ",
          field,
          "::Language (code), e.g. ",
          field,
          "::English (en)"
        )
      )

      tibble::tibble(
        check = "labels",
        severity = "error",
        name = field,
        list_name = NA_character_,
        detail = detail
      )
    }
  ) |>
    purrr::list_rbind()

  # ── Check B: survey ↔ choices label language symmetry ─────────────────────
  # The set of languages on label columns in survey must exactly match the set
  # on label columns in choices. This check is skipped when there is no
  # choices sheet.
  translations <- xlsform_translations(x)
  survey_translations <- translations[translations$sheet == "survey", ]
  choices_translations <- translations[translations$sheet == "choices", ]

  survey_label_langs <- unique(
    survey_translations$language[survey_translations$field == "label"]
  )

  if ("choices" %in% names(x) && length(survey_label_langs) > 0L) {
    choices_label_langs <- unique(
      choices_translations$language[choices_translations$field == "label"]
    )

    only_in_survey <- setdiff(survey_label_langs, choices_label_langs)
    only_in_choices <- setdiff(choices_label_langs, survey_label_langs)

    sym_rows <- c(
      if (length(only_in_survey) > 0L) {
        paste0(
          "Language \"",
          only_in_survey,
          "\" is declared on survey label columns but not on choices",
          " label columns"
        )
      },
      if (length(only_in_choices) > 0L) {
        paste0(
          "Language \"",
          only_in_choices,
          "\" is declared on choices label columns but not on survey",
          " label columns"
        )
      }
    )

    if (length(sym_rows) > 0L) {
      issues$sym <- tibble::tibble(
        check = "labels",
        severity = "error",
        name = NA_character_,
        list_name = NA_character_,
        detail = sym_rows
      )
    }
  }

  # ── Check C: non-label field language mismatch ────────────────────────────
  # Languages declared on survey label columns form the reference set.
  # Any other translatable field in survey using a language outside that set
  # is an error.
  non_label <- survey_translations[survey_translations$field != "label", ]

  if (length(survey_label_langs) > 0L && nrow(non_label) > 0L) {
    mismatched <- non_label[!non_label$language %in% survey_label_langs, ]

    if (nrow(mismatched) > 0L) {
      label_langs_fmt <- paste(
        paste0("\"", survey_label_langs, "\""),
        collapse = ", "
      )
      issues$mismatch <- tibble::tibble(
        check = "labels",
        severity = "error",
        name = mismatched$field,
        list_name = NA_character_,
        detail = paste0(
          "\"",
          mismatched$column,
          "\" uses language \"",
          mismatched$language,
          "\" not declared on any survey label column",
          " (declared: ",
          label_langs_fmt,
          ")"
        )
      )
    }
  }

  # ── Check D: missing default_language ────────────────────────────────────
  # Only fires when the form has more than one distinct label language.
  if (length(survey_label_langs) > 1L) {
    settings <- x[["settings"]]
    default_lang <- if (
      !is.null(settings) &&
        "default_language" %in% names(settings) &&
        nrow(settings) >= 1L &&
        length(settings[["default_language"]]) >= 1L
    ) {
      settings[["default_language"]][[1L]]
    } else {
      NA_character_
    }

    has_default <- !is.na(default_lang) &&
      nzchar(stringr::str_trim(default_lang))

    if (!has_default) {
      langs_fmt <- paste(
        paste0("\"", survey_label_langs, "\""),
        collapse = ", "
      )
      issues$default_lang <- tibble::tibble(
        check = "labels",
        severity = "warning",
        name = NA_character_,
        list_name = NA_character_,
        detail = paste0(
          "Form has ",
          length(survey_label_langs),
          " languages (",
          langs_fmt,
          ") but no default_language is set in the settings sheet"
        )
      )
    }
  }

  purrr::list_rbind(issues)
}
