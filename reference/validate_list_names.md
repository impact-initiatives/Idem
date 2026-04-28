# Validate defined list names between two XLSForms

Checks that every list name *defined* in `target`'s choices sheet also
exists as a defined list in `dev`'s choices sheet. Returns a tibble row
for each list name present in `target`'s choices but absent from `dev`'s
choices.

## Usage

``` r
validate_list_names(target, dev)
```

## Arguments

- target:

  An `xlsform` object representing the authoritative reference form.

- dev:

  An `xlsform` object representing the form being validated.

## Value

A tibble with columns `check`, `severity`, `name`, `list_name`, and
`detail`. Has zero rows when all list names defined in `target`'s
choices are also defined in `dev`'s choices.

## Details

### Relationship to other checks

This check is a prerequisite for
[`validate_choices()`](https://impact-initiatives.github.io/idem/reference/validate_choices.md):
because
[`validate_choices()`](https://impact-initiatives.github.io/idem/reference/validate_choices.md)
only compares options for lists that exist in *both* forms' choices
sheets, any list that `target` defines but `dev` omits would be silently
skipped. `validate_list_names()` catches those gaps explicitly.

To verify that the same lists are also actively *used* in both forms'
survey questions (not just defined in choices), see
[`validate_survey_list_names()`](https://impact-initiatives.github.io/idem/reference/validate_survey_list_names.md).

## See also

[`validate_xlsform()`](https://impact-initiatives.github.io/idem/reference/validate_xlsform.md)
to run all checks together;
[`validate_survey_list_names()`](https://impact-initiatives.github.io/idem/reference/validate_survey_list_names.md)
for the complementary survey-side check;
[`xlsform_choices_list_names()`](https://impact-initiatives.github.io/idem/reference/xlsform_choices_list_names.md)
to extract defined list names from a form.

## Examples

``` r
target <- read_xlsform(system.file("extdata/form.xlsx", package = "idem"))

# No issues: all lists defined in target's choices are also defined in dev
validate_list_names(target, target)
#> # A tibble: 0 × 5
#> # ℹ 5 variables: check <chr>, severity <chr>, name <chr>, list_name <chr>,
#> #   detail <chr>

# Issues found: dev has no choice lists at all, but target defines some
dev_empty_choices <- xlsform(
  survey  = target$survey,
  choices = data.frame(list_name = character(), name = character())
)
validate_list_names(target, dev_empty_choices)
#> # A tibble: 174 × 5
#>    check      severity name               list_name detail                      
#>    <chr>      <chr>    <chr>              <chr>     <chr>                       
#>  1 list_names error    l_survey_modality  NA        List 'l_survey_modality' is…
#>  2 list_names error    l_enum_id          NA        List 'l_enum_id' is defined…
#>  3 list_names error    l_gender           NA        List 'l_gender' is defined …
#>  4 list_names error    l_admin3           NA        List 'l_admin3' is defined …
#>  5 list_names error    l_admin4           NA        List 'l_admin4' is defined …
#>  6 list_names error    l_cluster_id       NA        List 'l_cluster_id' is defi…
#>  7 list_names error    l_yn               NA        List 'l_yn' is defined in t…
#>  8 list_names error    l_yn_dnk_pnta      NA        List 'l_yn_dnk_pnta' is def…
#>  9 list_names error    l_hoh_civil_status NA        List 'l_hoh_civil_status' i…
#> 10 list_names error    l_setting          NA        List 'l_setting' is defined…
#> # ℹ 164 more rows
```
