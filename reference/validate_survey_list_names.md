# Validate survey-referenced list names between two XLSForms

Checks that every list name *referenced* in `target`'s survey questions
is also referenced in `dev`'s survey questions. Returns a tibble row for
each list name actively used by `target`'s survey that is absent from
`dev`'s survey.

## Usage

``` r
validate_survey_list_names(target, dev)
```

## Arguments

- target:

  An `xlsform` object representing the authoritative reference form.

- dev:

  An `xlsform` object representing the form being validated.

## Value

A tibble with columns `check`, `severity`, `name`, `list_name`, and
`detail`. Has zero rows when all list names referenced by `target`'s
survey are also referenced by `dev`'s survey.

## Details

### How it differs from [`validate_list_names()`](https://impact-initiatives.github.io/idem/reference/validate_list_names.md)

[`validate_list_names()`](https://impact-initiatives.github.io/idem/reference/validate_list_names.md)
compares the lists *defined* in each form's choices sheet.
`validate_survey_list_names()` compares the lists actively *used* by
survey questions — the second token in `type` values like
`select_one list_a`.

The two checks are complementary. A list can be defined in choices but
never used in the survey (orphaned list), or — after a question type
change from `select_one list_a` to `text` — it may still be defined in
choices while no longer referenced in any survey question. This check
surfaces the latter case.

## See also

[`validate_xlsform()`](https://impact-initiatives.github.io/idem/reference/validate_xlsform.md)
to run all checks together;
[`validate_list_names()`](https://impact-initiatives.github.io/idem/reference/validate_list_names.md)
for the complementary choices-side check;
[`xlsform_list_names()`](https://impact-initiatives.github.io/idem/reference/xlsform_list_names.md)
to extract referenced list names from a form.

## Examples

``` r
target <- read_xlsform(system.file("extdata/form.xlsx", package = "idem"))

# No issues: all lists target's survey uses are also used in dev's survey
validate_survey_list_names(target, target)
#> # A tibble: 0 × 5
#> # ℹ 5 variables: check <chr>, severity <chr>, name <chr>, list_name <chr>,
#> #   detail <chr>

# Issues found: dev's survey has all select questions replaced by text,
# so none of target's referenced lists appear in dev's survey
dev_no_selects <- xlsform(
  survey = data.frame(
    type = rep("text", nrow(target$survey)),
    name = target$survey$name
  ),
  choices = target$choices
)
validate_survey_list_names(target, dev_no_selects)
#> # A tibble: 171 × 5
#>    check             severity name               list_name detail               
#>    <chr>             <chr>    <chr>              <chr>     <chr>                
#>  1 survey_list_names error    l_survey_modality  NA        List 'l_survey_modal…
#>  2 survey_list_names error    l_enum_id          NA        List 'l_enum_id' is …
#>  3 survey_list_names error    l_gender           NA        List 'l_gender' is r…
#>  4 survey_list_names error    l_admin1           NA        List 'l_admin1' is r…
#>  5 survey_list_names error    l_admin2           NA        List 'l_admin2' is r…
#>  6 survey_list_names error    l_admin3           NA        List 'l_admin3' is r…
#>  7 survey_list_names error    l_admin4           NA        List 'l_admin4' is r…
#>  8 survey_list_names error    l_cluster_id       NA        List 'l_cluster_id' …
#>  9 survey_list_names error    l_yn               NA        List 'l_yn' is refer…
#> 10 survey_list_names error    l_hoh_civil_status NA        List 'l_hoh_civil_st…
#> # ℹ 161 more rows
```
