test_that("ptype2 with base numeric types returns double prototype", {
  x <- labelled_spss_survey(
    x = c(1, 0, 9),
    labels = c(yes = 1, no = 0, inap = 9),
    na_values = 9,
    id = "survey1"
  )
  
  expect_equal(vctrs::vec_ptype2(x, double()), double())
  expect_equal(vctrs::vec_ptype2(double(), x), double())
  
  expect_equal(vctrs::vec_ptype2(x, integer()), double())
  expect_equal(vctrs::vec_ptype2(integer(), x), double())
})

test_that("cast to base numeric types drops labelled_spss_survey class", {
  x <- labelled_spss_survey(
    x = c(1, 0, 9),
    labels = c(yes = 1, no = 0, inap = 9),
    na_values = 9,
    id = "survey1"
  )
  
  out_double <- vctrs::vec_cast(x, double())
  out_integer <- vctrs::vec_cast(x, integer())
  
  expect_equal(out_double, c(1, 0, 9))
  expect_type(out_double, "double")
  expect_false(inherits(out_double, "retroharmonize_labelled_spss_survey"))
  
  expect_equal(out_integer, c(1L, 0L, 9L))
  expect_type(out_integer, "integer")
  expect_false(inherits(out_integer, "retroharmonize_labelled_spss_survey"))
})



test_that("compatible labelled survey vectors have labelled survey prototype", {
  x <- labelled_spss_survey(
    x = c(1, 0, 9),
    labels = c(yes = 1, no = 0, inap = 9),
    na_values = 9,
    label = "Question",
    id = "survey1",
    name_orig = "q1"
  )
  
  y <- labelled_spss_survey(
    x = c(0, 1, 9),
    labels = c(yes = 1, no = 0, inap = 9),
    na_values = 9,
    label = "Question",
    id = "survey2",
    name_orig = "q1"
  )
  
  ptype <- vctrs::vec_ptype2(x, y)
  
  expect_s3_class(ptype, "retroharmonize_labelled_spss_survey")
  expect_equal(attr(ptype, "labels"), c(yes = 1, no = 0, inap = 9))
  expect_equal(attr(ptype, "na_values"), 9)
  expect_equal(attr(ptype, "id"), "multi-wave")
})


test_that("vec_c combines compatible labelled survey vectors", {
  x <- labelled_spss_survey(
    x = c(1, 0, 9),
    labels = c(yes = 1, no = 0, inap = 9),
    na_values = 9,
    label = "Question",
    id = "survey1",
    name_orig = "q1"
  )
  
  y <- labelled_spss_survey(
    x = c(0, 1, 9),
    labels = c(yes = 1, no = 0, inap = 9),
    na_values = 9,
    label = "Question",
    id = "survey2",
    name_orig = "q1"
  )
  
  out <- vctrs::vec_c(x, y)
  
  expect_s3_class(out, "retroharmonize_labelled_spss_survey")
  expect_equal(vctrs::vec_data(out), c(1, 0, 9, 0, 1, 9))
  expect_equal(attr(out, "labels"), c(yes = 1, no = 0, inap = 9))
  expect_equal(attr(out, "na_values"), 9)
})


test_that("vec_c errors when value labels differ", {
  x <- labelled_spss_survey(
    x = c(1, 0),
    labels = c(yes = 1, no = 0),
    id = "survey1"
  )
  
  y <- labelled_spss_survey(
    x = c(1, 0),
    labels = c(ja = 1, nee = 0),
    id = "survey2"
  )
  
  expect_error(vctrs::vec_c(x, y))
})


test_that("vec_c errors when labelled numeric values differ", {
  x <- labelled_spss_survey(
    x = c(1, 0),
    labels = c(yes = 1, no = 0),
    id = "survey1"
  )
  
  y <- labelled_spss_survey(
    x = c(1, 2),
    labels = c(yes = 1, no = 2),
    id = "survey2"
  )
  
  expect_error(vctrs::vec_c(x, y))
})


test_that("vec_c errors when na_values differ", {
  x <- labelled_spss_survey(
    x = c(1, 9),
    labels = c(yes = 1, inap = 9),
    na_values = 9,
    id = "survey1"
  )
  
  y <- labelled_spss_survey(
    x = c(1, 8),
    labels = c(yes = 1, inap = 9),
    na_values = 8,
    id = "survey2"
  )
  
  expect_error(vctrs::vec_c(x, y))
})


test_that("vec_c errors when na_range differs", {
  x <- labelled_spss_survey(
    x = c(1, 9),
    labels = c(yes = 1),
    na_range = c(8, 9),
    id = "survey1"
  )
  
  y <- labelled_spss_survey(
    x = c(1, 9),
    labels = c(yes = 1),
    na_range = c(9, 10),
    id = "survey2"
  )
  
  expect_error(vctrs::vec_c(x, y))
})


test_that("character cast only works for character labelled survey vectors", {
  x_chr <- labelled_spss_survey(
    x = c("a", "b"),
    labels = c(A = "a", B = "b"),
    id = "survey1"
  )
  
  x_num <- labelled_spss_survey(
    x = c(1, 2),
    labels = c(A = 1, B = 2),
    id = "survey1"
  )
  
  expect_equal(
    vctrs::vec_cast(x_chr, character()),
    c("a", "b")
  )
  
  expect_error(
    vctrs::vec_cast(x_num, character())
  )
})
