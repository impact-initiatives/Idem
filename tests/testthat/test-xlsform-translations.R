# ── is_translated_col ─────────────────────────────────────────────────────────

test_that("is_translated_col returns TRUE for valid translated columns", {
  valid <- c(
    "label::English (en)",
    "label::French (fr)",
    "label::Français (fr)",
    "label::Український (uk)",
    "label::Հայերեն (hy)",
    "label::Arabic (arab)",
    "label::English (eng)",
    "label::Română (ro)",
    "label::Русский (ru)",
    "label::Українська (uk)",
    "label::Sinhalese (si)",
    "label::Swahili (sw)",
    "label::Tamil (oty)",
    "label::Somali (so)",
    "label::Arabic (ar)",
    "label::Portuguese (pt)",
    "hint::English (en)",
    "guidance_hint::French (fr)",
    "constraint_message::English (en)",
    "required_message::Français (fr)",
    "image::English (en)",
    "audio::French (fr)",
    "video::English (en)"
  )
  expect_true(all(is_translated_col(valid)))
})

test_that("is_translated_col accepts whitespace-padded column names", {
  expect_true(is_translated_col(" label::English (en) "))
  expect_true(is_translated_col("  hint::French (fr)  "))
})

test_that("is_translated_col returns FALSE for bare translatable fields", {
  bare <- c(
    "label",
    "hint",
    "guidance_hint",
    "constraint_message",
    "required_message",
    "image",
    "audio",
    "video"
  )
  expect_true(all(!is_translated_col(bare)))
})

test_that("is_translated_col returns FALSE for missing parenthesised code", {
  no_code <- c(
    "label::English",
    "label::Français",
    "label::Հայերեն",
    "label::հայերեն",
    "label::Swahili",
    "label::french",
    "label::arabic",
    "label::creole",
    "label::Pashto",
    "label::Kurdish",
    "label::Ukrainian",
    "label::Sango",
    "label::Rohingya",
    "label::Dari",
    "label::Bangla",
    "label::lingala",
    "label::Pushto",
    "label::somali",
    "label::bangla",
    "label::english",
    "label::swahili",
    "label::kreyol",
    "label::Pashtu",
    "label::Kreol",
    "label::Russian",
    "label::Portuguese",
    "label::Kurdish",
    "label::Українська",
    "label::Русский",
    "label::French"
  )
  expect_true(all(!is_translated_col(no_code)))
})

test_that("is_translated_col returns FALSE when code has no space before it", {
  no_space <- c(
    "label::English(en)",
    "label::Spanish(es)",
    "label::Portuguese(pt)",
    "label::French(fr)"
  )
  expect_true(all(!is_translated_col(no_space)))
})

test_that("is_translated_col returns FALSE for uppercase ISO codes", {
  uppercase_code <- c(
    "label::French (FR)",
    "label::Kreol (KR)",
    "label::English (EN)",
    "label::Arabic (ARAB)"
  )
  expect_true(all(!is_translated_col(uppercase_code)))
})

test_that("is_translated_col returns FALSE for malformed separators", {
  bad_sep <- c(
    "label..English..en.",
    "label_creole",
    "label_group_var",
    "label.question",
    "label.x",
    "label:Kreyol",
    "label:: Swahili",
    "label..english"
  )
  expect_true(all(!is_translated_col(bad_sep)))
})

test_that("is_translated_col returns FALSE for bare code or other edge cases", {
  edge <- c(
    "label::en",
    "label::codes",
    "label::count",
    "label_analysis_var",
    "label_analysis_key",
    "label_municipio",
    "label_number_manual",
    "label_question",
    "label_analysis_type",
    "label_analysis_var_value",
    "label_group_var_value"
  )
  expect_true(all(!is_translated_col(edge)))
})

test_that("is_translated_col returns FALSE for unrecognised field prefixes", {
  unknown_fields <- c(
    "non_translatable::English (en)",
    "type::English (en)",
    "name::French (fr)",
    "list_name::English (en)"
  )
  expect_true(all(!is_translated_col(unknown_fields)))
})

