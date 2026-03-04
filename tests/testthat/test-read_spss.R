test_that("read_spss_survey() with attributes work", {
  examples_dir <- system.file("examples", package = "retroharmonize")
  read_example <- read_spss(
    file = file.path(examples_dir, "iris1.sav"),
    id = "my_iris"
  )
  expect_equal(attr(read_example, "id"), "my_iris")
  expect_equal(attr(read_example, "filename"), "iris1.sav")
  expect_equal(attr(read_example, "doi"), NULL)
})

test_that("exception handling works", {
  expect_error(read_spss(file.path(examples_dir, "not_iris.sav")))
})

test_that("read_spss() preserves core attributes", {
  examples_dir <- system.file(
    "examples",
    package = "retroharmonize"
  )

  read_example <- read_spss(
    file = file.path(examples_dir, "iris1.sav"),
    id = "my_iris"
  )

  expect_equal(
    attr(read_example, "id"),
    "my_iris"
  )

  expect_equal(
    attr(read_example, "filename"),
    "iris1.sav"
  )

  expect_null(
    attr(read_example, "doi")
  )

  expect_true(
    is.survey(read_example)
  )
})

test_that("read_spss() creates rowid", {
  examples_dir <- system.file(
    "examples",
    package = "retroharmonize"
  )

  read_example <- read_spss(
    file = file.path(examples_dir, "iris1.sav"),
    id = "my_iris"
  )

  expect_true(
    "rowid" %in% names(read_example)
  )

  expect_true(
    all(grepl("^my_iris_", read_example$rowid))
  )
})

test_that("read_spss() preserves variable labels", {
  examples_dir <- system.file(
    "examples",
    package = "retroharmonize"
  )

  read_example <- read_spss(
    file = file.path(examples_dir, "iris1.sav")
  )

  expect_true(
    !is.null(labelled::var_label(read_example$Sepal.Length))
  )
})

test_that("read_spss() stores provenance metadata", {
  examples_dir <- system.file(
    "examples",
    package = "retroharmonize"
  )

  read_example <- read_spss(
    file = file.path(examples_dir, "iris1.sav")
  )

  expect_true(
    attr(read_example, "object_size") > 0
  )

  expect_true(
    attr(read_example, "source_file_size") > 0
  )
})

test_that("read_spss() handles missing files", {
  examples_dir <- system.file(
    "examples",
    package = "retroharmonize"
  )

  expect_error(
    read_spss(
      file.path(examples_dir, "not_iris.sav")
    )
  )
})

test_that("read_spss() returns empty survey on read failure", {
  tmp <- tempfile(fileext = ".sav")

  writeLines(
    "this is not an SPSS file",
    con = tmp
  )

  expect_warning(
    result <- read_spss(tmp)
  )

  expect_true(
    is.survey(result)
  )

  expect_equal(
    ncol(result),
    0
  )
})

test_that("read_spss() preserves column names", {
  examples_dir <- system.file(
    "examples",
    package = "retroharmonize"
  )

  read_example <- read_spss(
    file = file.path(examples_dir, "iris1.sav")
  )

  expect_true(
    all(
      c(
        "rowid",
        "Sepal.Length",
        "Sepal.Width",
        "Petal.Length",
        "Petal.Width",
        "Species"
      ) %in% names(read_example)
    )
  )
})
