test_that("as_labelled_spss_survey converts labelled_spss correctly", {
  x <- haven::labelled_spss(
    x = c(1, 2, 9),
    labels = c(yes = 1, no = 2, dk = 9),
    na_values = 9,
    label = "Question"
  )

  result <- as_labelled_spss_survey(x, id = "za001")

  expect_s3_class(
    result,
    "retroharmonize_labelled_spss_survey"
  )

  expect_equal(
    labelled::val_labels(result),
    c(yes = 1, no = 2, dk = 9)
  )

  expect_equal(
    labelled::na_values(result),
    9
  )

  expect_equal(
    attr(result, "label"),
    "Question"
  )

  expect_equal(
    attr(result, "id"),
    "za001"
  )
})

test_that("as_labelled_spss_survey converts haven_labelled correctly", {
  x <- labelled::labelled(
    c(1, 2, 1),
    labels = c(yes = 1, no = 2)
  )

  result <- as_labelled_spss_survey(x, id = "survey_a")

  expect_s3_class(
    result,
    "retroharmonize_labelled_spss_survey"
  )

  expect_equal(
    labelled::val_labels(result),
    c(yes = 1, no = 2)
  )

  expect_equal(
    attr(result, "id"),
    "survey_a"
  )
})

test_that("as_labelled_spss_survey stores original object name", {
  my_variable <- haven::labelled_spss(
    x = c(1, 2),
    labels = c(yes = 1, no = 2)
  )

  result <- as_labelled_spss_survey(
    my_variable,
    id = "s1"
  )

  expect_equal(
    attr(result, "s1_name"),
    "my_variable"
  )
})

test_that("as_labelled_spss_survey errors on non-labelled input", {
  expect_error(
    as_labelled_spss_survey(
      c(1, 2, 3),
      id = "bad"
    ),
    "should be a haven_labelled"
  )
})
