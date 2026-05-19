#' Harmonize variable names across surveys
#'
#' Harmonize variable names in a list of survey objects using
#' a metadata crosswalk table.
#'
#' @description
#' `harmonize_var_names()` renames variables across multiple
#' surveys to a shared harmonized naming scheme.
#'
#' The harmonization rules are defined in a metadata table,
#' typically created with [metadata_create()].
#'
#' @details
#' The function can also be used for survey subsetting workflows.
#' If `metadata` contains only a subset of variables for a survey,
#' only those variables are retained in the harmonized output.
#'
#' @param survey_list A list of survey objects, typically imported
#'   with [read_surveys()].
#'
#' @param metadata A metadata table containing harmonization rules.
#'   Typically created with [metadata_create()] and combined across
#'   surveys.
#'
#' @param old Name of the column in `metadata` containing
#'   the original variable names.
#'
#' @param new Name of the column in `metadata` containing
#'   the harmonized variable names.
#'
#' @param rowids Logical. Should original `rowid` variables
#'   be renamed to `"uniqid"`?
#'
#' @return
#' A list of surveys with harmonized variable names.
#'
#' @family harmonization functions
#'
#' @seealso
#' [metadata_create()],
#' [crosswalk()]
#'
#' @examples
#' examples_dir <- system.file(
#'   "examples",
#'   package = "retroharmonize"
#' )
#'
#' survey_files <- dir(
#'   examples_dir,
#'   pattern = "\\.rds$"
#' )
#'
#' example_surveys <- read_surveys(
#'   file.path(examples_dir, survey_files)
#' )
#'
#' metadata <- metadata_create(
#'   example_surveys
#' )
#'
#' metadata$var_name_suggested <-
#'   label_normalize(metadata$var_name)
#'
#' metadata$var_name_suggested[
#'   metadata$label_orig == "age_education"
#' ] <- "age_education"
#'
#' harmonized_surveys <- harmonize_var_names(
#'   survey_list = example_surveys,
#'   metadata = metadata
#' )
#'
#' harmonized_surveys[[1]]
#'
#' @importFrom assertthat assert_that
#' @importFrom dplyr inner_join left_join mutate select
#' @importFrom glue glue
#' @importFrom rlang set_names
#' @importFrom tidyselect all_of
#'
#' @export

harmonize_var_names <- function(survey_list,
                                metadata,
                                old = "var_name_orig",
                                new = "var_name_suggested",
                                rowids = TRUE) {
  assert_that(all(c(new, old, "filename") %in% names(metadata)),
    msg = glue::glue("'{old}', '{new}' and 'filename' must be column names in metadata.")
  )

  metadata <- metadata %>%
    select(all_of(c(old, new, "filename"))) %>%
    set_names(c("var_name_orig", "var_name_suggested", "filename"))


  rename_this_survey <- function(this_survey) {
    this_metadata <- metadata[attr(this_survey, "filename") == metadata$filename, ]

    if (!attr(this_survey, "filename") %in% metadata$filename) {
      warning(
        glue::glue(
          "The metadata of {attr(this_survey, 'filename')} cannot be found"
        )
      )
    }

    renaming <- data.frame(var_name_orig = names(this_survey)) %>%
      inner_join(
        this_metadata %>%
          select(all_of(c("var_name_orig", "var_name_suggested"))),
        by = "var_name_orig"
      )

    subset_this_survey <- this_survey %>%
      select(all_of(renaming$var_name_orig))

    rlang::set_names(subset_this_survey,
      nm = renaming$var_name_suggested
    )
  }

  lapply(survey_list, rename_this_survey)
}
