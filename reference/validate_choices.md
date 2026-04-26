# Validate choice options between two XLSForms

For every list name that exists in *both* `target` and `dev`'s choices
sheets, checks that each choice option name present in `target` also
exists in `dev`. Returns a tibble row for each option found in `target`
that is absent from `dev` for the same list.

## Usage

``` r
validate_choices(target, dev, passing_lists = idem_passing_lists)
```

## Arguments

- target:

  An `xlsform` object representing the authoritative reference form.

- dev:

  An `xlsform` object representing the form being validated.

- passing_lists:

  A character vector of list names to skip entirely. Defaults to
  [idem_passing_lists](https://impact-initiatives.github.io/idem/reference/idem_passing_lists.md).
  Pass `character(0)` to disable all bypasses.

## Value

A tibble with columns `check`, `severity`, `name`, `list_name`, and
`detail`. Has zero rows when all choice options in `target` are present
in `dev` for every shared list.

## Details

### Scope of this check

This check only compares lists that are defined in *both* forms. Lists
that appear in `target` but are entirely absent from `dev` are not
reported here — use
[`validate_list_names()`](https://impact-initiatives.github.io/idem/reference/validate_list_names.md)
to catch those gaps first.

A typical validation workflow runs
[`validate_list_names()`](https://impact-initiatives.github.io/idem/reference/validate_list_names.md)
before `validate_choices()`, or simply calls
[`validate_xlsform()`](https://impact-initiatives.github.io/idem/reference/validate_xlsform.md)
which runs both.

## See also

[`validate_xlsform()`](https://impact-initiatives.github.io/idem/reference/validate_xlsform.md)
to run all checks together;
[`validate_list_names()`](https://impact-initiatives.github.io/idem/reference/validate_list_names.md)
for checking that lists themselves exist in `dev`;
[`xlsform_choices()`](https://impact-initiatives.github.io/idem/reference/xlsform_choices.md)
to extract choice options from a form.

## Examples

``` r
target <- read_xlsform(system.file("extdata/form.xlsx", package = "idem"))

# No issues: all choice options in target also exist in dev
validate_choices(target, target)
#> # A tibble: 0 × 5
#> # ℹ 5 variables: check <chr>, severity <chr>, name <chr>, list_name <chr>,
#> #   detail <chr>

# Issues found: drop one option from a non-passing list
non_passing_row <- which(
  !is.na(target$choices$list_name) &
    !target$choices$list_name %in% idem_passing_lists
)[1]
dev_trimmed <- xlsform(
  survey  = target$survey,
  choices = target$choices[-non_passing_row, ]
)
validate_choices(target, dev_trimmed)
#> # A tibble: 1 × 5
#>   check   severity name   list_name         detail                              
#>   <chr>   <chr>    <chr>  <chr>             <chr>                               
#> 1 choices error    remote l_survey_modality Choice 'remote' in list 'l_survey_m…

# Extend the default passing_lists with a project-specific list
validate_choices(
  target, target,
  passing_lists = c(idem_passing_lists, "l_my_project_list")
)
#> # A tibble: 0 × 5
#> # ℹ 5 variables: check <chr>, severity <chr>, name <chr>, list_name <chr>,
#> #   detail <chr>
```
