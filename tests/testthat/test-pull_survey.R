test_that("pull_survey() retrieves surveys by id", {
  examples_dir <- system.file(
    "examples",
    package = "retroharmonize"
  )

  survey_files <- dir(
    examples_dir,
    pattern = "\\.rds$"
  )

  example_surveys <- read_surveys(
    file.path(examples_dir, survey_files)
  )

  result <- pull_survey(
    example_surveys,
    id = "ZA5913"
  )

  expect_true(
    inherits(result, "survey")
  )

  expect_equal(
    nrow(result),
    35
  )

  expect_equal(
    attr(result, "id"),
    "ZA5913"
  )
})

test_that("pull_survey() retrieves surveys by filename", {
  examples_dir <- system.file(
    "examples",
    package = "retroharmonize"
  )

  survey_files <- dir(
    examples_dir,
    pattern = "\\.rds$"
  )

  example_surveys <- read_surveys(
    file.path(examples_dir, survey_files)
  )

  result <- pull_survey(
    example_surveys,
    filename = "ZA5913.rds"
  )

  expect_true(
    inherits(result, "survey")
  )

  expect_equal(
    nrow(result),
    35
  )

  expect_equal(
    attr(result, "filename"),
    "ZA5913.rds"
  )
})

test_that("pull_survey() errors when neither id nor filename is supplied", {
  examples_dir <- system.file(
    "examples",
    package = "retroharmonize"
  )

  survey_files <- dir(
    examples_dir,
    pattern = "\\.rds$"
  )

  example_surveys <- read_surveys(
    file.path(examples_dir, survey_files)
  )

  expect_error(
    pull_survey(example_surveys),
    "Either the id or the filename must be given"
  )
})

test_that("pull_survey() errors when id is not found", {
  examples_dir <- system.file(
    "examples",
    package = "retroharmonize"
  )

  survey_files <- dir(
    examples_dir,
    pattern = "\\.rds$"
  )

  example_surveys <- read_surveys(
    file.path(examples_dir, survey_files)
  )

  expect_error(
    pull_survey(
      example_surveys,
      id = "missing_survey"
    ),
    "is not present"
  )
})

test_that("pull_survey() errors when filename is not found", {
  examples_dir <- system.file(
    "examples",
    package = "retroharmonize"
  )

  survey_files <- dir(
    examples_dir,
    pattern = "\\.rds$"
  )

  example_surveys <- read_surveys(
    file.path(examples_dir, survey_files)
  )

  expect_error(
    pull_survey(
      example_surveys,
      filename = "missing_file.rds"
    ),
    "is not present"
  )
})
