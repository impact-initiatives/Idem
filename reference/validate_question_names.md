# Validate question names between two XLSForms

Checks that every question name present in `target`'s survey sheet also
exists in `dev`'s survey sheet. Returns a tibble row for each question
name found in `target` but absent from `dev`.

## Usage

``` r
validate_question_names(target, dev)
```

## Arguments

- target:

  An `xlsform` object representing the authoritative reference form.

- dev:

  An `xlsform` object representing the form being validated.

## Value

A tibble with columns `check`, `severity`, `name`, `list_name`, and
`detail`. Has zero rows when all question names in `target` are present
in `dev`.

## Details

This check catches situations where the authoritative `target` form
contains questions that the work-in-progress `dev` form has not yet
included — for example, a localised adaptation that dropped required
questions, or a form version that has fallen behind the central
reference.

## See also

[`validate_xlsform()`](https://impact-initiatives.github.io/idem/reference/validate_xlsform.md)
to run all checks together;
[`xlsform_questions()`](https://impact-initiatives.github.io/idem/reference/xlsform_questions.md)
to extract question names from a form.

## Examples

``` r
target <- read_xlsform(system.file("extdata/form.xlsx", package = "idem"))

# No issues: every question in target also exists in dev
validate_question_names(target, target)
#> # A tibble: 0 × 5
#> # ℹ 5 variables: check <chr>, severity <chr>, name <chr>, list_name <chr>,
#> #   detail <chr>

# Issues found: target has a question that dev is missing
extra_row <- target$survey[1L, ]
extra_row$name <- "required_question"
target_extra <- xlsform(
  survey  = rbind(target$survey, extra_row),
  choices = target$choices
)
validate_question_names(target_extra, target)
#> # A tibble: 1 × 5
#>   check          severity name              list_name detail                    
#>   <chr>          <chr>    <chr>             <chr>     <chr>                     
#> 1 question_names error    required_question NA        Question 'required_questi…
```
