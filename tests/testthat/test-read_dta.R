test_that("invalid dta file returns empty survey", {
  bad_file <- tempfile(fileext = ".dta")

  writeLines("not a dta file", bad_file)

  expect_warning(
    result <- read_dta(bad_file)
  )

  expect_true(is.survey(result))
  expect_equal(ncol(result), 0)
})

test_that("read_dta imports a stata file", {
  tmp_file <- tempfile(fileext = ".dta")

  test_df <- tibble::tibble(
    id = 1:3,
    country = c("HU", "DE", "FR")
  )

  haven::write_dta(
    test_df,
    tmp_file
  )

  result <- read_dta(tmp_file)

  expect_true(is.survey(result))
  expect_equal(nrow(result), 3)
})

test_that("rowid is created and normalized", {
  tmp_file <- tempfile(fileext = ".dta")

  test_df <- tibble::tibble(
    x = 1:3
  )

  haven::write_dta(
    test_df,
    tmp_file
  )

  result <- read_dta(
    tmp_file,
    id = "TEST"
  )

  expect_true("rowid" %in% names(result))

  expect_true(
    all(grepl("^TEST_", result$rowid))
  )
})


test_that("variable labels are preserved", {
  tmp_file <- tempfile(fileext = ".dta")

  test_df <- tibble::tibble(
    age = c(20, 30, 40)
  )

  labelled::var_label(test_df$age) <- "Age of respondent"

  haven::write_dta(
    test_df,
    tmp_file
  )

  result <- read_dta(tmp_file)

  expect_equal(
    labelled::var_label(result$age),
    "Age of respondent"
  )
})


test_that("provenance attributes are recorded", {
  tmp_file <- tempfile(fileext = ".dta")

  haven::write_dta(
    tibble::tibble(x = 1:3),
    tmp_file
  )

  result <- read_dta(tmp_file)

  expect_true(!is.null(attr(result, "object_size")))
  expect_true(!is.null(attr(result, "source_file_size")))
})
