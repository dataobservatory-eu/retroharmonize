#' Retrieve a survey from a survey list
#'
#' Extract a single `survey` object from a list of surveys using either
#' its survey identifier or source file name.
#'
#' @description
#' `pull_survey()` retrieves a survey object from a list created with
#' [read_surveys()].
#'
#' Surveys can be selected using:
#'
#' - the survey identifier stored in the `"id"` attribute, or
#' - the original source file name stored in the `"filename"` attribute.
#'
#' @param survey_list A list of `survey` objects.
#'
#' @param id Optional survey identifier.
#'
#' @param filename Optional source file name.
#'
#' @return
#' A single `survey` object.
#'
#' @details
#' Either `id` or `filename` must be supplied.
#'
#' The function throws an error if:
#'
#' - neither argument is provided;
#' - the requested survey cannot be found;
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
#' survey_files <- dir(
#'   examples_dir,
#'   pattern = "\\.rds$"
#' )
#'
#' example_surveys <- read_surveys(
#'   file.path(examples_dir, survey_files)
#' )
#'
#' pull_survey(
#'   example_surveys,
#'   id = "ZA5913"
#' )
#'
#' @seealso
#' [read_surveys()]
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
