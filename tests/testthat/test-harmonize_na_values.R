test_that("harmonize_na_values returns input unchanged when there are no SPSS labelled variables", {
  df <- tibble::tibble(
    x = 1:3,
    y = c("a", "b", "c")
  )
  
  expect_identical(
    harmonize_na_values(df),
    df
  )
})


test_that("harmonize_na_values preserves survey class", {
  examples_dir <- system.file("examples", package = "retroharmonize")
  
  test_read <- read_rds(
    file.path(examples_dir, "ZA7576.rds"),
    id = "ZA7576",
    doi = "test_doi"
  )
  
  tested <- harmonize_na_values(df = test_read)
  
  expect_s3_class(tested, "survey")
})


test_that("harmonize_na_values keeps row count and column names", {
  examples_dir <- system.file("examples", package = "retroharmonize")
  
  test_read <- read_rds(
    file.path(examples_dir, "ZA7576.rds"),
    id = "ZA7576",
    doi = "test_doi"
  )
  
  tested <- harmonize_na_values(df = test_read)
  
  expect_equal(nrow(tested), nrow(test_read))
  expect_equal(names(tested), names(test_read))
})


test_that("current dk behaviour is documented", {
  x <- haven::labelled_spss(
    x = c(1, 8, 9),
    labels = c(
      yes = 1,
      dk = 8,
      inap = 9
    ),
    na_values = c(8, 9)
  )
  
  df <- tibble::tibble(x = x)
  
  out <- harmonize_na_values(df)
  
  expect_equal(
    unname(as.vector(out$x)),
    c(1, 8, 99999)
  )
})
