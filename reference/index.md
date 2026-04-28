# Package index

## Read & construct

Create an `xlsform` object by reading an `.xlsx` file from disk or by
assembling one directly from in-memory data frames.

- [`read_xlsform()`](https://impact-initiatives.github.io/idem/reference/read_xlsform.md)
  : Read an XLSForm file
- [`xlsform()`](https://impact-initiatives.github.io/idem/reference/xlsform.md)
  : Construct an xlsform object from data frames

## Extract form components

Pull specific pieces of information out of an `xlsform` object —
question names, choice-list names referenced in the survey, list names
defined in the choices sheet, and the full set of choice options per
list. These accessors are also used internally by the validation
functions.

- [`xlsform_questions()`](https://impact-initiatives.github.io/idem/reference/xlsform_questions.md)
  : Get question names from an XLSForm
- [`xlsform_referenced_list_names()`](https://impact-initiatives.github.io/idem/reference/xlsform_referenced_list_names.md)
  : Get list names referenced in an XLSForm's survey sheet
- [`xlsform_defined_list_names()`](https://impact-initiatives.github.io/idem/reference/xlsform_defined_list_names.md)
  : Get list names defined in the choices sheets of an XLSForm
- [`xlsform_choices()`](https://impact-initiatives.github.io/idem/reference/xlsform_choices.md)
  : Get choice options from an XLSForm

## Validate

Validate a `dev` XLSForm against an authoritative `target` reference
form. The top-level
[`validate_xlsform()`](https://impact-initiatives.github.io/idem/reference/validate_xlsform.md)
function runs all checks and returns a tidy tibble of issues; the
individual `validate_*()` functions each cover one check and can be run
independently when finer control is needed.

- [`validate_xlsform()`](https://impact-initiatives.github.io/idem/reference/validate_xlsform.md)
  : Validate an XLSForm against a reference form
- [`validate_question_names()`](https://impact-initiatives.github.io/idem/reference/validate_question_names.md)
  : Validate question names between two XLSForms
- [`validate_list_names()`](https://impact-initiatives.github.io/idem/reference/validate_list_names.md)
  : Validate defined list names between two XLSForms
- [`validate_survey_list_names()`](https://impact-initiatives.github.io/idem/reference/validate_survey_list_names.md)
  : Validate survey-referenced list names between two XLSForms
- [`validate_choices()`](https://impact-initiatives.github.io/idem/reference/validate_choices.md)
  : Validate choice options between two XLSForms

## Datasets

Bundled reference XLSForms included with the package.

- [`msna_template_required`](https://impact-initiatives.github.io/idem/reference/msna_template_required.md)
  : MSNA template XLSForm (required questions)

## Miscellaneous

- [`idem_passing_lists`](https://impact-initiatives.github.io/idem/reference/idem_passing_lists.md)
  :

  Default list names skipped by
  [`validate_choices()`](https://impact-initiatives.github.io/idem/reference/validate_choices.md)
