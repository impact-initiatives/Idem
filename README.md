---
output: github_document
---

<!-- README.md is generated from README.Rmd. Please edit that file -->



# idem

<!-- badges: start -->
[![R-CMD-check](https://github.com/impact-initiatives/idem/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/impact-initiatives/idem/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

idem helps you validate XLSForm files against an authoritative reference form.
It is designed for workflows where a canonical form is maintained centrally and
partner or localised copies must stay in sync with it — catching drift in
question names, choice lists, answer options, and translation columns before it
causes problems in data collection or analysis.

## Installation

```r
# install.packages("pak")
pak::pak("impact-initiatives/idem")
```

## Key concepts

### `target` — the authoritative reference form

The **`target`** form is the canonical, centrally maintained XLSForm. It defines
the full set of permitted questions, choice lists, and answer options for a given
data collection exercise. Think of it as the source of truth: what *can* legally
appear in any deployed copy of the form.

### `dev` — the form being validated

The **`dev`** form is the copy you want to check — a localised adaptation, a
partner's version, or a form deployed in a specific context. It is validated
*against* `target` to confirm it stays within the boundaries that `target`
defines.

### The rule: target must be a subset of dev

idem enforces one rule: **everything present in `target` must also exist in
`dev`**. In other words, `target` is a valid *subset* of `dev`.

This means:

- `dev` is allowed to have questions, lists, or options that `target` does not
  have — that is expected and fine.
- `dev` is **not** allowed to be missing questions, lists, or options that
  `target` requires — those gaps are flagged as errors.

## The checks

Four checks apply the subset rule to different parts of the form, and one
check inspects each form independently for translation consistency:

| Check | What is tested |
|---|---|
| `question_names` | Every question name in `target` must exist in `dev`. |
| `list_names` | Every choice list *defined* in `target`'s choices sheet must also be defined in `dev`'s choices sheet. |
| `survey_list_names` | Every choice list *referenced* by `target`'s survey questions must also be referenced in `dev`'s survey questions. |
| `choices` | For every shared list, every choice option in `target` must exist in the same list in `dev`. |
| `labels` | Each form's translation columns are checked independently for malformed column names (bare or incorrectly formatted), survey–choices label language mismatches, non-label field language mismatches, and a missing `default_language` in the `settings` sheet (runs `check_labels()` on each form). |

All checks return a tidy tibble — one row per issue — so results can be
filtered, counted, and passed to downstream reporting tools.

---

## Setup


``` r
library(idem)
#> Error in `library()`:
#> ! there is no package called 'idem'
```

idem ships with a sample XLSForm. We will use it as our reference throughout
this tutorial.


``` r
path <- system.file("extdata/form.xlsx", package = "idem")
target <- read_xlsform(path, optional_sheets = "settings")
#> Error in `read_xlsform()`:
#> ! could not find function "read_xlsform"
target
#> Error:
#> ! object 'target' not found
```

---

## Exploring a form

Before running validation, the extractor functions let you inspect the
contents of any form.

### Question names


``` r
xlsform_questions(target) |> head(15)
#> Error in `xlsform_questions()`:
#> ! could not find function "xlsform_questions"
```

### Choice lists referenced in the survey

These are the list names extracted from the `type` column — the second token
in values like `select_one l_yn`.


``` r
xlsform_list_names(target)
#> Error in `xlsform_list_names()`:
#> ! could not find function "xlsform_list_names"
```

### Choice lists defined in the choices sheet


``` r
xlsform_choices_list_names(target)
#> Error in `xlsform_choices_list_names()`:
#> ! could not find function "xlsform_choices_list_names"
```

### Choice options per list


``` r
xlsform_choices(target)[["l_yn"]]
#> Error in `xlsform_choices()`:
#> ! could not find function "xlsform_choices"
```

---

## Checking translations

Translated columns follow the convention `field::Language name (code)`, e.g.
`label::English (en)` or `hint::Français (fr)`. The parenthesised code must
be a lowercase [IANA language subtag](
https://www.iana.org/assignments/language-subtag-registry) — use that
registry to look up the correct code for a given language.

### Declared translations

`xlsform_translations()` extracts every translated column from a form as a
tidy tibble — one row per field–language combination.


``` r
xlsform_translations(target)
#> Error in `xlsform_translations()`:
#> ! could not find function "xlsform_translations"
```

### Translation consistency

`check_labels()` inspects a single form for four classes of translation issue:

- **Bare or malformed column (error)** — a translatable column (e.g. `label`,
  `hint`) is present either without a `::language (code)` suffix (bare, e.g.
  `label`) or with a malformed suffix that does not follow the
  `field::Language (code)` convention (e.g. `label::English` without an ISO
  code, `label::French (FR)` with an uppercase code, `label:Kreyol` with a
  single colon).
- **Survey–choices label language mismatch (error)** — the set of languages
  declared on `label` columns in the `survey` sheet must exactly match those
  declared on `label` columns in the `choices` sheet.
- **Non-label field language mismatch (error)** — a non-`label` field (e.g.
  `hint`, `constraint_message`) is declared in a language not present on any
  `label` column in `survey`.
- **Missing `default_language` (warning)** — the form declares more than one
  label language but no `default_language` is set in the `settings` sheet.
  Load the form with `optional_sheets = "settings"` to enable this check.

The fixture form is clean (settings sheet loaded, `default_language` is set):


``` r
check_labels(target)
#> Error in `check_labels()`:
#> ! could not find function "check_labels"
```

A multi-language form loaded *without* the settings sheet triggers the
`default_language` warning:


``` r
target_no_settings <- read_xlsform(path)
#> Error in `read_xlsform()`:
#> ! could not find function "read_xlsform"
check_labels(target_no_settings)
#> Error in `check_labels()`:
#> ! could not find function "check_labels"
```

A form with a bare `label` column and a mismatched `hint` language:


``` r
bad <- xlsform(
  survey = tibble::tibble(
    type                  = "text",
    name                  = "q1",
    label                 = "Name"
  )
)
#> Error in `xlsform()`:
#> ! could not find function "xlsform"
check_labels(bad)
#> Error in `check_labels()`:
#> ! could not find function "check_labels"

mismatch <- xlsform(
  survey = tibble::tibble(
    type                  = "text",
    name                  = "q1",
    `label::English (en)` = "Name",
    `hint::Spanish (es)`  = "Tu nombre"
  )
)
#> Error in `xlsform()`:
#> ! could not find function "xlsform"
check_labels(mismatch)
#> Error in `check_labels()`:
#> ! could not find function "check_labels"
```

---

## Validating forms

### The clean case — no issues

A form is always a valid subset of itself. Running `validate_xlsform()` against
an identical form returns an empty tibble.


``` r
validate_xlsform(target, target)
#> Error in `validate_xlsform()`:
#> ! could not find function "validate_xlsform"
```

### What is and isn't flagged

The following examples make the subset rule concrete by demonstrating the
**passing direction** for each check: `dev` carrying extra content that
`target` doesn't require. In every case the result is an empty tibble.


``` r
# dev has an extra question that target doesn't need — passes
dev_extra_q <- target$survey[1L, ]
#> Error:
#> ! object 'target' not found
dev_extra_q$name <- "dev_only_question"
#> Error:
#> ! object 'dev_extra_q' not found
dev_with_extra_q <- xlsform(
  survey  = rbind(target$survey, dev_extra_q),
  choices = target$choices
)
#> Error in `xlsform()`:
#> ! could not find function "xlsform"
validate_question_names(target, dev_with_extra_q) # 0 issues — target is a valid subset
#> Error in `validate_question_names()`:
#> ! could not find function "validate_question_names"

# dev defines an extra choice list that target doesn't use — passes
dev_extra_list <- target$choices[target$choices$list_name == "l_yn" &
  !is.na(target$choices$list_name), ]
#> Error:
#> ! object 'target' not found
dev_extra_list$list_name <- "l_dev_only"
#> Error:
#> ! object 'dev_extra_list' not found
dev_with_extra_list <- xlsform(
  survey  = target$survey,
  choices = rbind(target$choices, dev_extra_list)
)
#> Error in `xlsform()`:
#> ! could not find function "xlsform"
validate_list_names(target, dev_with_extra_list) # 0 issues — target need not use every list in dev
#> Error in `validate_list_names()`:
#> ! could not find function "validate_list_names"

# dev references an extra list in its survey that target doesn't — passes
dev_survey_extra <- target$survey
#> Error:
#> ! object 'target' not found
dev_survey_extra$type[dev_survey_extra$type == "text"][1L] <- "select_one l_dev_only"
#> Error:
#> ! object 'dev_survey_extra' not found
dev_with_extra_ref <- xlsform(
  survey  = dev_survey_extra,
  choices = rbind(target$choices, dev_extra_list)
)
#> Error in `xlsform()`:
#> ! could not find function "xlsform"
validate_survey_list_names(target, dev_with_extra_ref) # 0 issues — target simply doesn't use that list
#> Error in `validate_survey_list_names()`:
#> ! could not find function "validate_survey_list_names"

# dev has an extra choice option in a shared list that target doesn't — passes
dev_extra_opt <- target$choices[target$choices$list_name == "l_yn" &
  !is.na(target$choices$list_name), ][1L, ]
#> Error:
#> ! object 'target' not found
dev_extra_opt$name <- "not_applicable"
#> Error:
#> ! object 'dev_extra_opt' not found
dev_with_extra_opt <- xlsform(
  survey  = target$survey,
  choices = rbind(target$choices, dev_extra_opt)
)
#> Error in `xlsform()`:
#> ! could not find function "xlsform"
validate_choices(target, dev_with_extra_opt) # 0 issues — target uses a subset of available options
#> Error in `validate_choices()`:
#> ! could not find function "validate_choices"
```

All four return empty tibbles — no issues — confirming that `dev` being a
superset of `target` is always allowed.

### Building a target form with issues

In practice you load both forms from disk:

```r
target <- read_xlsform("path/to/target.xlsx")
dev    <- read_xlsform("path/to/dev.xlsx")
```

For this tutorial we construct a `target` that has content `dev` is missing,
introducing one example of each issue type.


``` r
# 1. target requires a question dev doesn't have
extra_q <- target$survey[1L, ]
#> Error:
#> ! object 'target' not found
extra_q$name <- "required_indicator"
#> Error:
#> ! object 'extra_q' not found
target_survey <- rbind(target$survey, extra_q)
#> Error:
#> ! object 'target' not found

# 2. target requires a choice option dev is missing (in the 'l_yn' list)
extra_opt <- target$choices[target$choices$list_name == "l_yn" &
  !is.na(target$choices$list_name), ][1L, ]
#> Error:
#> ! object 'target' not found
extra_opt$name <- "mandatory_option"
#> Error:
#> ! object 'extra_opt' not found

# 3. target defines a choice list that dev's choices sheet doesn't have
new_list <- target$choices[target$choices$list_name == "l_yn" &
  !is.na(target$choices$list_name), ][1:2, ]
#> Error:
#> ! object 'target' not found
new_list$list_name <- "l_required_scale"
#> Error:
#> ! object 'new_list' not found
new_list$name <- c("low", "high")
#> Error:
#> ! object 'new_list' not found

target_choices <- rbind(target$choices, extra_opt, new_list)
#> Error:
#> ! object 'target' not found

# 4. target references a list in its survey that dev's survey doesn't have
target_survey$type[target_survey$type == "text"][1L] <- "select_one l_required_scale"
#> Error:
#> ! object 'target_survey' not found

# Build a dev form that is the original (without the additions above)
# so that it is missing everything target now requires
dev <- xlsform(survey = target$survey, choices = target$choices)
#> Error in `xlsform()`:
#> ! could not find function "xlsform"

# Re-assign target with all the additions
target_with_issues <- xlsform(survey = target_survey, choices = target_choices)
#> Error in `xlsform()`:
#> ! could not find function "xlsform"
```

### Running all checks at once

`validate_xlsform()` runs every check — including `"labels"` on both forms —
and returns a combined tibble.


``` r
issues <- validate_xlsform(target_with_issues, dev)
#> Error in `validate_xlsform()`:
#> ! could not find function "validate_xlsform"
knitr::kable(issues)
#> Error:
#> ! object 'issues' not found
```

---

## Individual checks

Each check can also be run in isolation when you only need a focused result.

### `validate_question_names()`

Checks that every question name in `target` exists in `dev`.


``` r
result_qn <- validate_question_names(target_with_issues, dev)
#> Error in `validate_question_names()`:
#> ! could not find function "validate_question_names"
knitr::kable(result_qn)
#> Error:
#> ! object 'result_qn' not found
```

### `validate_list_names()`

Checks that every choice list *defined* in `target`'s choices sheet also
exists in `dev`'s choices sheet.


``` r
result_ln <- validate_list_names(target_with_issues, dev)
#> Error in `validate_list_names()`:
#> ! could not find function "validate_list_names"
knitr::kable(result_ln)
#> Error:
#> ! object 'result_ln' not found
```

### `validate_survey_list_names()`

Checks that every choice list *referenced* in `target`'s survey questions
is also referenced in `dev`'s survey questions.

This is complementary to `validate_list_names()`: a list might be defined in
the choices sheet but never used — or, as in our example, a question type
changed from `text` to `select_one l_required_scale` without a matching entry
in dev's survey.


``` r
result_sln <- validate_survey_list_names(target_with_issues, dev)
#> Error in `validate_survey_list_names()`:
#> ! could not find function "validate_survey_list_names"
knitr::kable(result_sln)
#> Error:
#> ! object 'result_sln' not found
```

### `validate_choices()`

For every choice list present in *both* forms, checks that all options in
`target` also exist in `dev`.

Note: lists that exist only in `target` (caught by `validate_list_names()`)
are not reported here — this check focuses on options within shared lists.


``` r
result_ch <- validate_choices(target_with_issues, dev)
#> Error in `validate_choices()`:
#> ! could not find function "validate_choices"
knitr::kable(result_ch)
#> Error:
#> ! object 'result_ch' not found
```

### `check_labels()`

Unlike the `validate_*()` functions, `check_labels()` operates on a **single**
form and checks translation column consistency independently. When called via
`validate_xlsform()` with `checks = "labels"`, it runs on both `target` and
`dev` and combines the results.

Here `dev_bad_labels` has a bare `label` column and a hint in a language not
declared on any label column:


``` r
dev_bad_labels <- xlsform(
  survey = tibble::tibble(
    type                 = "text",
    name                 = "q1",
    label                = "Name",
    `hint::Spanish (es)` = "Tu nombre"
  )
)
#> Error in `xlsform()`:
#> ! could not find function "xlsform"
validate_xlsform(target_with_issues, dev_bad_labels, checks = "labels")
#> Error in `validate_xlsform()`:
#> ! could not find function "validate_xlsform"
```

---

## Running a subset of checks

Pass a character vector to the `checks` argument to run only the checks you
need.


``` r
validate_xlsform(
  target_with_issues, dev,
  checks = c("question_names", "choices")
) |>
  knitr::kable()
#> Error in `validate_xlsform()`:
#> ! could not find function "validate_xlsform"
```

---

## Working with results

Because `validate_xlsform()` returns a plain tibble, standard data manipulation
works directly on the output.


``` r
# Count issues by check
issues |>
  dplyr::count(check, severity, name = "n_issues")
#> Error:
#> ! object 'issues' not found
```

## Comparable / Similar tools

* https://github.com/williameoswald/surveydesignr
* https://github.com/unhcr-americas/XlsFormUtil/blob/HEAD/R/fct_xlsform_compare.R
* https://github.com/PovertyAction/ipacheckscto
* https://github.com/PMA-2020/xform-test
