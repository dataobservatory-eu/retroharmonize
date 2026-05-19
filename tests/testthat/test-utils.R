test_that("is.labelled_spss identifies haven_labelled_spss vectors", {
  
  x <- labelled::labelled_spss(
    x = c(1, 2, 9),
    labels = c(
      yes = 1,
      no = 2,
      inap = 9
    ),
    na_values = 9
  )
  
  expect_true(is.labelled_spss(x))
  expect_false(is.labelled_spss(1:3))
})

test_that("is.labelled identifies haven_labelled vectors", {
  
  x <- labelled::labelled(
    x = c(1, 2),
    labels = c(
      yes = 1,
      no = 2
    )
  )
  
  expect_true(is.labelled(x))
  expect_false(is.labelled("a"))
})

test_that("convert_to_labelled_spss adds default numeric missing labels", {
  
  x <- c(1, 2, 3)
  
  out <- convert_to_labelled_spss(x)
  
  expect_true(is.labelled_spss(out))
  
  expect_equal(
    labelled::na_values(out),
    c(inap = 99999)
  )
  
  expect_equal(
    labelled::val_labels(out),
    c(inap = 99999)
  )
})

test_that("convert_to_labelled_spss adds default character missing labels", {
  
  x <- c("a", "b")
  
  out <- convert_to_labelled_spss(x)
  
  expect_true(is.labelled_spss(out))
  
  expect_equal(
    labelled::na_values(out),
    c(inap = "inap")
  )
  
  expect_equal(
    labelled::val_labels(out),
    c(inap = "inap")
  )
})

test_that("convert_to_labelled_spss preserves existing labels", {
  
  x <- labelled::labelled(
    x = c(1, 2),
    labels = c(
      yes = 1,
      no = 2
    )
  )
  
  out <- convert_to_labelled_spss(x)
  
  expect_equal(
    labelled::val_labels(out),
    c(
      yes = 1,
      no = 2,
      inap = 99999
    )
  )
})

test_that("convert_to_labelled_spss errors on conflicting missing values", {
  
  x <- c(1, 2, 99999)
  
  expect_error(
    convert_to_labelled_spss(x)
  )
})

test_that("remove_na_range removes unused na_range", {
  
  x <- labelled_spss_survey(
    x = c(1, 2, 3),
    labels = c(
      yes = 1,
      no = 2
    ),
    na_range = c(8, 9),
    id = "survey1"
  )
  
  out <- remove_na_range(x)
  
  expect_null(attr(out, "na_range"))
})

test_that("remove_na_range preserves active na_range", {
  
  x <- labelled_spss_survey(
    x = c(1, 2, 8),
    labels = c(
      yes = 1,
      no = 2,
      missing = 8
    ),
    na_range = c(8, 9),
    id = "survey1"
  )
  
  out <- remove_na_range(x)
  
  expect_equal(
    attr(out, "na_range"),
    c(8, 9)
  )
})
