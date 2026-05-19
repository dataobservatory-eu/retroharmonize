#' Merge and harmonize surveys
#'
#' Harmonize variable names, labels, and identifiers across multiple
#' surveys using a metadata crosswalk table.
#'
#' @description
#' `merge_surveys()` applies a harmonization specification to a list
#' of survey objects and returns harmonized survey datasets with
#' aligned variable names and metadata.
#'
#' @details
#' Prior to version 0.2.0 this function was called `merge_waves()`,
#' reflecting terminology commonly used in Eurobarometer surveys.
#'
#' The harmonization table supplied in `var_harmonization`
#' typically originates from [metadata_create()] and contains
#' mappings between original and harmonized variable names.
#'
#' @param survey_list A list of survey objects.
#'
#' @param var_harmonization A metadata table describing the
#'   harmonization rules. The table must contain at least:
#'
#'   - `filename`
#'   - `var_name_orig`
#'   - `var_name_target`
#'   - `var_label`
#'
#' @return
#' A list of harmonized survey objects with standardized variable names
#' and variable labels.
#'
#' @family survey harmonization functions
#'
#' @seealso
#' [metadata_create()]
#'
#' @examples
#' \donttest{
#'
#' examples_dir <- system.file(
#'   "examples",
#'   package = "retroharmonize"
#' )
#'
#' survey_files <- dir(
#'   examples_dir,
#'   pattern = "\\.rds$",
#'   full.names = TRUE
#' )
#'
#' example_surveys <- read_surveys(
#'   survey_files
#' )
#'
#' metadata <- metadata_create(
#'   survey_list = example_surveys
#' )
#'
#' to_harmonize <- metadata %>%
#'   dplyr::filter(
#'     var_name_orig %in% c("rowid", "w1") |
#'       grepl("^trust", var_label_orig)
#'   ) %>%
#'   dplyr::mutate(
#'     var_label = var_label_normalize(var_label_orig),
#'     var_name_target = val_label_normalize(var_label),
#'     var_name_target = ifelse(
#'       .data$var_name_orig %in%
#'         c("rowid", "w1", "wex"),
#'       .data$var_name_orig,
#'       .data$var_name_target
#'     )
#'   )
#'
#' merged_surveys <- merge_surveys(
#'   survey_list = example_surveys,
#'   var_harmonization = to_harmonize
#' )
#'
#' merged_surveys[[1]]
#' }
#'
#' @importFrom dplyr across any_of filter mutate select
#' @importFrom haven is.labelled
#' @importFrom rlang .data set_names
#' @importFrom tidyselect all_of
#'
#' @export

merge_surveys <- function(survey_list, var_harmonization) {
  validate_survey_list(survey_list)

  if (any(!c("filename", "var_name_orig", "var_name_target", "var_label") %in%
    names(var_harmonization))) {
    stop(
      "var_harmonization must contain ",
      paste(c("filename", "var_name_orig", "var_name_target", "var_label"),
        collapse = ", "
      ),
      "."
    )
  }

  fn_merge <- function(dat) {
    select_vars <- var_harmonization %>%
      filter(.data$filename == attr(dat, "filename"))

    if (!"rowid" %in% select_vars$var_name_orig) {
      warning("rowid is not selected from ", attr(dat, "filename"))
    }

    tmp <- dat %>%
      select(all_of(c(select_vars$var_name_orig))) %>%
      rlang::set_names(nm = select_vars$var_name_target)

    labelled_vars <- names(tmp)[vapply(tmp, haven::is.labelled, logical(1))]

    if (length(labelled_vars) > 0) {
      fn_relabel <- function(x) as_labelled_spss_survey(x, id = attr(tmp, "id"))
      tmp <- tmp %>%
        mutate(across(any_of(labelled_vars), fn_relabel))
    }

    if (!is.null(select_vars$var_label)) {
      labelled_items <- vapply(tmp, is.labelled_spss_survey, logical(1))
      labelled_items <- names(labelled_items)[labelled_items]

      labelling <- select_vars %>%
        select(all_of(c("var_name_target", "var_label")))

      fn_relabelling <- function(x) {
        labelling$var_label[which(labelling$var_name_target == x)]
      }

      for (x in labelled_items) {
        attr(tmp[[x]], "label") <- fn_relabelling(x)
      }
    }

    tmp
  }

  lapply(survey_list, fn_merge)
}

#' Deprecated wrapper for `merge_surveys()`
#'
#' `merge_waves()` has been renamed to [merge_surveys()]
#' for more general survey harmonization workflows.
#'
#' @inheritParams merge_surveys
#' @param waves Deprecated alias for `survey_list`.
#'
#' @return
#' A list of harmonized survey objects.
#'
#' @seealso
#' [merge_surveys()]
#'
#' @family survey harmonization functions
#'
#' @export

merge_waves <- function(waves, var_harmonization) {
  merge_surveys(
    survey_list = waves,
    var_harmonization = var_harmonization
  )
}
