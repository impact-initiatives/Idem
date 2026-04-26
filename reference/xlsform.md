# Construct an xlsform object from data frames

Builds an `xlsform` object directly from in-memory data frames, without
reading from a file. The resulting object is structurally identical to
one produced by
[`read_xlsform()`](https://impact-initiatives.github.io/idem/reference/read_xlsform.md),
making it useful for testing, creating minimal reproducible examples, or
programmatically assembling forms.

## Usage

``` r
xlsform(..., path = NA_character_)
```

## Arguments

- ...:

  Named data frames, one per sheet. Names become the sheet names (e.g.
  `survey =`, `choices =`). All arguments must be named and must be data
  frames.

- path:

  A string recording the (notional) source path. Defaults to
  `NA_character_` for in-memory objects.

## Value

An `xlsform` object: a named list of data frames with class
`c("xlsform", "list")` and a `path` attribute.

## Details

Most idem functions expect at least a `survey` sheet and, for
choice-related operations, a `choices` sheet.

## See also

[`read_xlsform()`](https://impact-initiatives.github.io/idem/reference/read_xlsform.md)
to load an `xlsform` object from an `.xlsx` file.

## Examples

``` r
# Minimal form with two select_one questions sharing a yes/no list
survey <- data.frame(
  type = c("select_one yn", "select_one yn", "text"),
  name = c("consent", "satisfied", "comments")
)
choices <- data.frame(
  list_name = c("yn", "yn"),
  name      = c("yes", "no"),
  label     = c("Yes", "No")
)
form <- xlsform(survey = survey, choices = choices)
form
#> <xlsform> NA
#> • survey: 3 rows
#> • choices: 2 rows

# In-memory forms can be passed directly to validate_xlsform()
validate_xlsform(form, form)
#> # A tibble: 0 × 5
#> # ℹ 5 variables: check <chr>, severity <chr>, name <chr>, list_name <chr>,
#> #   detail <chr>
```
