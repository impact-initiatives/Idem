# ── validate_question_names ───────────────────────────────────────────────────

test_that("validate_question_names returns 0 rows when forms are identical", {
  x <- fixture_xlsform()
  result <- validate_question_names(x, x)
  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 0L)
  expect_named(result, c("check", "severity", "name", "list_name", "detail"))
})

test_that("validate_question_names reports questions missing from dev", {
  # target has q3; dev only has q1 + q2 — q3 should be flagged
  dev <- fixture_xlsform(
    survey_names = c("q1", "q2"),
    survey_types = c("select_one list_a", "text")
  )
  result <- validate_question_names(fixture_xlsform(), dev)
  expect_equal(nrow(result), 1L)
  expect_equal(result$name, "q3")
  expect_equal(result$check, "question_names")
})

test_that("validate_question_names does not report questions only in dev", {
  # dev has q3 but target doesn't — no issue, dev is allowed extras
  target <- fixture_xlsform(
    survey_names = c("q1", "q2"),
    survey_types = c("select_one list_a", "text")
  )
  result <- validate_question_names(target, fixture_xlsform())
  expect_equal(nrow(result), 0L)
})

test_that("validate_question_names errors on non-xlsform target", {
  x <- fixture_xlsform()
  expect_error(validate_question_names(list(), x), class = "rlang_error")
})

test_that("validate_question_names errors on non-xlsform dev", {
  x <- fixture_xlsform()
  expect_error(validate_question_names(x, list()), class = "rlang_error")
})

# ── validate_list_names ───────────────────────────────────────────────────────

test_that("validate_list_names returns 0 rows when forms are identical", {
  x <- fixture_xlsform()
  result <- validate_list_names(x, x)
  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 0L)
  expect_named(result, c("check", "severity", "name", "list_name", "detail"))
})

test_that("validate_list_names reports lists in target missing from dev", {
  # target defines list_b; dev only defines list_a — list_b should be flagged
  target <- fixture_xlsform(
    survey_types = c("select_one list_a", "select_one list_b"),
    survey_names = c("q1", "q2"),
    choice_lists = c("list_a", "list_b"),
    choice_names = c("opt1", "opt2")
  )
  dev <- fixture_xlsform(
    survey_types = c("select_one list_a", "text"),
    survey_names = c("q1", "q2"),
    choice_lists = "list_a",
    choice_names = "opt1"
  )
  result <- validate_list_names(target, dev)
  expect_equal(nrow(result), 1L)
  expect_equal(result$name, "list_b")
  expect_equal(result$check, "list_names")
})

test_that("validate_list_names does not report lists only in dev", {
  # dev defines list_b but target doesn't require it — no issue
  dev <- fixture_xlsform(
    survey_types = c("select_one list_a", "select_one list_b"),
    survey_names = c("q1", "q2"),
    choice_lists = c("list_a", "list_b"),
    choice_names = c("opt1", "opt2")
  )
  target <- fixture_xlsform(
    survey_types = c("select_one list_a", "text"),
    survey_names = c("q1", "q2"),
    choice_lists = "list_a",
    choice_names = "opt1"
  )
  result <- validate_list_names(target, dev)
  expect_equal(nrow(result), 0L)
})

test_that("validate_list_names catches list in target absent from dev", {
  # list_b is in target's choices but NOT in dev's choices — flagged
  target <- xlsform(
    survey = tibble::tibble(
      type = c("select_one list_a", "text"),
      name = c("q1", "q2")
    ),
    choices = tibble::tibble(
      list_name = c("list_a", "list_b"),
      name = c("opt1", "opt2")
    )
  )
  dev <- fixture_xlsform(
    survey_types = c("select_one list_a", "text"),
    survey_names = c("q1", "q2"),
    choice_lists = "list_a",
    choice_names = "opt1"
  )
  result <- validate_list_names(target, dev)
  expect_equal(nrow(result), 1L)
  expect_equal(result$name, "list_b")
})

test_that("validate_list_names errors on non-xlsform inputs", {
  x <- fixture_xlsform()
  expect_error(validate_list_names(list(), x), class = "rlang_error")
  expect_error(validate_list_names(x, list()), class = "rlang_error")
})

# ── validate_survey_list_names ────────────────────────────────────────────────

