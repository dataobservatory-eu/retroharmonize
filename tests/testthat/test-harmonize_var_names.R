test_that("harmonize_var_names() returns a list", {
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

  metadata <- metadata_create(
    example_surveys
  )

  metadata$var_name_suggested <-
    metadata$var_name_orig

  result <- harmonize_var_names(
    survey_list = example_surveys,
    metadata = metadata
  )

  expect_true(is.list(result))
  expect_equal(length(result), length(example_surveys))
})

test_that("harmonize_var_names() preserves survey dimensions", {
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

  metadata <- metadata_create(
    example_surveys
  )

  metadata$var_name_suggested <-
    metadata$var_name_orig

  result <- harmonize_var_names(
    survey_list = example_surveys,
    metadata = metadata
  )

  expect_equal(
    nrow(result[[1]]),
    nrow(example_surveys[[1]])
  )

  expect_equal(
    ncol(result[[1]]),
    ncol(example_surveys[[1]])
  )
})

test_that("harmonize_var_names() renames variables", {
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

  metadata <- metadata_create(
    example_surveys
  )

  metadata$var_name_suggested <-
    metadata$var_name_orig

  metadata$var_name_suggested[
    metadata$var_name_orig == "rowid"
  ] <- "uniqid"

  result <- harmonize_var_names(
    survey_list = example_surveys,
    metadata = metadata
  )

  expect_true(
    "uniqid" %in% names(result[[1]])
  )

  expect_false(
    "rowid" %in% names(result[[1]])
  )
})

test_that("harmonize_var_names() subsets variables", {
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

  metadata <- metadata_create(
    example_surveys
  )

  metadata <- metadata %>%
    filter(
      var_name_orig %in% c(
        "rowid",
        "w1"
      )
    ) %>%
    mutate(
      var_name_suggested = var_name_orig
    )

  result <- harmonize_var_names(
    survey_list = example_surveys,
    metadata = metadata
  )

  expect_equal(
    names(result[[1]]),
    c("rowid", "w1")
  )
})

test_that("harmonize_var_names() errors on missing metadata columns", {
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

  metadata <- metadata_create(
    example_surveys
  )

  metadata$wrong_name <-
    metadata$var_name_orig

  expect_error(
    harmonize_var_names(
      survey_list = example_surveys,
      metadata = metadata,
      new = "var_name_suggested"
    )
  )
})

test_that("harmonize_var_names() warns when metadata is missing for a survey", {
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

  metadata <- metadata_create(
    example_surveys
  )

  metadata$var_name_suggested <-
    metadata$var_name_orig

  metadata <- metadata[
    metadata$filename != attr(example_surveys[[1]], "filename"),
  ]

  expect_warning(
    harmonize_var_names(
      survey_list = example_surveys,
      metadata = metadata
    )
  )
})

test_that("harmonize_var_names() preserves survey class", {
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

  metadata <- metadata_create(
    example_surveys
  )

  metadata$var_name_suggested <-
    metadata$var_name_orig

  result <- harmonize_var_names(
    survey_list = example_surveys,
    metadata = metadata
  )

  expect_true(
    inherits(result[[1]], "survey")
  )
})
