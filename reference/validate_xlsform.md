# Validate an XLSForm against a reference form

Runs one or more validation checks comparing a `dev` (work-in-progress)
XLSForm against a `target` (authoritative reference) XLSForm. The
default direction checks that everything present in `target` also exists
in `dev` — i.e., `target` is a valid subset of `dev`.

## Usage

``` r
validate_xlsform(
  target,
  dev,
  checks = c("question_names", "list_names", "survey_list_names", "choices"),
  passing_lists = idem_passing_lists
)
```

## Arguments

- target:

  An `xlsform` object representing the authoritative reference form.

- dev:

  An `xlsform` object representing the form being validated.

- checks:

  A character vector of check names to run. Defaults to all four checks:
  `c("question_names", "list_names", "survey_list_names", "choices")`.

- passing_lists:

  Passed to
  [`validate_choices()`](https://impact-initiatives.github.io/idem/reference/validate_choices.md).
  A character vector of list names whose choice options are not
  compared. Defaults to
  [idem_passing_lists](https://impact-initiatives.github.io/idem/reference/idem_passing_lists.md).

## Value

A tibble with columns `check`, `severity`, `name`, `list_name`, and
`detail`. Has zero rows when no issues are found.

## Details

This is the main entry point for form validation. It delegates to the
individual `validate_*()` functions and combines their results into a
single tibble.

### Available checks

|                       |                                                                                                                  |
|-----------------------|------------------------------------------------------------------------------------------------------------------|
| Check name            | What it tests                                                                                                    |
| `"question_names"`    | Every question name in `target` must exist in `dev`.                                                             |
| `"list_names"`        | Every list name *defined* in `target`'s choices sheet must also be defined in `dev`'s choices sheet.             |
| `"survey_list_names"` | Every list name *referenced* in `target`'s survey questions must also be referenced in `dev`'s survey questions. |
| `"choices"`           | For every shared list, every choice option in `target` must exist in the same list in `dev`.                     |

### Return value structure

Each row in the returned tibble represents one validation issue:

|             |                                                             |
|-------------|-------------------------------------------------------------|
| Column      | Description                                                 |
| `check`     | Which check produced this issue.                            |
| `severity`  | Currently always `"error"`.                                 |
| `name`      | The name of the offending question or choice option.        |
| `list_name` | The choices list involved (`NA` for question-level checks). |
| `detail`    | A human-readable description of the problem.                |

## See also

[`validate_question_names()`](https://impact-initiatives.github.io/idem/reference/validate_question_names.md),
[`validate_list_names()`](https://impact-initiatives.github.io/idem/reference/validate_list_names.md),
[`validate_survey_list_names()`](https://impact-initiatives.github.io/idem/reference/validate_survey_list_names.md),
[`validate_choices()`](https://impact-initiatives.github.io/idem/reference/validate_choices.md)
for the individual checks.

## Examples

``` r
target <- read_xlsform(system.file("extdata/form.xlsx", package = "idem"))

# No issues: a form is always a valid subset of itself
validate_xlsform(target, target)
#> # A tibble: 0 × 5
#> # ℹ 5 variables: check <chr>, severity <chr>, name <chr>, list_name <chr>,
#> #   detail <chr>

# Run only a subset of checks
validate_xlsform(target, target, checks = c("question_names", "choices"))
#> # A tibble: 0 × 5
#> # ℹ 5 variables: check <chr>, severity <chr>, name <chr>, list_name <chr>,
#> #   detail <chr>

# Introduce issues: dev is missing a question and a choice option
non_passing_row <- which(
  !is.na(target$choices$list_name) &
    !target$choices$list_name %in% idem_passing_lists
)[1]
dev_trimmed <- xlsform(
  survey  = target$survey[-nrow(target$survey), ],
  choices = target$choices[-non_passing_row, ]
)
issues <- validate_xlsform(target, dev_trimmed)
issues
#> # A tibble: 2 × 5
#>   check          severity name       list_name         detail                   
#>   <chr>          <chr>    <chr>      <chr>             <chr>                    
#> 1 question_names error    final_text NA                Question 'final_text' is…
#> 2 choices        error    remote     l_survey_modality Choice 'remote' in list …

# Extend the default passing_lists with a project-specific list
validate_xlsform(
  target, target,
  passing_lists = c(idem_passing_lists, "l_my_project_list")
)
#> # A tibble: 0 × 5
#> # ℹ 5 variables: check <chr>, severity <chr>, name <chr>, list_name <chr>,
#> #   detail <chr>
```