test_that("validate_survey_list_names returns 0 rows on identical forms", {
  x <- fixture_xlsform()
  result <- validate_survey_list_names(x, x)
  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 0L)
  expect_named(result, c("check", "severity", "name", "list_name", "detail"))
})

test_that("validate_survey_list_names reports lists absent from dev", {
  # target references list_b; dev only references list_a — list_b flagged
  target <- fixture_xlsform()
  dev <- fixture_xlsform(
    survey_types = c("select_one list_a", "text"),
    survey_names = c("q1", "q2"),
    choice_lists = "list_a",
    choice_names = "opt1"
  )
  result <- validate_survey_list_names(target, dev)
  expect_equal(nrow(result), 1L)
  expect_equal(result$name, "list_b")
  expect_equal(result$check, "survey_list_names")
})

test_that("validate_survey_list_names does not report lists only in dev", {
  # dev references list_b but target doesn't require it — no issue
  dev <- fixture_xlsform()
  target <- fixture_xlsform(
    survey_types = c("select_one list_a", "text"),
    survey_names = c("q1", "q2"),
    choice_lists = "list_a",
    choice_names = "opt1"
  )
  result <- validate_survey_list_names(target, dev)
  expect_equal(nrow(result), 0L)
})

test_that("validate_survey_list_names catches type change to non-select", {
  # dev changed all questions to text — target's lists are all missing from dev
  target <- fixture_xlsform()
  dev <- xlsform(
    survey = tibble::tibble(
      type = c("text", "text"),
      name = c("q1", "q2")
    ),
    choices = tibble::tibble(
      list_name = c("list_a", "list_a", "list_b", "list_b"),
      name = c("opt1", "opt2", "opt3", "opt4")
    )
  )
  result <- validate_survey_list_names(target, dev)
  expect_true("list_a" %in% result$name)
  expect_true("list_b" %in% result$name)
})

test_that("validate_survey_list_names errors on non-xlsform inputs", {
  x <- fixture_xlsform()
  expect_error(validate_survey_list_names(list(), x), class = "rlang_error")
  expect_error(validate_survey_list_names(x, list()), class = "rlang_error")
})

# ── validate_choices ──────────────────────────────────────────────────────────

test_that("validate_choices returns 0 rows when forms are identical", {
  x <- fixture_xlsform()
  result <- validate_choices(x, x)
  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 0L)
  expect_named(
    result,
    c("check", "severity", "name", "list_name", "detail")
  )
})

test_that("validate_choices reports options in target missing from dev", {
  # target has opt3 in list_a; dev only has opt1 + opt2 — opt3 flagged
  target <- fixture_xlsform(
    choice_lists = c("list_a", "list_a", "list_a"),
    choice_names = c("opt1", "opt2", "opt3")
  )
  dev <- fixture_xlsform(
    choice_lists = c("list_a", "list_a"),
    choice_names = c("opt1", "opt2")
  )
  result <- validate_choices(target, dev)
  expect_equal(nrow(result), 1L)
  expect_equal(result$name, "opt3")
  expect_equal(result$list_name, "list_a")
  expect_equal(result$check, "choices")
})

test_that("validate_choices does not report options only in dev", {
  # dev has opt3 but target doesn't require it — no issue
  dev <- fixture_xlsform(
    choice_lists = c("list_a", "list_a", "list_a"),
    choice_names = c("opt1", "opt2", "opt3")
  )
  target <- fixture_xlsform(
    choice_lists = c("list_a", "list_a"),
    choice_names = c("opt1", "opt2")
  )
  result <- validate_choices(target, dev)
  expect_equal(nrow(result), 0L)
})

test_that("validate_choices skips lists present only in target", {
  # list_b is only in target — validate_choices should NOT report it
  # (that is validate_list_names' job)
  target <- fixture_xlsform(
    survey_types = c("select_one list_a", "select_one list_b"),
    survey_names = c("q1", "q2"),
    choice_lists = c("list_a", "list_b"),
    choice_names = c("opt1", "opt2")
  )
  dev <- fixture_xlsform(
    survey_types = c("select_one list_a", "text"),
    survey_names = c("q1", "q2"),
    choice_lists = "list_a",
    choice_names = "opt1"
  )
  result <- validate_choices(target, dev)
  expect_true(all(result$list_name != "list_b" | nrow(result) == 0L))
})

