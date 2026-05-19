#' Create metadata tables from survey datasets
#'
#' Create a variable-level metadata table from one or more survey
#' datasets. Metadata are extracted either from survey objects already
#' loaded into memory or directly from survey files.
#'
#' The resulting metadata table contains information about:
#'
#' \itemize{
#'   \item variable names and labels,
#'   \item storage classes,
#'   \item value labels,
#'   \item user-defined missing values,
#'   \item and missing value ranges.
#' }
#'
#' `metadata_create()` is a convenience wrapper around repeated
#' [metadata_survey_create()] calls.
#'
#' @param survey_paths Optional character vector containing paths to
#'   survey files.
#'
#' @param survey_list Optional list of survey objects of class
#'   [survey()].
#'
#' @param .f Import function used to read surveys from
#'   `survey_paths`. When `NULL`, the import function is inferred from
#'   the file extension.
#'
#' @return A data frame containing variable-level survey metadata.
#'
#' @examples
#' examples_dir <- system.file(
#'   "examples",
#'   package = "retroharmonize"
#' )
#'
#' my_rds_files <- dir(examples_dir)[grepl(
#'   "\\.rds$",
#'   dir(examples_dir)
#' )]
#'
#' example_surveys <- read_surveys(
#'   file.path(examples_dir, my_rds_files)
#' )
#'
#' metadata_create(example_surveys)
#'
#' @family metadata functions
#' @seealso [metadata_survey_create()], [create_variable_catalog()]
#' @export

metadata_create <- function(survey_list = NULL,
                            survey_paths = NULL,
                            .f = NULL) {
  if (!is.null(survey_list)) {
    validate_survey_list(survey_list)
    if (!"list" %in% class(survey_list)) {
      assert_that(is.survey(survey_list),
        msg = "metadata_create(survey_list, ...) is neither a list nor a survey."
      )
      survey_id <- attr(survey_list, "id")
      survey_list <- list(i = survey_list)
      names(survey_list)[1] <- survey_id
    }
    metadata_list <- lapply(survey_list, metadata_survey_create)
    do.call(rbind, metadata_list)
  } else if (is.null(survey_paths)) {
    stop("Error in metadata_surveys_create(): both 'survey_list' and 'survey_paths' are NULL.")
  } else {
    validate_survey_files(survey_paths)
    read_survey_create_metadata <- function(x, .f) {
      tmp <- read_survey(x, .f)
      message("Read: ", x)
      metadata_survey_create(tmp)
    }

    metadata_list <- lapply(
      X = survey_paths,
      FUN = function(x) read_survey_create_metadata(x, .f)
    )
    do.call(rbind, metadata_list)
  }
}

#' @rdname metadata_create
#' @details The form \code{metadata_waves_create} is deprecated.

metadata_waves_create <- function(survey_list) {
  .Deprecated(
    new = "metadata_surveys_create",
    msg = "metadata_waves_create() is deprecated, use create_surveys_metadata() instead",
    old = "merge_waves"
  )
  metadata_survey_create(survey_list)
}

