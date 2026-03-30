#' Test whether a string is a valid translated field column name
#'
#' Checks whether a character string follows the XLSForm convention for a
#' translated column: a recognised [translatable_fields] prefix, followed by
#' `::`, a language name (which may contain non-ASCII characters), a single
#' space, and a parenthesised Latin alphabetic code, e.g.
#' `"label::English (en)"` or `"hint::Français (fr)"`.
#'
#' Leading and trailing whitespace is stripped before matching, so
#' `" label::English (en) "` is treated as a valid translated column name.
#'
#' The function is vectorised over `x`.
#'
#' @param x A character vector of column names to test.
#'
#' @return A logical vector the same length as `x`. `TRUE` where `x` matches
#'   the translated column pattern, `FALSE` otherwise.
#'
#' @seealso [translatable_fields], [xlsform_translations()]
#'
#' @noRd
is_translated_col <- function(x) {
  pattern <- paste0(
    "^(",
    paste(translatable_fields, collapse = "|"),
    ")::[^:]+\\s\\([a-z]+\\)$"
  )
  stringr::str_detect(stringr::str_trim(x), pattern)
}

#' Test whether a string is a malformed translated field column name
#'
#' Checks whether a character string looks like a translation attempt for a
#' [translatable_fields] prefix but does not conform to the valid XLSForm
#' convention (as detected internally). A column is considered a
#' malformed translation attempt when, after trimming whitespace, it either
#' exactly equals a translatable field (bare, e.g. `"label"`) or starts with
#' a translatable field followed immediately by a colon (single or double,
#' e.g. `"label:Kreyol"`, `"label::English"`, `"label::French (FR)"`).
#'
#' Columns that use other separators (e.g. `"label_analysis_var"`,
#' `"label.question"`) are **not** considered translation attempts and return
#' `FALSE`.
#'
#' The function is vectorised over `x`.
#'
#' @param x A character vector of column names to test.
#'
#' @return A logical vector the same length as `x`. `TRUE` where `x` looks
#'   like a malformed translation column, `FALSE` otherwise.
#'
#' @seealso [translatable_fields]
#'
#' @noRd
is_malformed_translation_col <- function(x) {
  partial_pattern <- paste0(
    "^(",
    paste(translatable_fields, collapse = "|"),
    ")($|:)"
  )
  trimmed <- stringr::str_trim(x)
  stringr::str_detect(trimmed, partial_pattern) & !is_translated_col(x)
}

#' Get declared translations from an XLSForm
#'
#' Scans the column names of the `survey` sheet (and the `choices` sheet when
#' present) for columns matching any [translatable_fields] prefix followed by a
#' `::language` suffix, e.g. `label::English (en)` or `hint::French (fr)`.
#' Returns a tidy tibble describing every translation found, one row per
#' field–language combination.
#'
#' A valid translated column name consists of a [translatable_fields] prefix,
#' `::`, a language name (which may contain non-ASCII characters), a single
#' space, and a parenthesised Latin alphabetic code — for example
#' `"label::English (en)"` or `"hint::Français (fr)"`. Columns that do not
#' follow this convention (bare `"label"`, `"label::English"` without a code,
#' `"label::Spanish(es)"` without a space) are not returned.
#'
#' Column names are trimmed of leading and trailing whitespace before matching,
#' so `" label::English (en) "` is treated identically to
#' `"label::English (en)"`.
#'
#' @param x An `xlsform` object.
#' @param ... Ignored; present for S3 method compatibility.
#'
#' @return A tibble with columns:
#' \describe{
#'   \item{sheet}{The sheet the column was found in (`"survey"` or
#'     `"choices"`).}
#'   \item{field}{The translatable field prefix (e.g. `"label"`, `"hint"`).}
#'   \item{language}{The language tag as written after `::` (e.g.
#'     `"English (en)"`, `"French (fr)"`).}
#'   \item{column}{The original (untrimmed) column name.}
#' }
#' Has zero rows when no translated columns are found.
#'
#' @seealso [translatable_fields] for the full list of recognised field
#'   prefixes; [check_labels()] for validation built on top of this accessor.
#'
#' @export
#'
#' @examples
#' form <- read_xlsform(system.file("extdata/form.xlsx", package = "Idem"))
#' xlsform_translations(form)
xlsform_translations <- function(x, ...) UseMethod("xlsform_translations")

#' @export
#' @rdname xlsform_translations
xlsform_translations.default <- function(x, ...) {
  cli::cli_abort(
    "{.arg x} must be an {.cls xlsform} object, not {.obj_type_friendly {x}}."
  )
}

#' @export
#' @rdname xlsform_translations
xlsform_translations.xlsform <- function(x, ...) {
  translatable_sheets <- intersect(c("survey", "choices"), names(x))

  field_prefix_pattern <- paste0(
    "^(",
    paste(translatable_fields, collapse = "|"),
    ")"
  )

  purrr::map(
    .x = translatable_sheets,
    .f = \(sheet) {
      cols <- names(x[[sheet]])
      matched <- is_translated_col(cols)

      if (!any(matched)) {
        return(tibble::tibble(
          sheet = character(),
          field = character(),
          language = character(),
          column = character()
        ))
      }

      matched_cols <- cols[matched]
      matched_trimmed <- stringr::str_trim(matched_cols)
      field <- stringr::str_extract(matched_trimmed, field_prefix_pattern)
      language <- stringr::str_remove(
        matched_trimmed,
        paste0(field_prefix_pattern, "::")
      )

      tibble::tibble(
        sheet = sheet,
        field = field,
        language = language,
        column = matched_cols
      )
    }
  ) |>
    purrr::list_rbind()
}
