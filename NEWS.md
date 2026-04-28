# idem 2026.4.27

* First release. Version tied to the MSNA 2026 XLSForm template (20260427).
* Read XLSForms with `read_xlsform()`.
* Validate a target form against a reference form with `validate_xlsform()`, `validate_choices()`, `validate_list_names()`, `validate_question_names()`, and `validate_survey_list_names()`.
* Inspect form structure with `xlsform_questions()`, `xlsform_choices()`, `xlsform_defined_list_names()`, and `xlsform_referenced_list_names()`.
* Bundled reference dataset `msna_template_required`: required questions from the MSNA 2026 template, versioned in lockstep with the package.
