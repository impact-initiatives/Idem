# ── check_labels (orchestrator) ───────────────────────────────────────────────

test_that("check_labels returns a tibble with the correct 5 columns", {
  x <- xlsform(
    survey = tibble::tibble(
      type = "text",
      name = "q1",
      `label::English (en)` = "Q"
    ),
    choices = tibble::tibble(
      list_name = character(),
      name = character(),
      `label::English (en)` = character()
    )
  )
  result <- check_labels(x)
  expect_s3_class(result, "tbl_df")
  expect_named(result, c("check", "severity", "name", "list_name", "detail"))
})

test_that("check_labels returns 0 rows for a valid translated form", {
  x <- xlsform(
    survey = tibble::tibble(
      type = "text",
      name = "q1",
      `label::English (en)` = "Q",
      `hint::English (en)` = "Hint"
    ),
    choices = tibble::tibble(
      list_name = character(),
      name = character(),
      `label::English (en)` = character()
    )
  )
  result <- check_labels(x)
  expect_equal(nrow(result), 0L)
})

test_that("check_labels returns 0 rows for the real fixture form", {
  form <- read_xlsform(
    system.file("extdata/form.xlsx", package = "idem"),
    optional_sheets = "settings"
  )
  result <- check_labels(form)
  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 0L)
})

test_that("check_labels accumulates all issue types without early return", {
  # Form with: mismatch on non-label field + no default_language
  # Both should appear in the result (no early return)
  x <- xlsform(
    survey = tibble::tibble(
      type = "text",
      name = "q1",
      `label::English (en)` = "Q",
      `label::French (fr)` = "Q",
      `hint::Spanish (es)` = "Pista"
    )
  )
  result <- check_labels(x)
  # Should have the language-mismatch error AND the default_language warning
  expect_true(any(result$severity == "error"))
  expect_true(any(result$severity == "warning"))
})

# ── .check_labels_malformed (Check A) ─────────────────────────────────────────

test_that(".check_labels_malformed errors on bare label column in survey", {
  x <- xlsform(
    survey = tibble::tibble(
      type = "text",
      name = "q1",
      label = "Question"
    )
  )
  result <- idem:::.check_labels_malformed(x)
  expect_s3_class(result, "tbl_df")
  expect_named(result, c("check", "severity", "name", "list_name", "detail"))
  expect_gte(nrow(result), 1L)
  expect_true(all(result$severity == "error"))
  expect_true(any(stringr::str_detect(result$detail, "bare field")))
})

test_that(".check_labels_malformed errors on bare hint column in survey", {
  x <- xlsform(
    survey = tibble::tibble(
      type = "text",
      name = "q1",
      `label::English (en)` = "Q",
      hint = "A hint"
    )
  )
  result <- idem:::.check_labels_malformed(x)
  expect_gte(nrow(result), 1L)
  expect_true(all(result$severity == "error"))
})

# nolint start: line_length_linter.
test_that(".check_labels_malformed errors on bare constraint_message in survey", {
  # nolint end
  x <- xlsform(
    survey = tibble::tibble(
      type = "text",
      name = "q1",
      `label::English (en)` = "Q",
      constraint_message = "Bad value"
    )
  )
  result <- idem:::.check_labels_malformed(x)
  expect_gte(nrow(result), 1L)
  expect_true(all(result$severity == "error"))
})

test_that(".check_labels_malformed errors on bare image column in survey", {
  x <- xlsform(
    survey = tibble::tibble(
      type = "text",
      name = "q1",
      `label::English (en)` = "Q",
      image = "pic.png"
    )
  )
  result <- idem:::.check_labels_malformed(x)
  expect_gte(nrow(result), 1L)
  expect_true(all(result$severity == "error"))
})

test_that(".check_labels_malformed errors on bare label column in choices", {
  x <- xlsform(
    survey = tibble::tibble(
      type = "select_one yn",
      name = "q1",
      `label::English (en)` = "Q"
    ),
    choices = tibble::tibble(
      list_name = "yn",
      name = c("yes", "no"),
      label = c("Yes", "No")
    )
  )
  result <- idem:::.check_labels_malformed(x)
  expect_gte(nrow(result), 1L)
  expect_true(all(result$severity == "error"))
})

