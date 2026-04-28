#' MSNA template XLSForm (required questions)
#'
#' An `xlsform` object containing the required questions from the
#' Multi-Sector Needs Assessment (MSNA) template form. This dataset serves as
#' the reference (development) form against which collected XLSForms can be
#' validated with [validate_xlsform()].
#'
#' @format An `xlsform` object — a named list of two tibbles with class
#'   `c("xlsform", "list")`:
#'
#'   **`survey`** — 291 rows × 17 columns:
#'   \describe{
#'     \item{type}{XLSForm question type (e.g. `"select_one"`, `"integer"`).}
#'     \item{name}{Variable name.}
#'     \item{`label::english (en)`}{Question label in English.}
#'     \item{`label::french (fr)`}{Question label in French.}
#'     \item{`hint::english (en)`}{Enumerator hint in English.}
#'     \item{`hint::french (fr)`}{Enumerator hint in French.}
#'     \item{calculation}{XLSForm calculation expression.}
#'     \item{required}{Whether the question is required (`TRUE`/`FALSE`/`NA`).}
#'     \item{relevant}{XLSForm relevance expression.}
#'     \item{constraint}{XLSForm constraint expression.}
#'     \item{default}{Default value.}
#'     \item{repeat_count}{Repeat count expression for repeat groups.}
#'     \item{`constraint_message::english (en)`}{Constraint violation message
#'       in English.}
#'     \item{`constraint_message::french (fr)`}{Constraint violation message
#'       in French.}
#'     \item{appearance}{XLSForm appearance attribute.}
#'     \item{choice_filter}{Choice filter expression.}
#'     \item{parameters}{Additional XLSForm parameters.}
#'   }
#'
#'   **`choices`** — 2,484 rows × 8 columns:
#'   \describe{
#'     \item{list_name}{Choice list identifier referenced in `survey$type`.}
#'     \item{name}{Choice option value.}
#'     \item{`label::english (en)`}{Choice label in English.}
#'     \item{`label::french (fr)`}{Choice label in French.}
#'     \item{parent_country}{Country-level cascade filter value.}
#'     \item{parent_admin1}{Admin1-level cascade filter value.}
#'     \item{parent_admin2}{Admin2-level cascade filter value.}
#'     \item{parent_admin3}{Admin3-level cascade filter value.}
#'   }
#'
#' @section Versioning:
#'   The dataset carries a `version` attribute recording the package version
#'   under which it was generated. Inspect it with:
#'
#'   ```r
#'   attr(msna_template_required, "version")
#'   ```
#'
#'   The dataset is updated in lockstep with package releases, so the version
#'   attribute ties each snapshot of the reference form to a specific release.
#'
#' @source Derived from the MSNA template XLSForm bundled in
#'   `inst/extdata/form.xlsx`. Regenerate with
#'   `data-raw/msna_template_required.R`.
#'
#' @seealso [read_xlsform()], [validate_xlsform()]
#'
#' @examples
#' msna_template_required
#'
#' xlsform_questions(msna_template_required)
#'
#' attr(msna_template_required, "version")
"msna_template_required"
