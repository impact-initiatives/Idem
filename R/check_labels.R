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
#' (e.g. `label`, `hint`) with no `::language` suffix. The user must replace it
#' with an explicitly language-tagged column such as `label::English (en)`.
#' Applies to `label` in both the `survey` and `choices` sheets; applies to all
#' other fields in `survey` only.
#'
#' **Language mismatch (error)** — A non-`label` translatable field is declared
#' with a language that was not declared for `label`. For example, if labels are
#' declared in French and English but a `hint` column appears in Spanish, that
#' Spanish `hint` is an error. The languages detected on `label` columns form
#' the reference set.
#'
#' @param xlsform An `xlsform` object as returned by [read_xlsform()] or
#'   [xlsform()].
#'
#' @return A tibble with columns `check`, `severity`, `name`, `list_name`, and
#'   `detail`. Has zero rows when no issues are found.
#'
#' @seealso [translatable_fields] for the full list of field prefixes inspected;
#'   [validate_xlsform()] to run all checks together.
#'
#' @noRd
check_labels <- function(xlsform) {}
