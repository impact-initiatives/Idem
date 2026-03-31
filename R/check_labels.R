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
#' **Bare column (error)** -- A translatable field is present as a plain
#' column with no language suffix (e.g. `label`, `hint`, `image`). The column
#' must be renamed to use an explicit language tag such as
#' `label::English (en)`. Applies to `label` in both the `survey` and
#' `choices` sheets; applies to all other fields in `survey` only.
#'
#' **Malformed translation column (error)** -- A column looks like a
#' translation attempt (starts with a recognised field prefix followed by `:`
#' or `::`) but does not follow the `field::Language (code)` convention.
#' Common causes: missing parenthesised ISO code (e.g. `label::English`),
#' uppercase code (e.g. `label::French (FR)`), or a single-colon separator
#' (e.g. `label:Kreyol`). The code inside the parentheses must be a lowercase
#' IANA language subtag. Applies to `label` in both the `survey` and `choices`
#' sheets; applies to all other fields in `survey` only.
#'
#' **Survey-choices label language mismatch (error)** -- The set of languages
#' declared on `label` columns in the `survey` sheet must exactly match the
#' set declared on `label` columns in the `choices` sheet. Any language
#' present in one sheet but absent from the other is an error. This check is
#' skipped when the form has no `choices` sheet.
#'
#' **Non-label field language mismatch (error)** -- A non-`label` translatable
#' field in the `survey` sheet (e.g. `hint`, `constraint_message`) is declared
#' with a language that was not declared for any `label` column in `survey`.
#' The languages detected on survey `label` columns form the reference set.
#'
#' **Missing `default_language` (warning)** -- When a form declares more than
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
#' form <- read_xlsform(
#'   system.file("extdata/form.xlsx", package = "idem"),
#'   optional_sheets = "settings"
#' )
#' check_labels(form)
#'
#' # Bare label column (no language suffix) -- error
#' bare <- xlsform(
#'   survey = tibble::tibble(
#'     type  = "text",
#'     name  = "q1",
#'     label = "What is your name?"
#'   )
#' )
#' check_labels(bare)
#'
#' # Malformed translation attempt (missing ISO code) -- error
#' malformed <- xlsform(
#'   survey = tibble::tibble(
#'     type             = "text",
#'     name             = "q1",
#'     `label::English` = "What is your name?"
#'   )
#' )
#' check_labels(malformed)
#'
#' # Language mismatch: hint in Spanish but label only in English -- error
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
  purrr::list_rbind(list(
    .check_labels_malformed(x),
    .check_labels_survey_choices_sym(x),
    .check_labels_nonlabel_mismatch(x),
    .check_labels_default_language(x)
  ))
}

