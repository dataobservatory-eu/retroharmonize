gesis_files <- dir(here::here("data-raw", "gesis"))
gesis_files <- gesis_files[grepl(x = gesis_files, pattern = ".sav")]
dataset_id <- substr(gesis_files,1, 16)

gesis_files <- tibble::tibble(
  survey_file = here::here("data-raw", "gesis", gesis_files),
  dataset_id = dataset_id
)

survey_catalogue <- create_variable_catalog(
  survey_files = gesis_files$survey_file,
  dataset_id = gesis_files$dataset_id)
