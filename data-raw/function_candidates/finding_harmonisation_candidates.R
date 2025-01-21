search_variables <- function(
    catalog,
    pattern,
    ignore_case = TRUE
) {
  
  stopifnot(inherits(catalog, "survey_catalog"))
  
  catalog %>%
    dplyr::filter(
      stringr::str_detect(
        var_label,
        stringr::regex(
          pattern,
          ignore_case = ignore_case
        )
      )
    )
}


catalog <- create_variable_catalog(
  survey_files = gesis_files$survey_file,
  dataset_id = gesis_files$dataset_id
)

library(dplyr)
trust_vars <- search_variables(
  catalog,
  "trust|parliament|commission"
)
identity_vars <- search_variables(
  catalog,
  "attach"
)


trust_vars %>%
  select(
    dataset_id,
    var_name,
    var_label
  )