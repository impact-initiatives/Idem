# Read an XLSForm file

Reads an XLSForm `.xlsx` file from disk and returns an `xlsform` object
— a named list of tibbles (one per sheet) with the source file path
stored as an attribute. This is the standard entry point for working
with XLSForms in idem.

## Usage

``` r
read_xlsform(
  path,
  required_sheets = c("survey", "choices"),
  optional_sheets = character()
)
```

## Arguments

- path:

  Path to the `.xlsx` file.

- required_sheets:

  Character vector of sheet names that must be present in the workbook.
  Defaults to `c("survey", "choices")`. An absent required sheet is an
  error.

- optional_sheets:

  Character vector of sheet names to read if present. Defaults to
  [`character()`](https://rdrr.io/r/base/character.html). An absent
  optional sheet produces a warning and is silently excluded from the
  returned object.

## Value

An `xlsform` object: a named list of tibbles, one per sheet successfully
read, with a `path` attribute holding the source file path and class
`c("xlsform", "list")`.

## Details

By default the `survey` and `choices` sheets are required. Pass
additional sheet names (e.g. `"external_choices"`) via
`required_sheets`, or request sheets that may not be present (e.g.
`"settings"`) via `optional_sheets`.

## See also

[`xlsform()`](https://impact-initiatives.github.io/idem/reference/xlsform.md)
to construct an `xlsform` object from in-memory data frames.

## Examples

``` r
path <- system.file("extdata/form.xlsx", package = "idem")

# Read the default sheets (survey + choices)
form <- read_xlsform(path)
form
#> <xlsform> /home/runner/work/_temp/Library/idem/extdata/form.xlsx
#> • survey: 710 rows
#> • choices: 3726 rows

# Inspect the survey sheet directly
form$survey
#> # A tibble: 710 × 24
#>    level      req  hnrp theme        module          indicator index type  name 
#>    <chr>    <dbl> <dbl> <chr>        <chr>           <chr>     <dbl> <chr> <chr>
#>  1 metadata     1     0 Metadata     NA              NA           NA audit audit
#>  2 metadata     1     0 Metadata     NA              NA           NA start start
#>  3 metadata     1     0 Metadata     NA              NA           NA end   end  
#>  4 metadata     1     0 Metadata     NA              NA           NA today today
#>  5 metadata     1     0 Metadata     NA              NA           NA devi… devi…
#>  6 metadata     1     0 Metadata     NA              NA           NA calc… inst…
#>  7 main         1     0 Introduction NA              NA           NA begi… intr…
#>  8 main         1     1 Introduction Interview deta… % of int…     1 sele… surv…
#>  9 main         1     1 Introduction Interview deta… For data…     2 sele… enum…
#> 10 main         0     1 Introduction Interview deta… % of int…     3 sele… enum…
#> # ℹ 700 more rows
#> # ℹ 15 more variables: `label::english (en)` <chr>, `label::french (fr)` <chr>,
#> #   `hint::english (en)` <chr>, `hint::french (fr)` <chr>, calculation <chr>,
#> #   required <lgl>, relevant <chr>, constraint <chr>, default <lgl>,
#> #   repeat_count <chr>, `constraint_message::english (en)` <chr>,
#> #   `constraint_message::french (fr)` <chr>, appearance <chr>,
#> #   choice_filter <chr>, parameters <chr>

# Opportunistically read the settings sheet (no error if absent)
read_xlsform(path, optional_sheets = "settings")
#> Warning: 1 optional sheet not found in
#> /home/runner/work/_temp/Library/idem/extdata/form.xlsx.
#> ! Excluded: "settings"
#> <xlsform> /home/runner/work/_temp/Library/idem/extdata/form.xlsx
#> • survey: 710 rows
#> • choices: 3726 rows
```
