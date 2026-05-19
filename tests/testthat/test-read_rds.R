test_that("attributes work", {
  examples_dir <- system.file("examples", package = "retroharmonize")
  test_read <- read_rds(file.path(examples_dir, "ZA7576.rds"),
    id = "ZA7576",
    doi = "test_doi"
  )
  expect_equal(attr(test_read, "id"), "ZA7576")
  expect_equal(attr(test_read, "filename"), "ZA7576.rds")
  expect_equal(attr(test_read, "doi"), "test_doi")
})

read_write_test <- function() {
  examples_dir <- system.file("examples", package = "retroharmonize")
  test_read <- read_rds(file.path(examples_dir, "ZA7576.rds"),
    id = "ZA7576",
    doi = "test_doi"
  )
  temp_save_location <- tempdir()
  write.csv(test_read, file.path(temp_save_location, "test.csv"), row.names = F)
  reread <- read_csv(file = file.path(temp_save_location, "test.csv"))
  is.survey()
}

test_that("file size attributes are recorded", {
  examples_dir <- system.file("examples", package = "retroharmonize")

  test_read <- read_rds(
    file.path(examples_dir, "ZA7576.rds")
  )

  expect_true(!is.null(attr(test_read, "object_size")))
  expect_true(!is.null(attr(test_read, "source_file_size")))

  expect_true(attr(test_read, "object_size") > 0)
  expect_true(attr(test_read, "source_file_size") > 0)
})


test_that("id defaults to filename without extension", {
  examples_dir <- system.file("examples", package = "retroharmonize")

  test_read <- read_rds(
    file.path(examples_dir, "ZA7576.rds")
  )

  expect_equal(
    attr(test_read, "id"),
    "ZA7576"
  )
})


test_that("failed reads return empty survey", {
  bad_file <- tempfile(fileext = ".rds")

  writeLines("not an rds file", bad_file)

  expect_warning(
    result <- read_rds(bad_file)
  )

  expect_true(is.survey(result))
  expect_equal(ncol(result), 0)
})


test_that("rowid is normalized with survey id", {
  examples_dir <- system.file("examples", package = "retroharmonize")

  test_read <- read_rds(
    file.path(examples_dir, "ZA7576.rds"),
    id = "TESTID"
  )

  expect_true(
    all(grepl("^TESTID_", test_read$rowid))
  )
})

test_that("rowid label is created", {
  examples_dir <- system.file("examples", package = "retroharmonize")

  test_read <- read_rds(
    file.path(examples_dir, "ZA7576.rds"),
    id = "ZA7576"
  )

  expect_equal(
    labelled::var_label(test_read$rowid),
    "Unique identifier in ZA7576"
  )
})