# nolint start: line_length_linter.
test_that(".check_labels_malformed does not error on valid translated choices label", {
  # nolint end
  x <- xlsform(
    survey = tibble::tibble(
      type = "select_one yn",
      name = "q1",
      `label::English (en)` = "Q"
    ),
    choices = tibble::tibble(
      list_name = "yn",
      name = c("yes", "no"),
      `label::English (en)` = c("Yes", "No")
    )
  )
  result <- idem:::.check_labels_malformed(x)
  expect_equal(nrow(result), 0L)
})

# nolint start: line_length_linter.
test_that(".check_labels_malformed flags malformed (missing ISO code) as malformed, not bare", {
  # nolint end
  x <- xlsform(
    survey = tibble::tibble(
      type = "text",
      name = "q1",
      `label::English` = "Q"
    )
  )
  result <- idem:::.check_labels_malformed(x)
  expect_gte(nrow(result), 1L)
  expect_true(any(stringr::str_detect(
    result$detail,
    "not a valid translated column"
  )))
})

test_that(".check_labels_malformed returns 0 rows for a fully valid form", {
  x <- xlsform(
    survey = tibble::tibble(
      type = "text",
      name = "q1",
      `label::English (en)` = "Q",
      `hint::English (en)` = "Hint"
    )
  )
  result <- idem:::.check_labels_malformed(x)
  expect_equal(nrow(result), 0L)
})

# Regression: non-translatable columns that share a prefix should not be flagged
test_that(".check_labels_malformed does not flag non-translatable columns", {
  x <- xlsform(
    survey = tibble::tibble(
      type = "text",
      name = "q1",
      `label::English (en)` = "Q",
      label_for_analysis = "analysis_label"
    )
  )
  result <- idem:::.check_labels_malformed(x)
  expect_equal(nrow(result), 0L)
})

# nolint start: line_length_linter.
# ── check_labels (Check A — via orchestrator, for backward compat) ─────────────
# nolint end

test_that("check_labels errors on bare label column in survey", {
  x <- xlsform(
    survey = tibble::tibble(
      type = "text",
      name = "q1",
      label = "Question"
    )
  )
  result <- check_labels(x)
  expect_s3_class(result, "tbl_df")
  expect_gte(nrow(result), 1L)
  expect_true(any(result$severity == "error"))
  expect_true(any(result$check == "labels"))
})

test_that("check_labels errors on bare hint column in survey", {
  x <- xlsform(
    survey = tibble::tibble(
      type = "text",
      name = "q1",
      `label::English (en)` = "Q",
      hint = "A hint"
    )
  )
  result <- check_labels(x)
  expect_gte(nrow(result), 1L)
  expect_true(any(result$severity == "error"))
})

test_that("check_labels errors on bare constraint_message in survey", {
  x <- xlsform(
    survey = tibble::tibble(
      type = "text",
      name = "q1",
      `label::English (en)` = "Q",
      constraint_message = "Bad value"
    )
  )
  result <- check_labels(x)
  expect_gte(nrow(result), 1L)
  expect_true(any(result$severity == "error"))
})

test_that("check_labels errors on bare image column in survey", {
  x <- xlsform(
    survey = tibble::tibble(
      type = "text",
      name = "q1",
      `label::English (en)` = "Q",
      image = "pic.png"
    )
  )
  result <- check_labels(x)
  expect_gte(nrow(result), 1L)
  expect_true(any(result$severity == "error"))
})

test_that("check_labels errors on bare label column in choices", {
  x <- xlsform(
    survey = tibble::tibble(
      type = "select_one yn",
      name = "q1",
      `label::English (en)` = "Q"
    ),
    choices = tibble::tibble(
      list_name = "yn",
      name = c("yes", "no"),
      label = c("Yes", "No")
    )
  )
  result <- check_labels(x)
  expect_gte(nrow(result), 1L)
  expect_true(any(result$severity == "error"))
})

