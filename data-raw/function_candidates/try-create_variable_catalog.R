gesis_files <- tibble::tibble(
  survey_file = file.path(
    "data-raw/gesis",
    c(
      "ZA4529_v3-0-1.sav",
      "ZA5688_v6-0-0.sav",
      "ZA7780_v2-0-0.sav",
      "ZA8904_v1-0-0.sav",
      "ZA8905_v1-0-0.sav"
    )
  ),
  
  dataset_id = c(
    "ZA4529",
    "ZA5688",
    "ZA7780",
    "ZA8904",
    "ZA8905"
  )
)



survey_catalogue <- create_variable_catalog(survey_files = gesis_files$survey_file,
               dataset_id = gesis_files$dataset_id)
