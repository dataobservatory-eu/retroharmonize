test_that("arithmetic methods work", {
  x1 <- labelled_spss_survey(
    x = 1:10,
    labels = c(Good = 1, Bad = 8),
    na_values = c(9, 10),
    id = "survey1"
  )
  expect_equal(
    sum(x1, na.rm = TRUE),
    sum(1:8)
  )
  expect_equal(
    mean(x1, na.rm = TRUE),
    mean(1:8)
  )
  expect_equal(
    median(x1),
    median(1:8)
  )
  expect_equal(
    quantile(x1, 0.25),
    quantile(1:8, 0.25)
  )
  expect_equal(
    weighted.mean(x1, w = c(2, rep(1, 9))),
    weighted.mean(1:8, w = c(2, rep(1, 7)))
  )
})
