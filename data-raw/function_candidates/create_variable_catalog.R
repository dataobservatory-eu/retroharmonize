#' Create a variable catalog from survey files
#'
#' Create a tidy metadata catalog of variables contained in one or
#' more survey files. Each row of the resulting tibble describes a
#' variable occurrence within a dataset, including variable labels,
#' storage classes, value labels, and user-defined missing value
#' definitions.
#'
#' The function is designed for metadata discovery workflows prior
#' to harmonization. It creates a searchable variable inventory that
#' can be filtered, grouped, or compared across datasets.
#'
#' @param survey_files A character vector containing survey file paths.
#'
#' @param reader A function used to read survey files. Defaults to
#'   [haven::read_sav()].
#'
#' @param dataset_id An optional character vector containing dataset
#'   identifiers. When `NULL`, the file basenames are used.
#'
#' @param dataset_label An optional character vector containing
#'   human-readable dataset labels. Currently reserved for future use.
#'
#' @param extract_value_labels Logical. If `TRUE`, extract value labels
#'   from labelled survey vectors.
#'
#' @param extract_missing Logical. If `TRUE`, extract user-defined
#'   missing value metadata (`na_values` and `na_range`).
#'
#' @param verbose Logical. If `TRUE`, print progress messages during
#'   catalog creation.
#'
#' @return A tibble of class `survey_catalog`. Each row represents one
#'   variable occurrence in one dataset.
#'
#'   The returned tibble contains:
#'
#'   \describe{
#'     \item{dataset_id}{Dataset identifier.}
#'     \item{file}{Survey file basename.}
#'     \item{var_index}{Variable position within the survey file.}
#'     \item{var_name}{Variable name in the source dataset.}
#'     \item{var_label}{Human-readable variable label.}
#'     \item{var_class}{Storage class of the variable.}
#'     \item{n_obs}{Number of observations in the dataset.}
#'     \item{value_labels}{List-column containing labelled values.}
#'     \item{na_values}{List-column containing user-defined missing values.}
#'     \item{na_range}{List-column containing user-defined missing ranges.}
#'   }
#'
#' @examples
#' \dontrun{
#'
#' gesis_files <- tibble::tibble(
#'   survey_file = file.path(
#'     "data-raw/gesis",
#'     c(
#'       "ZA4529_v3-0-1.sav",
#'       "ZA5688_v6-0-0.sav"
#'     )
#'   ),
#'   dataset_id = c(
#'     "ZA4529",
#'     "ZA5688"
#'   )
#' )
#'
#' catalog <- create_variable_catalog(
#'   survey_files = gesis_files$survey_file,
#'   dataset_id = gesis_files$dataset_id
#' )
#'
#' dplyr::glimpse(catalog)
#' }
#'
#' @importFrom haven read_sav
#' @importFrom purrr map map_chr map2_dfr
#' @importFrom tibble tibble
#'
#' @export
create_variable_catalog <- function(
    survey_files,
    reader = haven::read_sav,
    dataset_id = NULL,
    dataset_label = NULL,
    extract_value_labels = TRUE,
    extract_missing = TRUE,
    verbose = TRUE
) {
  
  stopifnot(is.character(survey_files))
  
  if (is.null(dataset_id)) {
    dataset_id <- basename(survey_files)
  }
  
  if (length(dataset_id) == 1) {
    dataset_id <- rep(dataset_id, length(survey_files))
  }
  
  stopifnot(length(dataset_id) == length(survey_files))
  
  out <- purrr::map2_dfr(
    survey_files,
    dataset_id,
    function(file, id) {
      
      if (verbose) {
        message("Reading: ", file)
      }
      
      x <- reader(file)
      
      tibble::tibble(
        dataset_id = id,
        file = basename(file),
        
        var_index = seq_along(x),
        
        var_name = names(x),
        
        var_label = unname(
          purrr::map_chr(
            x,
            ~ attr(.x, "label") %||% NA_character_
          )
        ),
        
        var_class = unname(
          purrr::map_chr(
            x,
            ~ class(.x)[1]
          )
        ),
        
        n_obs = nrow(x),
        
        value_labels = if (extract_value_labels) {
          purrr::map(
            x,
            ~ attr(.x, "labels")
          )
        } else {
          vector("list", length(x))
        },
        
        na_values = if (extract_missing) {
          purrr::map(
            x,
            ~ attr(.x, "na_values")
          )
        } else {
          vector("list", length(x))
        },
        
        na_range = if (extract_missing) {
          purrr::map(
            x,
            ~ attr(.x, "na_range")
          )
        } else {
          vector("list", length(x))
        }
      )
    }
  )
  
  class(out) <- c(
    "survey_catalog",
    class(out)
  )
  
  out
}