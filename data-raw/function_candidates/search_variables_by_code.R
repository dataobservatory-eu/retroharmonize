#' Search variables by questionnaire code
#'
#' Search a survey variable catalog using questionnaire-style variable
#' identifiers or prefixes. The function searches both the original
#' variable names and variable labels.
#'
#' This helper is particularly useful for survey collections such as
#' Eurobarometer, where questionnaire items are often identified by
#' stable codes (for example, `"P7"` or `"QC1"`), while the underlying
#' variable names may differ across survey waves.
#'
#' The search behaves differently for variable names and labels:
#'
#' - `var_name` is searched for the pattern anywhere in the string.
#' - `var_label` is searched from the beginning of the label, which is
#' often where questionnaire codes appear in GESIS metadata.
#'
#' @param catalog A variable catalog created with
#'   [create_variable_catalog()].
#'
#' @param pattern A character string containing the questionnaire code
#'   or search pattern.
#'
#' @param ignore_case Logical. Defaults to `TRUE`.
#'   Should matching ignore case?
#'
#' @return A tibble containing matching variables from the survey catalog.
#'
#' @examples
#' \dontrun{
#' catalog <- create_variable_catalog(
#'   survey_files = "ZA8905_v1-0-0.sav"
#' )
#'
#' search_variables_by_code(
#'   catalog,
#'   pattern = "QC1"
#' )
#' }
#'
#' @family metadata functions
#'
#' @importFrom dplyr filter
#' @importFrom stringr str_detect regex
#'
#' @export

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