#' Create variable-level metadata from a survey dataset
#'
#' Extract variable-level metadata from a survey dataset and return
#' the result as a nested data frame.
#'
#' The metadata table contains:
#'
#' \itemize{
#'   \item variable names and labels,
#'   \item imported storage classes,
#'   \item value labels,
#'   \item user-defined missing values,
#'   \item missing value ranges,
#'   \item and summary counts of labelled categories.
#' }
#'
#' For multiple surveys, use [metadata_create()], which applies
#' `metadata_survey_create()` across a list of surveys or survey files.
#'
#' @param survey A survey object of class [survey()].
#'
#'   Survey objects are typically created with:
#'
#'   \itemize{
#'     \item [read_rds()]
#'     \item [read_spss()]
#'     \item [read_dta()]
#'     \item [read_csv()]
#'     \item [read_survey()]
#'   }
#'
#'   Survey objects can also be created manually from a data frame
#'   with [survey()].
#'
#' @return A nested data frame containing:
#'
#' \describe{
#'   \item{filename}{Original survey file name.}
#'   \item{id}{Survey identifier.}
#'   \item{var_name_orig}{Original variable name.}
#'   \item{class_orig}{Imported storage class.}
#'   \item{var_label_orig}{Original variable label.}
#'   \item{labels}{List column of value labels.}
#'   \item{valid_labels}{List column of non-missing value labels.}
#'   \item{na_labels}{List column of user-defined missing labels.}
#'   \item{na_range}{List column containing user-defined missing ranges.}
#'   \item{n_labels}{Number of labelled categories.}
#'   \item{n_valid_labels}{Number of non-missing categories.}
#'   \item{n_na_labels}{Number of missing categories.}
#' }
#'
#' @examples
#' metadata_survey_create(
#'   survey = read_rds(
#'     system.file(
#'       "examples",
#'       "ZA7576.rds",
#'       package = "retroharmonize"
#'     )
#'   )
#' )
#'
#' @importFrom assertthat assert_that
#' @importFrom dplyr group_by left_join mutate select ungroup
#' @importFrom labelled na_range na_values val_labels var_label
#' @importFrom purrr map
#' @importFrom tibble tibble
#' @importFrom tidyr nest unnest
#'
#' @family metadata functions
#' @seealso [metadata_create()], [create_variable_catalog()]
#' @export