test_that("check_labels does not error on valid translated choices label", {
  x <- xlsform(
    survey = tibble::tibble(
      type = "select_one yn",
      name = "q1",
      `label::English (en)` = "Q"
    ),
    choices = tibble::tibble(
      list_name = "yn",
      name = c("yes", "no"),
      `label::English (en)` = c("Yes", "No")
    )
  )
  result <- check_labels(x)
  expect_equal(nrow(result), 0L)
})

# ── .check_labels_survey_choices_sym (Check B) ────────────────────────────────

# nolint start: line_length_linter.
test_that(".check_labels_survey_choices_sym errors when survey has language absent from choices", {
  # nolint end
  x <- xlsform(
    survey = tibble::tibble(
      type = "select_one yn",
      name = "q1",
      `label::English (en)` = "Q",
      `label::French (fr)` = "Q"
    ),
    choices = tibble::tibble(
      list_name = "yn",
      name = c("yes", "no"),
      `label::English (en)` = c("Yes", "No")
      # French missing from choices
    )
  )
  result <- idem:::.check_labels_survey_choices_sym(x)
  expect_s3_class(result, "tbl_df")
  expect_named(result, c("check", "severity", "name", "list_name", "detail"))
  expect_true(any(result$severity == "error"))
  expect_true(any(stringr::str_detect(result$detail, "French \\(fr\\)")))
  expect_true(any(stringr::str_detect(
    result$detail,
    "survey label.*not.*choices"
  )))
})

# nolint start: line_length_linter.
test_that(".check_labels_survey_choices_sym errors when choices has language absent from survey", {
  # nolint end
  x <- xlsform(
    survey = tibble::tibble(
      type = "select_one yn",
      name = "q1",
      `label::English (en)` = "Q"
    ),
    choices = tibble::tibble(
      list_name = "yn",
      name = c("yes", "no"),
      `label::English (en)` = c("Yes", "No"),
      `label::French (fr)` = c("Oui", "Non")
    )
  )
  result <- idem:::.check_labels_survey_choices_sym(x)
  expect_true(any(result$severity == "error"))
  expect_true(any(stringr::str_detect(result$detail, "French \\(fr\\)")))
  expect_true(any(stringr::str_detect(
    result$detail,
    "choices label.*not.*survey"
  )))
})

# nolint start: line_length_linter.
test_that(".check_labels_survey_choices_sym returns 0 rows when languages match", {
  # nolint end
  x <- xlsform(
    survey = tibble::tibble(
      type = "select_one yn",
      name = "q1",
      `label::English (en)` = "Q",
      `label::French (fr)` = "Q"
    ),
    choices = tibble::tibble(
      list_name = "yn",
      name = c("yes", "no"),
      `label::English (en)` = c("Yes", "No"),
      `label::French (fr)` = c("Oui", "Non")
    )
  )
  result <- idem:::.check_labels_survey_choices_sym(x)
  expect_equal(nrow(result), 0L)
})

# nolint start: line_length_linter.
test_that(".check_labels_survey_choices_sym returns 0 rows when no choices sheet", {
  # nolint end
  x <- xlsform(
    survey = tibble::tibble(
      type = "text",
      name = "q1",
      `label::English (en)` = "Q",
      `label::French (fr)` = "Q"
    )
  )
  result <- idem:::.check_labels_survey_choices_sym(x)
  expect_equal(nrow(result), 0L)
})

# check_labels (Check B — via orchestrator, for backward compat)

test_that("check_labels errors when survey has language absent from choices", {
  x <- xlsform(
    survey = tibble::tibble(
      type = "select_one yn",
      name = "q1",
      `label::English (en)` = "Q",
      `label::French (fr)` = "Q"
    ),
    choices = tibble::tibble(
      list_name = "yn",
      name = c("yes", "no"),
      `label::English (en)` = c("Yes", "No")
      # French missing from choices
    )
  )
  result <- check_labels(x)
  expect_true(any(result$severity == "error"))
  expect_true(any(stringr::str_detect(result$detail, "French \\(fr\\)")))
  expect_true(any(stringr::str_detect(
    result$detail,
    "survey label.*not.*choices"
  )))
})

