# See also test-read_surveys


test_that("read_csv works", {
  examples_dir <- system.file("examples", package = "retroharmonize")
  test_csv_file <- tempfile()
  test_read <- read_rds(file.path(examples_dir, "ZA7576.rds"),
    id = "ZA7576",
    doi = "test_doi"
  )
  write.csv(
    x = test_read,
    file = test_csv_file, row.names = FALSE
  )

  re_read <- read_csv(
    file = test_csv_file,
    id = "ZA7576",
    doi = "test_doi"
  )
  expect_equal(attr(re_read, "doi"), "test_doi")
  expect_equal(attr(re_read, "id"), "ZA7576")
  expect_true(is.survey(re_read))
})

test_that("read_survey(...) passes on ...", {
  examples_dir <- system.file("examples", package = "retroharmonize")
  test_csv_file <- tempfile()
  test_read <- read_rds(file.path(examples_dir, "ZA7576.rds"),
    id = "ZA7576",
    doi = "test_doi"
  )
  write.csv(x = test_read, file = test_csv_file, row.names = FALSE)
  re_read_2 <- read_survey(
    file_path = test_csv_file,
    .f = "read_csv",
    id = "ZA7576",
    doi = "test_doi"
  )
  expect_equal(attr(re_read_2, "doi"), "test_doi")
  expect_equal(attr(re_read_2, "id"), "ZA7576")
  expect_true(is.survey(re_read_2))
})


test_that("read_surveys(...) passes on ...", {
  examples_dir <- system.file("examples", package = "retroharmonize")
  test_csv_file <- tempfile()
  test_read <- read_rds(file.path(examples_dir, "ZA7576.rds"),
    id = "ZA7576",
    doi = "test_doi"
  )
  write.csv(x = test_read, file = test_csv_file, row.names = FALSE)
  re_read_3 <- read_surveys(
    survey_paths = test_csv_file,
    .f = "read_csv",
    ids = "ZA7576",
    dois = "test_doi"
  )[[1]]
  expect_equal(attr(re_read_3, "doi"), "test_doi")
  expect_equal(attr(re_read_3, "id"), "ZA7576")
  expect_true(is.survey(re_read_3))
})



test_that("read_csv preserves rowid", {
  
  examples_dir <- system.file(
    "examples",
    package = "retroharmonize"
  )
  
  test_csv_file <- tempfile(fileext = ".csv")
  
  test_read <- read_rds(
    file.path(examples_dir, "ZA7576.rds"),
    id = "ZA7576"
  )
  
  write.csv(
    x = test_read,
    file = test_csv_file,
    row.names = FALSE
  )
  
  re_read <- read_csv(
    file = test_csv_file,
    id = "ZA7576"
  )
  
  expect_true("rowid" %in% names(re_read))
})


test_that("read_csv errors without rowid column", {
  
  test_csv_file <- tempfile(fileext = ".csv")
  
  test_data <- data.frame(
    x = 1:3,
    y = letters[1:3]
  )
  
  write.csv(
    test_data,
    test_csv_file,
    row.names = FALSE
  )
  
  expect_error(
    read_csv(test_csv_file)
  )
})


test_that("read_csv stores object size metadata", {
  
  examples_dir <- system.file(
    "examples",
    package = "retroharmonize"
  )
  
  test_csv_file <- tempfile(fileext = ".csv")
  
  test_read <- read_rds(
    file.path(examples_dir, "ZA7576.rds")
  )
  
  write.csv(
    x = test_read,
    file = test_csv_file,
    row.names = FALSE
  )
  
  re_read <- read_csv(test_csv_file)
  
  expect_true(
    !is.null(attr(re_read, "object_size"))
  )
  
  expect_true(
    !is.null(attr(re_read, "source_file_size"))
  )
})



