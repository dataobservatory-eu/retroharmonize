#' Retrieve a survey from a survey list
#'
#' Extract a single survey object from a list of surveys using either
#' its survey identifier or source file name.
#'
#' @param survey_list A list of `survey` objects.
#' @param id Optional survey identifier stored in the `"id"` attribute.
#' @param filename Optional source file name stored in the `"filename"`
#'   attribute.
#'
#' @return
#' A single `survey` object.
#'
#' @details
#' Either `id` or `filename` must be supplied.
#'
#' The function throws an error if:
#'
#' - neither identifier is provided,
#' - the requested survey is not found,
#' - or multiple surveys match the query.
#'
#' @family import functions
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
#' pull_survey(
#'   example_surveys,
#'   id = "ZA5913"
#' )
#'
#' @export

pull_survey <- function(survey_list, id = NULL, filename = NULL) {
  if (is.null(id) && is.null(filename)) {
    stop("Either the id or the filename must be given")
  }

  if (!is.null(id)) {
    ids <- vapply(survey_list, function(x) attr(x, "id"), character(1))
    selected_id <- which(ids == id)

    if (length(selected_id) > 1) {
      stop("The id='", id, "' is not unique.")
    }
    if (length(selected_id) == 0) {
      stop("The id='", id, "' is not present.")
    }
    return(survey_list[[selected_id]])
  }

  filenames <- vapply(survey_list, function(x) attr(x, "filename"), character(1))
  selected_file <- which(filenames == filename)
  if (length(selected_file) > 1) {
    stop("The filenames='", filenames, "' is not unique.")
  }
  if (length(selected_file) == 0) {
    stop("The filenames='", filenames, "' is not present.")
  }

  survey_list[[selected_file]]
}
