


search_variables_by_code <- function(
    catalog,
    pattern,
    ignore_case = TRUE
) {
  
  stopifnot(inherits(catalog, "survey_catalog"))
  
  dplyr::filter(
    catalog,
    stringr::str_detect(
      var_name,
      stringr::regex(
        pattern,
        ignore_case = ignore_case
      )
    ) |
      stringr::str_detect(
        var_label,
        stringr::regex(
          paste0("^", pattern),
          ignore_case = ignore_case
        )
      )
  )
}