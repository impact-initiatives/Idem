# Default list names skipped by [`validate_choices()`](https://impact-initiatives.github.io/idem/reference/validate_choices.md)

A character vector of XLSForm list names whose choice options are
expected to differ between forms (admin boundaries, cluster IDs,
enumerator IDs). Used as the default for the `passing_lists` argument of
[`validate_choices()`](https://impact-initiatives.github.io/idem/reference/validate_choices.md)
and
[`validate_xlsform()`](https://impact-initiatives.github.io/idem/reference/validate_xlsform.md).

## Usage

``` r
idem_passing_lists
```

## Format

An object of class `character` of length 7.

## Examples

``` r
idem_passing_lists
#> [1] "l_admin1"     "l_admin2"     "l_admin3"     "l_admin4"     "l_cluster_id"
#> [6] "l_country"    "l_enum_id"   
```