#' Check A: bare or malformed translation columns
#'
#' Detects columns in the `survey` sheet (all translatable fields) and the
#' `choices` sheet (`label` only) that look like a translation attempt but do
#' not follow the `field::Language (code)` convention.
#'
#' @param x An `xlsform` object.
#' @return A 5-column tibble of errors; zero rows when no issues are found.
#' @keywords internal
#' @export
.check_labels_malformed <- function(x) {
  empty <- .empty_check_tibble()

  field_prefix_pattern <- paste0(
    "^(",
    paste(translatable_fields, collapse = "|"),
    ")"
  )

  sheets_to_check <- intersect(c("survey", "choices"), names(x))

  purrr::map(
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
          "'",
          bad_cols,
          "' is a bare field with no language suffix.",
          " Use a translated column instead, e.g. '",
          field,
          "::English (en)'."
        ),
        paste0(
          "'",
          bad_cols,
          "' is not a valid translated column.",
          " Expected '",
          field,
          "::Language (code)', e.g. '",
          field,
          "::English (en)'."
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
}

#' Check B: survey ↔ choices label language symmetry
#'
#' The set of languages declared on `label` columns in the `survey` sheet must
#' exactly match the set on `label` columns in the `choices` sheet. This check
#' is skipped when the form has no `choices` sheet.
#'
#' @param x An `xlsform` object.
#' @return A 5-column tibble of errors; zero rows when no issues are found.
#' @keywords internal
#' @export
# nolint start: object_length_linter, line_length_linter.
.check_labels_survey_choices_sym <- function(x) {
  # nolint end
  translations <- xlsform_translations(x)
  survey_translations <- translations[translations$sheet == "survey", ]
  choices_translations <- translations[translations$sheet == "choices", ]

  survey_label_langs <- unique(
    survey_translations$language[survey_translations$field == "label"]
  )

  if (!("choices" %in% names(x)) || length(survey_label_langs) == 0L) {
    return(.empty_check_tibble())
  }

  choices_label_langs <- unique(
    choices_translations$language[choices_translations$field == "label"]
  )

  only_in_survey <- setdiff(survey_label_langs, choices_label_langs)
  only_in_choices <- setdiff(choices_label_langs, survey_label_langs)

  sym_rows <- c(
    if (length(only_in_survey) > 0L) {
      paste0(
        "Language '",
        only_in_survey,
        "' is declared on survey label columns",
        " but not on choices label columns."
      )
    },
    if (length(only_in_choices) > 0L) {
      paste0(
        "Language '",
        only_in_choices,
        "' is declared on choices label columns",
        " but not on survey label columns."
      )
    }
  )

  if (length(sym_rows) == 0L) {
    return(.empty_check_tibble())
  }

  tibble::tibble(
    check = "labels",
    severity = "error",
    name = NA_character_,
    list_name = NA_character_,
    detail = sym_rows
  )
}

#' Check C: non-label field language mismatch
#'
#' Languages declared on survey `label` columns form the reference set. Any
#' other translatable field in `survey` (e.g. `hint`, `constraint_message`)
#' that uses a language outside that set is an error.
#'
#' @param x An `xlsform` object.
#' @return A 5-column tibble of errors; zero rows when no issues are found.
#' @keywords internal
#' @export
# nolint start: object_length_linter.
.check_labels_nonlabel_mismatch <- function(x) {
  # nolint end
  translations <- xlsform_translations(x)
  survey_translations <- translations[translations$sheet == "survey", ]

  survey_label_langs <- unique(
    survey_translations$language[survey_translations$field == "label"]
  )

  non_label <- survey_translations[survey_translations$field != "label", ]

  if (length(survey_label_langs) == 0L || nrow(non_label) == 0L) {
    return(.empty_check_tibble())
  }

  mismatched <- non_label[!non_label$language %in% survey_label_langs, ]

  if (nrow(mismatched) == 0L) {
    return(.empty_check_tibble())
  }

  label_langs_fmt <- paste(
    paste0("'", survey_label_langs, "'"),
    collapse = ", "
  )

  tibble::tibble(
    check = "labels",
    severity = "error",
    name = mismatched$field,
    list_name = NA_character_,
    detail = paste0(
      "'",
      mismatched$column,
      "' uses language '",
      mismatched$language,
      "' which is not declared on any survey label column",
      " (declared: ",
      label_langs_fmt,
      ")."
    )
  )
}

#' Check D: missing default_language
#'
#' When a form declares more than one label language, XLSForm best practice
#' requires a `default_language` entry in the `settings` sheet. This check
#' fires when that entry is absent, `NA`, or empty.
#'
#' @param x An `xlsform` object.
#' @return A 5-column tibble with one warning row, or zero rows when no issue
#'   is found.
#' @keywords internal
#' @export
.check_labels_default_language <- function(x) {
  translations <- xlsform_translations(x)
  survey_translations <- translations[translations$sheet == "survey", ]

  survey_label_langs <- unique(
    survey_translations$language[survey_translations$field == "label"]
  )

  if (length(survey_label_langs) <= 1L) {
    return(.empty_check_tibble())
  }

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

  if (has_default) {
    return(.empty_check_tibble())
  }

  langs_fmt <- paste(
    paste0("'", survey_label_langs, "'"),
    collapse = ", "
  )

  tibble::tibble(
    check = "labels",
    severity = "warning",
    name = NA_character_,
    list_name = NA_character_,
    detail = paste0(
      "Form has ",
      length(survey_label_langs),
      " label languages (",
      langs_fmt,
      ") but no 'default_language' is set in the settings sheet."
    )
  )
}


.empty_check_tibble <- function() {
  tibble::tibble(
    check = character(),
    severity = character(),
    name = character(),
    list_name = character(),
    detail = character()
  )
}
