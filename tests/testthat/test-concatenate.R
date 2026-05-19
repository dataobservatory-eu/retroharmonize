test_that("concatenate() preserves labelled class", {
  v1 <- haven::labelled_spss(
    x = c(1, 2),
    labels = c(YES = 1, NO = 2),
    na_values = 9,
    label = "Example"
  )

  v2 <- haven::labelled_spss(
    x = c(2, 1),
    labels = c(YES = 1, NO = 2),
    na_values = 9,
    label = "Example"
  )

  result <- concatenate(v1, v2)

  expect_true(
    haven::is.labelled(result)
  )

  expect_true(
    inherits(result, "haven_labelled_spss")
  )
})


test_that("concatenate() preserves labels", {
  v1 <- haven::labelled_spss(
    x = c(1, 2),
    labels = c(YES = 1, NO = 2),
    na_values = 9,
    label = "Example"
  )

  v2 <- haven::labelled_spss(
    x = c(2, 1),
    labels = c(YES = 1, NO = 2),
    na_values = 9,
    label = "Example"
  )

  result <- concatenate(v1, v2)

  expect_equal(
    labelled::val_labels(result),
    c(YES = 1, NO = 2)
  )

  expect_equal(
    labelled::var_label(result),
    "Example"
  )
})


test_that("concatenate() concatenates values", {
  v1 <- haven::labelled_spss(
    x = c(1, 2),
    labels = c(YES = 1, NO = 2),
    na_values = 9
  )

  v2 <- haven::labelled_spss(
    x = c(2, 1),
    labels = c(YES = 1, NO = 2),
    na_values = 9
  )

  result <- concatenate(v1, v2)

  expect_equal(
    as.vector(result),
    c(1, 2, 2, 1)
  )
})


test_that("concatenate() errors on incompatible labels", {
  v1 <- haven::labelled_spss(
    x = c(1, 2),
    labels = c(YES = 1, NO = 2),
    na_values = 9
  )

  v2 <- haven::labelled_spss(
    x = c(1, 2),
    labels = c("TRUE" = 1, "FALSE" = 2),
    na_values = 9
  )

  expect_warning(
    concatenate(v1, v2)
  )
})