test_that("check_labels errors when choices has language absent from survey", {
  x <- xlsform(
    survey = tibble::tibble(
      type = "select_one yn",
      name = "q1",
      `label::English (en)` = "Q"
      # French missing from survey
    ),
    choices = tibble::tibble(
      list_name = "yn",
      name = c("yes", "no"),
      `label::English (en)` = c("Yes", "No"),
      `label::French (fr)` = c("Oui", "Non")
    )
  )
  result <- check_labels(x)
  expect_true(any(result$severity == "error"))
  expect_true(any(stringr::str_detect(result$detail, "French \\(fr\\)")))
  expect_true(any(stringr::str_detect(
    result$detail,
    "choices label.*not.*survey"
  )))
})

test_that("check_labels passes when survey and choices label languages match", {
  x <- xlsform(
    survey = tibble::tibble(
      type = "select_one yn",
      name = "q1",
      `label::English (en)` = "Q",
      `label::French (fr)` = "Q"
    ),
    choices = tibble::tibble(
      list_name = "yn",
      name = c("yes", "no"),
      `label::English (en)` = c("Yes", "No"),
      `label::French (fr)` = c("Oui", "Non")
    ),
    settings = tibble::tibble(default_language = "English (en)")
  )
  result <- check_labels(x)
  expect_equal(nrow(result), 0L)
})

test_that("check_labels skips symmetry check when no choices sheet", {
  x <- xlsform(
    survey = tibble::tibble(
      type = "text",
      name = "q1",
      `label::English (en)` = "Q",
      `label::French (fr)` = "Q"
    ),
    settings = tibble::tibble(default_language = "English (en)")
  )
  result <- check_labels(x)
  expect_equal(nrow(result), 0L)
})

# ── .check_labels_nonlabel_mismatch (Check C) ─────────────────────────────────

# nolint start: line_length_linter.
test_that(".check_labels_nonlabel_mismatch errors on hint language not declared on label", {
  # nolint end
  # labels: en + fr; hint: es — mismatch
  x <- xlsform(
    survey = tibble::tibble(
      type = "text",
      name = "q1",
      `label::English (en)` = "Q",
      `label::French (fr)` = "Q",
      `hint::Spanish (es)` = "Pista"
    )
  )
  result <- idem:::.check_labels_nonlabel_mismatch(x)
  expect_s3_class(result, "tbl_df")
  expect_named(result, c("check", "severity", "name", "list_name", "detail"))
  expect_gte(nrow(result), 1L)
  expect_true(all(result$severity == "error"))
  expect_true(any(stringr::str_detect(result$detail, "Spanish \\(es\\)")))
})

# nolint start: line_length_linter.
test_that(".check_labels_nonlabel_mismatch errors on constraint_message language not in labels", {
  # nolint end
  # labels: en only; constraint_message: de — mismatch
  x <- xlsform(
    survey = tibble::tibble(
      type = "text",
      name = "q1",
      `label::English (en)` = "Q",
      `constraint_message::german (de)` = "Falsch"
    )
  )
  result <- idem:::.check_labels_nonlabel_mismatch(x)
  expect_gte(nrow(result), 1L)
  expect_true(all(result$severity == "error"))
})

# nolint start: line_length_linter.
test_that(".check_labels_nonlabel_mismatch returns 0 rows when hint matches labels", {
  # nolint end
  x <- xlsform(
    survey = tibble::tibble(
      type = "text",
      name = "q1",
      `label::English (en)` = "Q",
      `label::French (fr)` = "Q",
      `hint::English (en)` = "Hint",
      `hint::French (fr)` = "Indice"
    )
  )
  result <- idem:::.check_labels_nonlabel_mismatch(x)
  expect_equal(nrow(result), 0L)
})

