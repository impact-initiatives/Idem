# ── xlsform_choices ───────────────────────────────────────────────────────────

test_that("xlsform_choices returns a named list", {
  x <- fixture_xlsform()
  result <- xlsform_choices(x)
  expect_type(result, "list")
  expect_named(result)
})

test_that("xlsform_choices groups options by list_name", {
  x <- fixture_xlsform()
  result <- xlsform_choices(x)
  expect_equal(sort(names(result)), c("list_a", "list_b"))
  expect_setequal(result[["list_a"]], c("opt1", "opt2"))
  expect_setequal(result[["list_b"]], c("opt3", "opt4"))
})

test_that("xlsform_choices includes external_choices when present", {
  x <- fixture_xlsform()
  x$external_choices <- tibble::tibble(
    list_name = "list_ext",
    name = "ext_opt1"
  )
  result <- xlsform_choices(x)
  expect_true("list_ext" %in% names(result))
  expect_equal(result[["list_ext"]], "ext_opt1")
})

test_that("xlsform_choices drops NA names", {
  x <- fixture_xlsform(
    choice_names = c("opt1", NA, "opt3", "opt4")
  )
  result <- xlsform_choices(x)
  expect_false(any(is.na(result[["list_a"]])))
  expect_equal(result[["list_a"]], "opt1")
})

test_that("xlsform_choices.default errors on non-xlsform", {
  expect_error(xlsform_choices(list()), class = "rlang_error")
})
