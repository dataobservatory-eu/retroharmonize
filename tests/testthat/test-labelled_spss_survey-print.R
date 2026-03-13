test_that("vec_ptype_full returns readable type", {
  x <- labelled_spss_survey(
    x = 1:3,
    labels = c(Yes = 1),
    id = "survey1"
  )

  out <- vctrs::vec_ptype_full(x)

  expect_type(out, "character")
  expect_length(out, 1)

  expect_match(
    out,
    "labelled_spss_survey"
  )
})


test_that("vec_ptype_abbr returns compact abbreviation", {
  x <- labelled_spss_survey(
    x = 1:3,
    labels = c(Yes = 1),
    id = "survey1"
  )

  out <- vec_ptype_abbr(x)

  expect_equal(out, "retroh_int")
})


test_that("format returns character vector", {
  x <- labelled_spss_survey(
    x = c(1, 2, 9),
    labels = c(Yes = 1, No = 2),
    na_values = 9,
    id = "survey1"
  )

  out <- format(x)

  expect_type(out, "character")
  expect_length(out, 3)
})


test_that("print method works", {
  x <- labelled_spss_survey(
    x = c(1, 2, 9),
    labels = c(Yes = 1, No = 2),
    na_values = 9,
    label = "Question text",
    id = "survey1"
  )

  expect_snapshot_output(
    print(x)
  )
})


test_that("pillar shaft works", {
  x <- labelled_spss_survey(
    x = 1:10,
    labels = c(Good = 1, Bad = 8),
    na_values = c(9, 10),
    id = "survey1"
  )

  expect_snapshot_output(
    pillar::pillar_shaft(tibble::tibble(v1 = x))
  )
})


test_that("pillar display works", {
  x <- labelled_spss_survey(
    x = 1:10,
    labels = c(Good = 1, Bad = 8),
    na_values = c(9, 10),
    id = "survey1"
  )

  expect_snapshot_output(
    pillar::pillar(x)
  )
})
