
<!-- README.md is generated from README.Rmd. Please edit that file -->

# idem <a href="https://impact-initiatives.github.io/idem/"><img src="man/figures/logo.svg" align="right" height="139" alt="idem website" /></a>

<!-- badges: start -->

[![R-CMD-check](https://github.com/impact-initiatives/idem/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/impact-initiatives/idem/actions/workflows/R-CMD-check.yaml)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

idem helps you validate XLSForm files against an authoritative reference
form. It is designed for workflows where a canonical form is maintained
centrally and partner or localised copies must stay in sync with it —
catching drift in question names, choice lists, and answer options
before it causes problems in data collection or analysis.

## Installation

``` r
# install.packages("pak")
pak::pak("impact-initiatives/idem")
```

## Key concepts

**`target`** is the canonical, centrally maintained XLSForm — the source
of truth defining what questions, choice lists, and answer options are
required.

**`dev`** is the copy being validated — a localised adaptation, a
partner’s version, or a form deployed in a specific context.

The rule: **everything in `target` must also exist in `dev`**. `dev` may
carry extra content; it must not be missing anything `target` requires.

## The checks

| Check | What is tested |
|----|----|
| `question_names` | Every question name in `target` must exist in `dev`. |
| `list_names` | Every choice list *defined* in `target`’s choices sheet must also be defined in `dev`’s choices sheet. |
| `survey_list_names` | Every choice list *referenced* by `target`’s survey questions must also be referenced in `dev`’s survey questions. |
| `choices` | For every shared list, every choice option in `target` must exist in the same list in `dev`. |

All checks return a tidy tibble — one row per issue.

## Quick start

``` r
library(idem)

# load both forms
target <- msna_template_required          # bundled MSNA reference
dev    <- read_xlsform("path/to/mission_form.xlsx")

# run all checks
issues <- validate_xlsform(target = target, dev = dev)
issues
```

An empty tibble means the form is fully compliant. Any rows flag content
that `dev` is missing relative to `target`.

See the [Getting started](articles/getting-started.html) article for a
full walkthrough: exploring forms, understanding each check, running
checks individually, skipping lists, and working with results.

## Comparable / Similar tools

- <https://github.com/williameoswald/surveydesignr>
- <https://github.com/unhcr-americas/XlsFormUtil/blob/HEAD/R/fct_xlsform_compare.R>
- <https://github.com/PovertyAction/ipacheckscto>
- <https://github.com/PMA-2020/xform-test>
