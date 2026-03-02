test_that("read_surveys() reads the correct file", {
  examples_dir <- system.file("examples", package = "retroharmonize")
  my_rds_files <- file.path(examples_dir, dir(examples_dir)[grepl(
    ".rds",
    dir(examples_dir)
  )])
  example_surveys <- read_surveys(survey_paths = my_rds_files)
  expect_equal(
    attr(read_survey(file_path = my_rds_files[1]), "filename"),
    fs::path_file(my_rds_files[1])
  )
})

test_that("read_surveys() error if file does not exists", {
  expect_error(read_surveys(tempfile(), .f = "read_csv", export_path = NULL))
})


test_that("read_surveys() reads all files", {
  examples_dir <- system.file("examples", package = "retroharmonize")
  my_rds_files <- file.path(examples_dir, dir(examples_dir)[grepl(
    ".rds",
    dir(examples_dir)
  )])
  example_surveys <- read_surveys(survey_paths = my_rds_files)
  expect_equal(length(example_surveys), 3)
})


test_that("find_import_function() detects file formats", {
  
  expect_equal(
    find_import_function("test.sav"),
    "read_spss"
  )
  
  expect_equal(
    find_import_function("test.por"),
    "read_spss"
  )
  
  expect_equal(
    find_import_function("test.dta"),
    "read_dta"
  )
  
  expect_equal(
    find_import_function("test.rds"),
    "read_rds"
  )
  
  expect_equal(
    find_import_function("test.csv"),
    "read_csv"
  )
})


test_that("find_import_function() errors on unsupported formats", {
  
  expect_error(
    find_import_function("test.xlsx")
  )
})


test_that("read_surveys() skips missing files with warning", {
  
  examples_dir <- system.file(
    "examples",
    package = "retroharmonize"
  )
  
  existing_file <- file.path(
    examples_dir,
    "ZA7576.rds"
  )
  
  missing_file <- tempfile(fileext = ".rds")
  
  expect_warning({
    
    surveys <- read_surveys(
      c(existing_file, missing_file)
    )
    
  })
  
  expect_equal(length(surveys), 1)
})


test_that("read_surveys() exports surveys to rds", {
  
  examples_dir <- system.file(
    "examples",
    package = "retroharmonize"
  )
  
  my_rds_files <- file.path(
    examples_dir,
    dir(examples_dir)[grepl(
      ".rds",
      dir(examples_dir)
    )]
  )
  
  export_dir <- tempdir()
  
  exported <- read_surveys(
    survey_paths = my_rds_files,
    export_path = export_dir
  )
  
  expect_true(
    all(file.exists(
      file.path(export_dir, exported)
    ))
  )
})


test_that("read_survey() retains filename metadata", {
  
  examples_dir <- system.file(
    "examples",
    package = "retroharmonize"
  )
  
  file1 <- file.path(
    examples_dir,
    "ZA7576.rds"
  )
  
  survey <- read_survey(file1)
  
  expect_equal(
    attr(survey, "filename"),
    "ZA7576.rds"
  )
})


test_that("read_surveys() propagates ids and dois", {
  
  examples_dir <- system.file(
    "examples",
    package = "retroharmonize"
  )
  
  file1 <- file.path(
    examples_dir,
    "ZA7576.rds"
  )
  
  surveys <- read_surveys(
    survey_paths = file1,
    ids = "ZA7576",
    dois = "10.4232/example"
  )
  
  expect_equal(
    attr(surveys[[1]], "id"),
    "ZA7576"
  )
})
