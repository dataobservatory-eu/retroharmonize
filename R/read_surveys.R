#' Read survey files into memory or save as `.rds`
#'
#' Import one or more survey files into R using a consistent survey
#' import workflow. The function supports SPSS (`.sav`, `.por`),
#' Stata (`.dta`), R (`.rds`), and CSV files.
#'
#' Use [read_survey()] to import a single survey file and
#' `read_surveys()` to import multiple files in a loop.
#'
#' When `export_path` is `NULL`, imported surveys are returned as
#' a list in memory. When `export_path` is a valid directory,
#' imported surveys are saved as `.rds` files with
#' [base::saveRDS()].
#'
#' Files that cannot be imported are skipped gracefully. A message
#' is printed and `NULL` is returned for the affected file.
#'
#' @param survey_paths A character vector containing full or relative
#'   paths to survey files.
#'
#' @param .f Import function to use. When `NULL`, the appropriate
#'   import function is selected automatically from the file
#'   extension.
#'
#'   Supported formats are:
#'
#'   \describe{
#'     \item{`.sav`, `.por`}{[read_spss()]}
#'     \item{`.dta`}{[read_dta()]}
#'     \item{`.rds`}{[read_rds()]}
#'     \item{`.csv`}{[read_csv()]}
#'   }
#'
#' @param export_path Optional path where imported surveys should
#'   be saved as `.rds` files. Defaults to `NULL`.
#'
#' @param ids Optional survey identifiers.
#'
#' @param dois Optional DOI identifiers for the imported surveys.
#'
#' @param ... Additional arguments passed to the import function.
#'
#' @return
#'
#' If `export_path = NULL`, a list of imported survey objects.
#'
#' If `export_path` is provided, a character vector containing
#' exported `.rds` file names.
#'
#' Imported surveys are returned as data frame-like
#' [survey()] objects with metadata attributes retained for
#' reproducible workflows.
#'
#' @examples
#' file1 <- system.file(
#'   "examples",
#'   "ZA7576.rds",
#'   package = "retroharmonize"
#' )
#'
#' file2 <- system.file(
#'   "examples",
#'   "ZA5913.rds",
#'   package = "retroharmonize"
#' )
#'
#' surveys <- read_surveys(
#'   c(file1, file2),
#'   .f = "read_rds"
#' )
#'
#' @importFrom assertthat assert_that
#' @importFrom fs path_file
#' @importFrom purrr safely
#'
#' @family import functions
#' @seealso [read_survey()], [survey()]
#' @export

read_surveys <- function(survey_paths,
                         .f = NULL,
                         export_path = NULL,
                         ids = NULL,
                         dois = NULL,
                         ...) {
  arguments <- list(...)

  import_file_vector <- survey_paths
  existing_files <- which(file.exists(import_file_vector))
  not_existing_files <- which(!file.exists(import_file_vector))

  if (length(existing_files) == 0) {
    stop("None of the files on read_surveys(survey_paths=...) exist.")
  }

  if (length(not_existing_files) > 0) {
    missing_files <- paste(import_file_vector[not_existing_files], collapse = ";\n")
    warning("Some files on 'survey_paths' do not exist:\n", missing_files)
  }

  import_file_vector <- import_file_vector[existing_files]

  if (!is.null(ids)) {
    ids <- ids[existing_files]
  } else {
    ids <- rep(NULL, length(import_file_vector))
  }

  if (!is.null(dois)) {
    dois <- dois[existing_files]
  } else {
    dois <- rep(NULL, length(import_file_vector))
  }


  return_survey_list <- lapply(
    seq_along(import_file_vector),
    function(x) {
      read_survey(
        file_path = import_file_vector[x],
        .f = .f,
        export_path = export_path,
        doi = dois[x],
        id = ids[x],
        ... = ...
      )
    }
  )

  return_survey_list
}

#' @rdname read_surveys
#' @importFrom fs file_exists dir_exists path_ext_remove
#' @importFrom glue glue
#' @importFrom assertthat assert_that
#' @importFrom purrr safely
#' @keywords internal
read_survey <- function(file_path,
                        .f = NULL,
                        export_path = NULL,
                        doi = NULL,
                        id = NULL,
                        ...) {
  arguments <- list(...)

  assert_that(fs::file_exists(file_path),
    msg = glue::glue("The file {file_path} does not exist.")
  )

  if (is.null(.f)) .f <- find_import_function(file_path) ## See definition below

  if (.f == "read_rds") {
    res <- safely(read_rds)(file_path)
  } else if (.f == "read_spss") {
    res <- safely(read_spss)(file_path)
  } else if (.f == "read_dta") {
    res <- safely(read_dta)(file_path)
  } else if (.f == "read_csv") {
    res <- safely(read_csv)(file = file_path, doi = doi, id = id, ...)
  }

  if (is.null(res$error)) {
    # No problem reading and should be saved --------------------------------------
    if (!is.null(export_path)) {
      if (fs::dir_exists(export_path)) {
        # Returned survey ----------------------------------------------------------------
        imported_survey <- res$result
        source_file_name <- attr(imported_survey, "filename")

        # Saving location exists, return file name after saving --------------------
        new_file_name <- paste0(fs::path_ext_remove(source_file_name), ".rds")
        saveRDS(res$result,
          file = file.path(export_path, new_file_name),
          version = 2
        )
        return(new_file_name)
      } else {
        # Exception: cannot be exported, returning to  memory -------------------------------
        warning("Cannot save to ", export_path, ", returning to memory instead.")
        return(res$result)
      }
    }
    return(res$result)
  }

  if (!is.null(res$error)) {
    # There was a problem reading -------------------------------------------------
    # Even though the file exists (checked in the beginning of the function) ------
    message(res$error)
    message("This is an error in read_survey(", file_path, ", ", .f, ")")
    message("Returning NULL for this file.")
    return(NULL)
  }
}


#' @title Find import function by file extension
#' @description This is an internal utility to select the appropriate importing function.
#' @return The name of the function that should read \code{file_path} based on the file
#' extension.
#' @importFrom fs path_ext path_ext_remove path_file
#' @importFrom glue glue
#' @inheritParams read_surveys
#' @keywords internal
find_import_function <- function(file_path) {
  survey_file_ext <- fs::path_ext(file_path)

  if (survey_file_ext %in% c("sav", "por")) {
    "read_spss"
  } else if (survey_file_ext == "rds") {
    "read_rds"
  } else if (survey_file_ext == "dta") {
    "read_dta"
  } else if (survey_file_ext == "csv") {
    "read_csv"
  } else {
    stop(glue("No adequate importing function was found for {file_path}."))
  }
}