# nolint start: line_length_linter.
test_that(".check_labels_nonlabel_mismatch returns 0 rows when no non-label fields present", {
  # nolint end
  x <- xlsform(
    survey = tibble::tibble(
      type = "text",
      name = "q1",
      `label::English (en)` = "Q"
    )
  )
  result <- idem:::.check_labels_nonlabel_mismatch(x)
  expect_equal(nrow(result), 0L)
})

# check_labels (Check C — via orchestrator, for backward compat)

test_that("check_labels errors on hint language not declared on label", {
  # labels: en + fr; hint: es — mismatch
  x <- xlsform(
    survey = tibble::tibble(
      type = "text",
      name = "q1",
      `label::English (en)` = "Q",
      `label::French (fr)` = "Q",
      `hint::Spanish (es)` = "Pista"
    )
  )
  result <- check_labels(x)
  expect_gte(nrow(result), 1L)
  expect_true(any(result$severity == "error"))
  expect_true(any(result$check == "labels"))
})

test_that("check_labels errors on constraint_message language not in labels", {
  # labels: en only; constraint_message: de — mismatch
  x <- xlsform(
    survey = tibble::tibble(
      type = "text",
      name = "q1",
      `label::English (en)` = "Q",
      `constraint_message::german (de)` = "Falsch"
    )
  )
  result <- check_labels(x)
  expect_gte(nrow(result), 1L)
  expect_true(any(result$severity == "error"))
})

test_that("check_labels does not error when hint languages match labels", {
  x <- xlsform(
    survey = tibble::tibble(
      type = "text",
      name = "q1",
      `label::English (en)` = "Q",
      `label::French (fr)` = "Q",
      `hint::English (en)` = "Hint",
      `hint::French (fr)` = "Indice"
    )
  )
  result <- check_labels(x)
  # No errors — only the default_language warning fires (no settings sheet)
  expect_true(all(result$severity != "error"))
})

test_that("check_labels does not error when hint matches single label lang", {
  x <- xlsform(
    survey = tibble::tibble(
      type = "text",
      name = "q1",
      `label::English (en)` = "Q",
      `hint::English (en)` = "Hint"
    )
  )
  result <- check_labels(x)
  expect_equal(nrow(result), 0L)
})

# ── .check_labels_default_language (Check D) ──────────────────────────────────

# nolint start: line_length_linter.
test_that(".check_labels_default_language returns 0 rows for a single-language form", {
  # nolint end
  x <- xlsform(
    survey = tibble::tibble(
      type = "text",
      name = "q1",
      `label::English (en)` = "Q"
    )
  )
  result <- idem:::.check_labels_default_language(x)
  expect_s3_class(result, "tbl_df")
  expect_named(result, c("check", "severity", "name", "list_name", "detail"))
  expect_equal(nrow(result), 0L)
})

# nolint start: line_length_linter.
test_that(".check_labels_default_language warns when multi-language form has no settings", {
  # nolint end
  x <- xlsform(
    survey = tibble::tibble(
      type = "text",
      name = "q1",
      `label::English (en)` = "Q",
      `label::French (fr)` = "Q"
    )
  )
  result <- idem:::.check_labels_default_language(x)
  expect_equal(nrow(result), 1L)
  expect_equal(result$severity, "warning")
  expect_equal(result$check, "labels")
})

# nolint start: line_length_linter.
test_that(".check_labels_default_language warns when settings has no default_language column", {
  # nolint end
  x <- xlsform(
    survey = tibble::tibble(
      type = "text",
      name = "q1",
      `label::English (en)` = "Q",
      `label::French (fr)` = "Q"
    ),
    settings = tibble::tibble(form_title = "Test")
  )
  result <- idem:::.check_labels_default_language(x)
  expect_equal(nrow(result), 1L)
  expect_equal(result$severity, "warning")
})

