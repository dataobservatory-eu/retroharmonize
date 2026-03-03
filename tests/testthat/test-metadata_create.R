test_that("Only surveys are accepted", {
  
  expect_error(
    metadata_survey_create(
      data.frame(
        a = 1:2,
        b = c("b", "C")
      )
    )
  )
})

test_that("Correct values are returned", {
  
  test_survey <- read_rds(
    file = system.file(
      "examples",
      "ZA7576.rds",
      package = "retroharmonize"
    )
  )
  
  example_metadata <- metadata_survey_create(
    survey = test_survey
  )
  
  q_labels <- length(
    labelled::val_labels(test_survey$qd6.12)
  )
  
  q_na <- length(
    labelled::na_values(test_survey$qd6.12)
  )
  
  test_value <- example_metadata[
    which(example_metadata$var_name_orig == "qd6.12"),
  ]
  
  test_value2 <- example_metadata[
    which(example_metadata$var_name_orig == "qg8"),
  ]
  
  expect_equal(ncol(example_metadata), 12)
  
  expect_equal(
    example_metadata$var_name_orig[1],
    "rowid"
  )
  
  expect_equal(
    unique(example_metadata$filename),
    "ZA7576.rds"
  )
  
  expect_equal(
    as.character(unlist(example_metadata$na_labels[2])),
    NA_character_
  )
  
  expect_equal(
    example_metadata$var_label_orig[1],
    "unique_identifier_in_za_7576"
  )
  
  expect_equal(
    length(test_value$na_labels),
    q_na
  )
  
  expect_equal(
    test_value$n_valid_labels,
    q_labels - q_na
  )
  
  expect_equal(
    c(
      length(test_value2$labels[[1]]),
      length(test_value2$valid_labels[[1]]),
      length(test_value2$na_labels[[1]])
    ),
    c(8, 6, 2)
  )
})

test_that("Correct values are returned from multiple surveys", {
  
  examples_dir <- system.file(
    "examples",
    package = "retroharmonize"
  )
  
  my_rds_files <- dir(examples_dir)[grepl(
    "\\.rds$",
    dir(examples_dir)
  )]
  
  example_surveys <- read_surveys(
    file.path(examples_dir, my_rds_files)
  )
  
  metadata_multiple_surveys <- metadata_create(
    example_surveys
  )
  
  expect_equal(
    metadata_multiple_surveys$var_name_orig[1],
    "rowid"
  )
})



test_that("metadata_survey_create works without labelled variables", {
  
  plain_df <- data.frame(
    rowid = 1:3,
    age = c(20, 30, 40)
  )
  
  plain_survey <- survey(
    plain_df,
    id = "plain"
  )
  
  result <- metadata_survey_create(
    plain_survey
  )
  
  expect_true(
    is.data.frame(result)
  )
  
  expect_equal(
    nrow(result),
    2
  )
})


test_that("metadata_survey_create handles empty surveys", {
  
  empty_survey <- survey(
    data.frame(),
    id = "empty"
  )
  
  result <- metadata_survey_create(
    empty_survey
  )
  
  expect_true(
    is.data.frame(result)
  )
  
  expect_equal(
    nrow(result),
    1
  )
})


test_that("metadata_survey_create handles missing filename", {
  
  test_survey <- read_rds(
    system.file(
      "examples",
      "ZA7576.rds",
      package = "retroharmonize"
    )
  )
  
  attr(test_survey, "filename") <- NULL
  
  result <- metadata_survey_create(
    test_survey
  )
  
  expect_equal(
    unique(result$filename),
    "unknown"
  )
})


