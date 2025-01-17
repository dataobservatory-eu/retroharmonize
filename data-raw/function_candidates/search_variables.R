#' Search variables in a survey catalog
#'
#' Search variable labels in a `survey_catalog` object using regular
#' expression matching. This function is designed for metadata discovery
#' workflows, allowing users to identify potentially comparable variables
#' across multiple survey datasets.
#'
#' @param catalog A `survey_catalog` object created with
#'   [create_variable_catalog()].
#'
#' @param pattern A character string containing a regular expression
#'   pattern to search for in variable labels.
#'
#' @param ignore_case Logical. If `TRUE`, perform case-insensitive
#'   matching. Defaults to `TRUE`.
#'
#' @return A filtered tibble of class `survey_catalog` containing only
#'   variables whose labels match the search pattern.
#'
#' @examples
#' \dontrun{
#'
#' trust_variables <- search_variables(
#'   catalog,
#'   pattern = "trust|parliament|commission"
#' )
#'
#' trust_variables %>%
#'   dplyr::select(
#'     dataset_id,
#'     var_name,
#'     var_label
#'   )
#' }
#'
#' @importFrom dplyr filter
#' @importFrom stringr str_detect regex
#'
#' @export
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