test_that(".check_labels_default_language warns when default_language is NA", {
  x <- xlsform(
    survey = tibble::tibble(
      type = "text",
      name = "q1",
      `label::English (en)` = "Q",
      `label::French (fr)` = "Q"
    ),
    settings = tibble::tibble(default_language = NA_character_)
  )
  result <- idem:::.check_labels_default_language(x)
  expect_equal(nrow(result), 1L)
  expect_equal(result$severity, "warning")
})

# nolint start: line_length_linter.
test_that(".check_labels_default_language warns when default_language is empty string", {
  # nolint end
  x <- xlsform(
    survey = tibble::tibble(
      type = "text",
      name = "q1",
      `label::English (en)` = "Q",
      `label::French (fr)` = "Q"
    ),
    settings = tibble::tibble(default_language = "")
  )
  result <- idem:::.check_labels_default_language(x)
  expect_equal(nrow(result), 1L)
  expect_equal(result$severity, "warning")
})

# nolint start: line_length_linter.
test_that(".check_labels_default_language returns 0 rows when default_language is set correctly", {
  # nolint end
  x <- xlsform(
    survey = tibble::tibble(
      type = "text",
      name = "q1",
      `label::English (en)` = "Q",
      `label::French (fr)` = "Q"
    ),
    settings = tibble::tibble(default_language = "English (en)")
  )
  result <- idem:::.check_labels_default_language(x)
  expect_equal(nrow(result), 0L)
})

# check_labels (Check D — via orchestrator, for backward compat)

test_that("check_labels does not warn for a single-language form", {
  x <- xlsform(
    survey = tibble::tibble(
      type = "text",
      name = "q1",
      `label::English (en)` = "Q"
    )
  )
  result <- check_labels(x)
  expect_equal(nrow(result), 0L)
})

test_that("check_labels warns when multi-language form has no settings", {
  x <- xlsform(
    survey = tibble::tibble(
      type = "text",
      name = "q1",
      `label::English (en)` = "Q",
      `label::French (fr)` = "Q"
    )
  )
  result <- check_labels(x)
  expect_equal(nrow(result), 1L)
  expect_equal(result$severity, "warning")
  expect_equal(result$check, "labels")
})

test_that("check_labels warns when settings has no default_language column", {
  x <- xlsform(
    survey = tibble::tibble(
      type = "text",
      name = "q1",
      `label::English (en)` = "Q",
      `label::French (fr)` = "Q"
    ),
    settings = tibble::tibble(form_title = "Test")
  )
  result <- check_labels(x)
  expect_equal(nrow(result), 1L)
  expect_equal(result$severity, "warning")
})

test_that("check_labels warns when default_language is NA", {
  x <- xlsform(
    survey = tibble::tibble(
      type = "text",
      name = "q1",
      `label::English (en)` = "Q",
      `label::French (fr)` = "Q"
    ),
    settings = tibble::tibble(default_language = NA_character_)
  )
  result <- check_labels(x)
  expect_equal(nrow(result), 1L)
  expect_equal(result$severity, "warning")
})

test_that("check_labels warns when default_language is empty string", {
  x <- xlsform(
    survey = tibble::tibble(
      type = "text",
      name = "q1",
      `label::English (en)` = "Q",
      `label::French (fr)` = "Q"
    ),
    settings = tibble::tibble(default_language = "")
  )
  result <- check_labels(x)
  expect_equal(nrow(result), 1L)
  expect_equal(result$severity, "warning")
})

test_that("check_labels does not warn when default_language is set correctly", {
  x <- xlsform(
    survey = tibble::tibble(
      type = "text",
      name = "q1",
      `label::English (en)` = "Q",
      `label::French (fr)` = "Q"
    ),
    settings = tibble::tibble(default_language = "English (en)")
  )
  result <- check_labels(x)
  expect_equal(nrow(result), 0L)
})

test_that("check_labels returns 0 rows for fixture form loaded with settings", {
  form <- read_xlsform(
    system.file("extdata/form.xlsx", package = "idem"),
    optional_sheets = "settings"
  )
  result <- check_labels(form)
  expect_equal(nrow(result), 0L)
})
