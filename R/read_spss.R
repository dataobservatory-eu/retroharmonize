#' Read SPSS survey files
#'
#' Import SPSS survey files in `.sav`, `.zsav`, or `.por` format and
#' convert them into harmonized `survey` objects with preserved metadata,
#' labelled variables, and provenance information.
#'
#' This function wraps [haven::read_spss()] and adds:
#'
#' - error handling,
#' - harmonized survey metadata,
#' - `rowid` creation and normalization,
#' - preservation of variable labels,
#' - conversion of labelled SPSS vectors,
#' - handling of malformed labelled variables,
#' - and provenance metadata.
#'
#' @details
#' `read_sav()` reads both `.sav` and `.zsav` files.
#' `read_por()` reads portable SPSS `.por` files.
#' `read_spss()` automatically dispatches to the appropriate importer
#' based on file extension.
#'
#' Variables that inherit from `haven_labelled` but do not contain
#' valid label definitions are converted to standard numeric or
#' character vectors.
#'
#' If a file cannot be imported, the function returns an empty
#' `survey` object and emits a warning.
#'
#' @param file Path to an SPSS survey file.
#' @param user_na Logical. Should user-defined missing values be imported?
#'   Defaults to `TRUE`.
#' @param dataset_bibentry Optional bibliographic metadata created with
#'   [dataset::dublincore()] or [dataset::datacite()].
#' @param id Optional survey identifier. Defaults to the file name
#'   without extension.
#' @param doi Optional DOI identifier.
#' @param .name_repair Strategy for repairing invalid or duplicated
#'   column names. Passed to [haven::read_spss()].
#'
#' @return
#' A `survey` object inheriting from `data.frame` and `tbl_df`.
#'
#' Variable labels are stored in the `"label"` attribute of each variable.
#'
#' Additional provenance metadata are stored as attributes, including:
#'
#' - `"id"`
#' - `"doi"`
#' - `"object_size"`
#' - `"source_file_size"`
#'
#' @family import functions
#'
#' @examples
#' \donttest{
#' path <- system.file(
#'   "examples",
#'   "iris.sav",
#'   package = "haven"
#' )
#'
#' survey_object <- read_spss(path)
#'
#' attr(survey_object, "id")
#' attr(survey_object, "filename")
#' }
#'
#' @importFrom assertthat assert_that
#' @importFrom dplyr across bind_cols mutate select
#' @importFrom fs path_ext_remove path_file
#' @importFrom haven read_spss
#' @importFrom labelled var_label var_label<-
#' @importFrom purrr safely
#' @importFrom tibble as_tibble rowid_to_column
#' @importFrom tidyselect all_of
#' @importFrom utils object.size
#'
#' @export

read_spss <- function(file,
                      user_na = TRUE,
                      dataset_bibentry = NULL,
                      id = NULL,
                      doi = NULL,
                      .name_repair = "unique") {
  # to do: with ...
  # skip = NULL,
  # col_select = NULL
  # n_max =NULL
  # col_select_input <- col_select
  # how to pass on optional parameters?

  source_file_info <- valid_file_info(file)

  safely_read_haven_spss <- safely(.f = haven::read_spss)

  tmp <- safely_read_haven_spss(
    file = file,
    user_na = user_na,
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

  assert_that(length(all_vars) > 0,
    msg = "The SPSS file has no names."
  )

  filename <- path_file(file)

  if (is.null(id)) {
    id <- path_ext_remove(filename)
  }

  if (is.null(doi) && "doi" %in% names(tmp)) {
    doi <- tmp$doi[1]
  }

  tmp$rowid <- paste0(id, "_", tmp$rowid)


  labelled::var_label(
    tmp$rowid
  ) <- "Unique ID"

  label_orig <- lapply(tmp, labelled::var_label)

  converted <- tmp[
    !vapply(
      tmp,
      function(x) is.null(attr(x, "labels")),
      logical(1)
    )
  ]

  converted <- converted[
    vapply(
      converted,
      function(x) length(attr(x, "labels")) > 0,
      logical(1)
    )
  ]

  converted <- converted %>%
    mutate(
      across(
        everything(),
        ~ as_labelled_spss_survey(.x, id)
      )
    )

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

  persistent_id <- if (!is.null(doi)) doi else id

  return_survey <- survey_df(
    return_df,
    dataset_bibentry = dataset_bibentry,
    filename = filename,
    identifier = persistent_id
  )

  object_size <- as.numeric(object.size(as_tibble(return_df)))
  attr(return_survey, "object_size") <- object_size
  attr(return_survey, "source_file_size") <- source_file_info$size


  if (dataset::dataset_title(return_survey) == "Untitled Dataset") {
    dataset::dataset_title(return_survey, overwrite = TRUE) <- "Untitled Survey"
  }

  ## For backward compatibility
  attr(return_survey, "id") <- id
  attr(return_survey, "doi") <- doi

  return_survey
}
