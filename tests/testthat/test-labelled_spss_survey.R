## Scenarios with different labels ----------------------------
test_that("subsetting workds", {
  v1 <- labelled_spss_survey(
    x = c(1, 0, 1, 9),
    labels = c(
      "yes" = 1,
      "no" = 0,
      "inap" = 9
    ),
    na_values = 9,
    label = "My survey item",
    id = "test"
  )
  expect_equal(as_numeric(v1[3:4]), c(1, NA))
})


test_that("type conversion is correct", {
  my_x <- 1:10
  x1 <- labelled_spss_survey(
    x = 1:10,
    labels = c(Good = 1, Bad = 8),
    na_values = c(9, 10),
    id = "survey1"
  )
  x2 <- labelled_spss_survey(my_x,
    labels = c(Good = 1, Bad = 8),
    na_range = c(9, Inf),
    label = "Quality Rating",
    id = "survey2"
  )
  expect_equal(as_numeric(x1), c(1:8, NA, NA))
  expect_equal(attr(x2, "survey2_labels"), c(Good = 1, Bad = 8))
  expect_equal(attr(x1, "survey1_na_values"), c(9, 10))
})

test_that("NA values are correct", {
  x1 <- labelled_spss_survey(
    x = 1:10,
    labels = c(Good = 1, Bad = 8),
    na_values = c(9, 10),
    id = "survey1"
  )
  expect_equal(sum(is.na(x1)), 2)
  expect_equal(levels(as_factor(x1)), c("Good", 2:7, "Bad", 9:10))
  expect_equal(retroharmonize::as_character(x = x1), c("Good", 2:7, "Bad", 9:10))
})

test_that("errors work", {
  x1 <- labelled_spss_survey(
    x = 1:10,
    labels = c(Good = 1, Bad = 8),
    na_values = c(9, 10),
    id = "survey1"
  )

  expect_error(sum(as_factor(x1)))
})

test_that("attributes are present", {
  my_x <- 1:10
  x1 <- labelled_spss_survey(
    x = 1:10,
    labels = c(Good = 1, Bad = 8),
    na_values = c(9, 10),
    id = "survey1"
  )
  x2 <- labelled_spss_survey(my_x,
    labels = c(Good = 1, Bad = 8),
    na_range = c(9, Inf),
    label = "Quality Rating",
    id = "survey2"
  )
  expect_equal(attr(x1, "id"), "survey1")
  expect_equal(attr(x2, "label"), "Quality Rating")
  expect_equal(attr(x2, "survey2_name"), "my_x")
  expect_equal(attr(x2, "na_range"), c(9, Inf))
  expect_equal(attr(x2, "survey2_na_range"), c(9, Inf))
})
