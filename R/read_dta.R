#' Read a Stata `.dta` survey file
#'
#' Import a survey dataset stored in Stata `.dta` format and convert it
#' into a `survey` object with harmonized metadata and labelled variables.
#'
#' This function wraps [haven::read_dta()] and adds:
#'
#' - error handling,
#' - survey metadata creation,
#' - `rowid` normalization,
#' - preservation of variable labels,
#' - conversion of labelled variables,
#' - and provenance metadata.
#'
#' @param file Path to a Stata `.dta` file.
#' @param id Optional survey identifier. Defaults to the file name
#'   without extension.
#' @param doi Optional DOI identifier for the survey.
#' @param .name_repair Strategy for repairing invalid or duplicated
#'   column names. Passed to [haven::read_dta()].
#'
#' @return A `survey` object inheriting from `data.frame` and `tbl_df`.
#'
#' @details
#' Variable labels are preserved using the `"label"` attribute.
#'
#' Labelled variables are converted to harmonized labelled survey vectors
#' where possible. Variables that inherit from `haven_labelled` but do not
#' contain valid label definitions are converted back to standard vectors.
#'
#' If the file cannot be read, the function returns an empty `survey`
#' object and emits a warning.
#'
#' @family import functions
#'
#' @examples
#' \donttest{
#' path <- system.file(
#'   "examples",
#'   "iris.dta",
#'   package = "haven"
#' )
#'
#' survey_object <- read_dta(path)
#'
#' attr(survey_object, "id")
#' attr(survey_object, "filename")
#' }
#'
#' @importFrom assertthat assert_that
#' @importFrom dplyr bind_cols mutate_all select
#' @importFrom fs path_ext_remove path_file
#' @importFrom haven read_dta
#' @importFrom labelled var_label var_label<-
#' @importFrom purrr safely
#' @importFrom tibble as_tibble rowid_to_column
#' @importFrom tidyselect all_of everything
#' @importFrom utils object.size
#'
#' @export

read_dta <- function(file,
                     id = NULL,
                     doi = NULL,
                     .name_repair = "unique") {
  source_file_info <- valid_file_info(file)

  safely_read_haven_dta <- purrr::safely(.f = haven::read_dta)

  tmp <- safely_read_haven_dta(
    file = file,
    .name_repair = .name_repair
  )

  if (!is.null(tmp$error)) {
    warning(tmp$error, "\nReturning an empty survey.")
    return(
      survey(data.frame(), id = "Could not read file", filename = fs::path_file(file), doi = doi)
    )
  } else {
    tmp <- tmp$result
  }

  tmp <- tmp %>%
    tibble::rowid_to_column(var = "rowid")

  all_vars <- names(tmp)

  assertthat::assert_that(length(all_vars) > 0,
    msg = "The STATA file has no names."
  )

  filename <- fs::path_file(file)

  if (is.null(id)) {
    id <- fs::path_ext_remove(filename)
  }

  if (is.null(doi) && "doi" %in% names(tmp)) {
    doi <- tmp$doi[1]
  }

  tmp$rowid <- paste0(id, "_", tmp$rowid)


  label_orig <- lapply(tmp, labelled::var_label)

  labelled::var_label(
    tmp$rowid
  ) <- paste0("Unique identifier in ", id)

  converted <- tmp[!vapply(
    tmp,
    function(x) is.null(attr(x, "labels")),
    logical(1)
  )]

  converted <- converted[
    vapply(
      converted,
      function(x) length(attr(x, "labels")) > 0,
      logical(1)
    )
  ]

  converted <- converted %>%
    mutate_all(as_labelled_spss_survey, id)

  not_converted <- tmp %>%
    select(-all_of(names(converted)))

  convert_fake_labelled <- function(x) {
    # Fake labelled cases do not have labels, and they confuse the labelling functions
    # They should be immediately imported as non-labelled vectors

    if (!inherits(x, "haven_labelled")) {
      return(x)
    }

    if (inherits(x, "double") & length(attr(x, "labels")) == 0) {
      as_numeric(x)
    } else if (inherits(x, "character") & length(attr(x, "labels")) == 0) {
      as_character(x)
    } else {
      x
    }
  }

  not_converted <- not_converted %>%
    mutate(
      across(
        everything(),
        convert_fake_labelled
      )
    )

  if (ncol(converted) == 0) {
    return_df <- not_converted
  } else if (ncol(not_converted) == 0) {
    return_df <- converted
  } else {
    return_df <- bind_cols(not_converted, converted)
  }

  return_df <- return_df %>%
    select(all_of(all_vars))


  labelling_orig <- names(label_orig)
  labelling_orig[as.numeric(which(vapply(label_orig, is.null, logical(1))))] <- ""

  original_labels <- lapply(
    label_orig,
    function(x) {
      if (is.null(x)) "" else x
    }
  )

  for (i in seq_along(return_df)) {
    # Only labelled classes will have a label
    labelled::var_label(return_df[[i]]) <- original_labels[[i]]
  }

  return_survey <- survey(return_df,
    id = id,
    filename = filename,
    doi = doi
  )

  object_size <- as.numeric(object.size(as_tibble(return_df)))
  attr(return_survey, "object_size") <- object_size
  attr(return_survey, "source_file_size") <- source_file_info$size

  return_survey
}
