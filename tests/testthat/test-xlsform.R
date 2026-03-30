# ── xlsform constructor ───────────────────────────────────────────────────────

test_that("xlsform() returns an xlsform object", {
  x <- xlsform(
    survey = data.frame(type = "text", name = "q1"),
    choices = data.frame(list_name = character(), name = character())
  )
  expect_s3_class(x, "xlsform")
  expect_named(x, c("survey", "choices"))
})

test_that("xlsform() sets path attribute to NA by default", {
  x <- xlsform(survey = data.frame(type = "text", name = "q1"))
  expect_true(is.na(attr(x, "path")))
})

test_that("xlsform() accepts a custom path", {
  x <- xlsform(
    survey = data.frame(type = "text", name = "q1"),
    path = "a/b.xlsx"
  )
  expect_equal(attr(x, "path"), "a/b.xlsx")
})

test_that("xlsform() errors when no sheets are provided", {
  expect_error(xlsform(), class = "rlang_error")
})

test_that("xlsform() errors when a sheet is unnamed", {
  expect_error(
    xlsform(data.frame(type = "text", name = "q1")),
    class = "rlang_error"
  )
})

test_that("xlsform() errors when a sheet is not a data frame", {
  expect_error(
    xlsform(survey = list(type = "text", name = "q1")),
    class = "rlang_error"
  )
})

test_that("xlsform() produces the same structure as read_xlsform()", {
  path <- system.file("extdata/form.xlsx", package = "Idem")
  from_file <- read_xlsform(path)
  from_dfs <- xlsform(
    survey = from_file$survey,
    choices = from_file$choices,
    path = path
  )
  expect_equal(class(from_file), class(from_dfs))
  expect_equal(names(from_file), names(from_dfs))
  expect_equal(attr(from_file, "path"), attr(from_dfs, "path"))
})

# ── read_xlsform ──────────────────────────────────────────────────────────────

test_that("read_xlsform errors when a required sheet is missing", {
  path <- system.file("extdata/form.xlsx", package = "Idem")
  expect_error(
    read_xlsform(path, required_sheets = c("survey", "external_choices")),
    class = "rlang_error"
  )
})

test_that("read_xlsform warns and excludes a missing optional sheet", {
  path <- system.file("extdata/form.xlsx", package = "Idem")
  expect_warning(
    form <- read_xlsform(path, optional_sheets = "external_choices"),
    regexp = "external_choices"
  )
  expect_null(form$external_choices)
  expect_s3_class(form, "xlsform")
})

test_that("read_xlsform includes an optional sheet when present", {
  path <- system.file("extdata/form.xlsx", package = "Idem")
  # "choices" is present in the form; request it as optional
  form <- read_xlsform(
    path,
    required_sheets = "survey",
    optional_sheets = "choices"
  )
  expect_true("choices" %in% names(form))
  expect_s3_class(form, "xlsform")
})