test_that("is_translated_col is vectorised and returns mixed results", {
  mixed <- c(
    "label::English (en)", # TRUE
    "label::French (FR)", # FALSE — uppercase code
    "label", # FALSE — bare
    "label::Français (fr)", # TRUE
    "label::English(en)", # FALSE — no space
    "hint::Swahili (sw)" # TRUE
  )
  expect_equal(
    is_translated_col(mixed),
    c(TRUE, FALSE, FALSE, TRUE, FALSE, TRUE)
  )
})

# ── xlsform_translations ──────────────────────────────────────────────────────

test_that("xlsform_translations returns a tibble with 4 columns", {
  x <- xlsform(
    survey = tibble::tibble(type = "text", name = "q1")
  )
  result <- xlsform_translations(x)
  expect_s3_class(result, "tbl_df")
  expect_named(result, c("sheet", "field", "language", "column"))
})

test_that("xlsform_translations returns 0 rows when no translated cols exist", {
  x <- xlsform(
    survey = tibble::tibble(type = "text", name = "q1", label = "Question 1")
  )
  result <- xlsform_translations(x)
  expect_equal(nrow(result), 0L)
})

test_that("xlsform_translations finds translated cols in survey", {
  x <- xlsform(
    survey = tibble::tibble(
      type = "text",
      name = "q1",
      `label::English (en)` = "Question 1",
      `hint::French (fr)` = "Indice"
    )
  )
  result <- xlsform_translations(x)
  expect_equal(nrow(result), 2L)
  expect_true(all(result$sheet == "survey"))
  expect_setequal(result$field, c("label", "hint"))
  expect_setequal(result$language, c("English (en)", "French (fr)"))
})

test_that("xlsform_translations finds translated cols in choices", {
  x <- xlsform(
    survey = tibble::tibble(
      type = "select_one yn",
      name = "q1",
      `label::English (en)` = "Question"
    ),
    choices = tibble::tibble(
      list_name = "yn",
      name = c("yes", "no"),
      `label::English (en)` = c("Yes", "No"),
      `label::French (fr)` = c("Oui", "Non")
    )
  )
  result <- xlsform_translations(x)
  choices_rows <- result[result$sheet == "choices", ]
  expect_equal(nrow(choices_rows), 2L)
  expect_setequal(choices_rows$language, c("English (en)", "French (fr)"))
})

test_that("xlsform_translations ignores non-translatable columns", {
  x <- xlsform(
    survey = tibble::tibble(
      type = "text",
      name = "q1",
      relevant = "1",
      required = "yes",
      `label::English (en)` = "Q"
    )
  )
  result <- xlsform_translations(x)
  expect_equal(nrow(result), 1L)
  expect_equal(result$field, "label")
})

test_that("xlsform_translations ignores invalid-format translatable cols", {
  x <- xlsform(
    survey = tibble::tibble(
      type = "text",
      name = "q1",
      label = "Bare label",
      `label::English` = "No code",
      `label::English(en)` = "No space",
      `label::English (en)` = "Valid"
    )
  )
  result <- xlsform_translations(x)
  expect_equal(nrow(result), 1L)
  expect_equal(result$column, "label::English (en)")
})

test_that("xlsform_translations handles whitespace-padded column names", {
  x <- xlsform(
    survey = stats::setNames(
      tibble::tibble("text", "q1", "Question"),
      c("type", "name", " label::English (en) ")
    )
  )
  result <- xlsform_translations(x)
  expect_equal(nrow(result), 1L)
  expect_equal(result$field, "label")
  expect_equal(result$language, "English (en)")
  expect_equal(result$column, " label::English (en) ")
})

test_that("xlsform_translations.default errors on non-xlsform input", {
  expect_error(xlsform_translations(list()), class = "rlang_error")
  expect_error(xlsform_translations("a string"), class = "rlang_error")
})

test_that("xlsform_translations returns correct rows for real fixture", {
  form <- read_xlsform(system.file("extdata/form.xlsx", package = "Idem"))
  result <- xlsform_translations(form)
  expect_s3_class(result, "tbl_df")
  expect_named(result, c("sheet", "field", "language", "column"))
  # fixture: survey — label (en/fr), hint (en/fr), constraint_message (en/fr)
  # choices — label (en/fr) = 8 rows total
  expect_equal(nrow(result), 8L)
  expect_setequal(unique(result$sheet), c("survey", "choices"))
  expect_setequal(
    unique(result$field),
    c("label", "hint", "constraint_message")
  )
})