metadata_survey_create <- function(survey) {
  ## Assertions before running the function -----------------------------
  if ("list" %in% class(survey)) {
    assert_that(all(vapply(survey, is.survey, logical(1))),
      msg = "Parameter 'survey' is not of s3 class survey or a list of them. See ?is.survey."
    )
    metadata_df <- metadata_create(survey_list = survey)
    return(metadata_df)
  } else if (
    # Accidentally the file names were supplied.
    # This will validate if the surveys are indeed existing files.
    is.character(survey)) {
    warning("The parameter 'survey' is not a single survey but a character vector. Try to understand them as a file names. See ?metadata_create.")
    metadata_df <- metadata_create(survey_list = survey)
    return(metadata_df)
  } else {
    assert_that(is.survey(survey),
      msg = "Parameter 'survey' must be of s3 class survey. See ?is.survey."
    )
  }

  filename <- attr(survey, "filename")

  if (is.null(filename)) filename <- "unknown"

  id <- ifelse(is.null(attr(survey, "id")), attr(survey, "identifier"), attr(survey, "id"))
  if (is.null(id)) id <- "missing"

  if (ncol(survey) == 0) {
    # Special case when file could not be read and survey is empty
    return(metadata_initialize(
      filename = filename,
      id = paste0(filename, " could not be read.")
    ))
  }

  var_label_orig <- lapply(survey, labelled::var_label)

  class_orig <- vapply(survey, function(x) class(x)[1], character(1))

  metadata <- tibble(
    filename = filename,
    id = id,
    var_name_orig = names(survey),
    class_orig = class_orig,
    var_label_orig = ifelse(vapply(var_label_orig, is.null, logical(1)),
      "",
      unlist(var_label_orig)
    ) %>%
      as.character() %>%
      var_label_normalize()
  )

  fn_valid_range <- function(x) {
    labelled::val_labels(x)[!labelled::val_labels(x) %in% labelled::na_values(x)]
  }

  na_labels <- function(x) {
    # labels that refer to na_values
    labs <- labelled::val_labels(x)
    if (is.null(labs)) {
      return(NA_character_)
    }
    selected_labs <- labelled::na_values(x)
    labs[labs %in% selected_labs]
  }

  to_list_column <- function(.f = "na_values") {
    if (.f == "na_labels") {
      x <- sapply(
        survey,
        na_labels
      )
    } else if (.f == "na_range") {
      x <- sapply(
        survey,
        labelled::na_range
      )
    } else if (.f == "valid_range") {
      x <- sapply(
        survey,
        fn_valid_range
      )
    } else if (.f == "labels") {
      x <- sapply(
        survey,
        labelled::val_labels
      )
    } else {
      stop(
        "Unknown metadata field: ",
        .f
      )
    }

    x[vapply(x, is.null, logical(1))] <- NA_character_

    names(x) <- names(survey)

    x
  }

  range_df <- tibble::tibble(
    var_name_orig = names(survey),
    labels = rep(NA_character_, length(names(survey))),
    valid_labels = rep(NA_character_, length(names(survey))),
    na_labels = rep(NA_character_, length(names(survey))),
    na_range = rep(NA_character_, length(names(survey))),
    n_labels = rep(0, length(names(survey))),
    n_valid_labels = rep(0, length(names(survey))),
    n_na_labels = rep(0, length(names(survey)))
  )

  if (
    any(vapply(
      lapply(survey, class),
      function(x) any(grepl("labelled", x)),
      logical(1)
    ))
  ) {
    range_df <- tibble::tibble(
      var_name_orig = names(survey),
      labels = to_list_column(.f = "labels"),
      valid_labels = to_list_column(.f = "valid_range"),
      na_labels = to_list_column(.f = "na_labels"),
      na_range = to_list_column(.f = "na_range")
    )
    label_length <- function(x) {
      ifelse(is.na(x[[1]])[1] | length(x[[1]]) == 0,
        0, length(x[[1]])
      )
    }

    range_df$n_labels <- vapply(
      1:nrow(range_df),
      function(x) label_length(range_df$labels[x]),
      numeric(1)
    )
    range_df$n_valid_labels <- vapply(
      1:nrow(range_df),
      function(x) label_length(range_df$valid_labels[x]),
      numeric(1)
    )
    range_df$n_na_labels <- vapply(
      1:nrow(range_df),
      function(x) label_length(range_df$na_labels[x]),
      numeric(1)
    )
  } else {
    ## Special case when there are no labelled variables present
    return(
      metadata %>%
        left_join(range_df,
          by = "var_name_orig"
        ) %>%
        as.data.frame()
    )
  }

  return_df <- metadata %>%
    left_join(
      range_df %>%
        group_by(var_name_orig) %>%
        tidyr::nest(),
      by = "var_name_orig"
    ) %>%
    tidyr::unnest(cols = "data") %>%
    ungroup() %>%
    mutate(
      n_na_labels = as.numeric(n_na_labels),
      n_valid_labels = as.numeric(n_valid_labels),
      n_labels = as.numeric(n_labels)
    ) %>%
    as.data.frame()

  change_label_to_empty <- function() {
    "none" <- NA_real_
  }
  ## Avoid the accidental creation of empty CHARACTER lists, because they do not bind with
  ## numeric lists.

  return_df$label_type <- vapply(return_df$labels, function(x) class(x)[1], character(1))
  return_dflabels <- ifelse(return_df$label_type == "character" & return_df$n_labels == 0,
    yes = change_label_to_empty(),
    no = return_df$labels
  )
  return_df$valid_labels <- ifelse(return_df$label_type == "character" & return_df$n_labels == 0,
    yes = change_label_to_empty(),
    no = return_df$valid_labels
  )
  return_df$na_labels <- ifelse(return_df$label_type == "character" & return_df$n_labels == 0,
    yes = change_label_to_empty(),
    no = return_df$na_labels
  )

  return_df %>%
    select(-label_type)
}

# -----------------------------------------------------------------------
#' @title Initialize a metadata data frame
#'
#' @importFrom tibble tibble
#' @param filename A file name
#' @param id An id.
#' @return A nested data frame with metadata and the range of
#' labels, na_values and the na_range itself.
#' @keywords internal
metadata_initialize <- function(filename, id) {
  tibble(
    filename = filename,
    id = id,
    class_orig = NA_character_,
    var_name_orig = NA_character_,
    var_label_orig = NA_character_,
    labels = NA_character_,
    valid_labels = list("none" = NA_real_),
    na_labels = list("none" = NA_real_),
    na_range = list("none" = NA_real_),
    n_labels = 0,
    n_valid_labels = 0,
    n_na_labels = 0
  )
}