test_that("validate_choices errors on non-xlsform inputs", {
  x <- fixture_xlsform()
  expect_error(validate_choices(list(), x), class = "rlang_error")
  expect_error(validate_choices(x, list()), class = "rlang_error")
})

# ── validate_xlsform ──────────────────────────────────────────────────────────

test_that("validate_xlsform returns 0 rows when forms are identical", {
  x <- fixture_xlsform()
  result <- validate_xlsform(x, x)
  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 0L)
  expect_named(result, c("check", "severity", "name", "list_name", "detail"))
})

test_that("validate_xlsform combines results from multiple checks", {
  # target has q_new and list_a opt1; dev is missing both
  target <- fixture_xlsform(
    survey_names = c("q1", "q2", "q_new"),
    survey_types = c("select_one list_a", "text", "text"),
    choice_lists = "list_a",
    choice_names = "opt1"
  )
  dev <- fixture_xlsform(
    survey_names = c("q1", "q2"),
    survey_types = c("select_one list_a", "text"),
    choice_lists = "list_a",
    choice_names = "opt1"
  )
  result <- validate_xlsform(target, dev)
  expect_true(any(result$check == "question_names"))
  expect_true("q_new" %in% result$name)
})

test_that("validate_xlsform respects the checks argument", {
  target <- fixture_xlsform(
    survey_names = c("q1", "q2", "q_new"),
    survey_types = c("select_one list_a", "text", "text"),
    choice_lists = "list_a",
    choice_names = "opt1"
  )
  dev <- fixture_xlsform(
    survey_names = c("q1", "q2"),
    survey_types = c("select_one list_a", "text"),
    choice_lists = "list_a",
    choice_names = "opt1"
  )
  result <- validate_xlsform(target, dev, checks = "list_names")
  expect_true(all(result$check == "list_names") || nrow(result) == 0L)
  expect_false(any(result$check == "question_names"))
})

test_that("validate_xlsform errors on unknown checks", {
  x <- fixture_xlsform()
  expect_error(
    validate_xlsform(x, x, checks = "bad_check"),
    class = "rlang_error"
  )
})

test_that("validate_xlsform errors on non-xlsform inputs", {
  x <- fixture_xlsform()
  expect_error(validate_xlsform(list(), x), class = "rlang_error")
  expect_error(validate_xlsform(x, list()), class = "rlang_error")
})


# ── integration tests with real form ──────────────────────────────────────────

test_that("validate_question_names flags a question missing from dev", {
  target <- read_xlsform(system.file("extdata/form.xlsx", package = "idem"))
  # dev is missing the last survey row that target has
  dev <- xlsform(
    survey = target$survey[-nrow(target$survey), ],
    choices = target$choices
  )
  result <- validate_question_names(target, dev)
  expect_s3_class(result, "tbl_df")
  expect_gte(nrow(result), 1L)
  expect_equal(result$check[[1L]], "question_names")
})

test_that("validate_list_names flags a list in target absent from dev", {
  target <- read_xlsform(system.file("extdata/form.xlsx", package = "idem"))
  dev_no_choices <- xlsform(
    survey = target$survey,
    choices = data.frame(list_name = character(), name = character())
  )
  result <- validate_list_names(target, dev_no_choices)
  expect_s3_class(result, "tbl_df")
  expect_gt(nrow(result), 0L)
  expect_true(all(result$check == "list_names"))
})

test_that("validate_survey_list_names flags lists in target absent from dev", {
  target <- read_xlsform(system.file("extdata/form.xlsx", package = "idem"))
  dev_no_selects <- xlsform(
    survey = data.frame(
      type = rep("text", nrow(target$survey)),
      name = target$survey$name
    ),
    choices = target$choices
  )
  result <- validate_survey_list_names(target, dev_no_selects)
  expect_s3_class(result, "tbl_df")
  expect_gt(nrow(result), 0L)
  expect_true(all(result$check == "survey_list_names"))
})

test_that("validate_choices flags a choice option in target missing from dev", {
  target <- read_xlsform(system.file("extdata/form.xlsx", package = "idem"))
  dev_trimmed <- xlsform(
    survey = target$survey,
    choices = target$choices[-nrow(target$choices), ]
  )
  result <- validate_choices(target, dev_trimmed)
  expect_s3_class(result, "tbl_df")
  expect_gte(nrow(result), 1L)
  expect_true(all(result$check == "choices"))
})
