#' Read a survey from an `.rds` file
#'
#' Import a serialized survey object stored in `.rds` format and return
#' it as a `survey` object with harmonized metadata attributes.
#'
#' This function restores survey objects previously saved with
#' [base::saveRDS()] or exported from the `retroharmonize`
#' workflow. The returned object retains survey metadata and gains
#' additional provenance attributes such as source file name and file size.
#'
#' @param file Path to an `.rds` file containing a survey object.
#' @param dataset_bibentry Optional bibliographic metadata created with
#'   [dataset::dublincore()] or [dataset::datacite()].
#' @param id Optional survey identifier. Defaults to the file name
#'   without extension.
#' @param doi Optional DOI identifier for the survey.
#'
#' @return A `survey` object inheriting from `data.frame` and `tbl_df`
#'   with survey metadata attributes.
#'
#' @details
#' If the file cannot be read, an empty `survey` object is returned
#' and a warning is emitted.
#'
#' The function:
#'
#' - restores the serialized object,
#' - validates source file information,
#' - normalizes `rowid`,
#' - records provenance metadata,
#' - and stores object and source file sizes as attributes.
#'
#' @family import functions
#'
#' @examples
#' path <- system.file(
#'   "examples",
#'   "ZA7576.rds",
#'   package = "retroharmonize"
#' )
#'
#' survey_object <- read_rds(path)
#'
#' attr(survey_object, "id")
#' attr(survey_object, "filename")
#' attr(survey_object, "doi")
#'
#' @importFrom dataset dataset_df
#' @importFrom fs path_ext_remove path_file
#' @importFrom labelled var_label<-
#' @importFrom purrr safely
#' @importFrom tibble as_tibble
#' @importFrom utils object.size
#'
#' @export

read_rds <- function(file,
                     dataset_bibentry = NULL,
                     id = NULL,
                     doi = NULL) {
  
  source_file_info <- valid_file_info(file)
  filename <- fs::path_file(file)

  if (is.null(id)) {
    id <- fs::path_ext_remove(filename)
  }

  safely_readRDS <- purrr::safely(readRDS)

  tmp <- safely_readRDS(file = file)

  if (!is.null(tmp$error)) {
    warning(tmp$error, "\nReturning an empty survey.")
    return(
      survey(data.frame(), id = "Could not read file", filename = filename, doi = doi)
    )
  } else {
    tmp <- tmp$result
  }

  # if ( ! "rowid" %in% names(tmp) ) {
  #  tmp <- tibble::rowid_to_column(tmp)
  # }

  tmp_df <- dataset_df(tmp, 
                       identifier = doi, 
                       dataset_bibentry = dataset_bibentry)

  if (is.null(doi)) {
    if ("doi" %in% colnames(tmp_df)) {
      doi <- tmp_df$doi[1]
    } else {
      doi <- ""
    }
  }

  tmp_df$rowid <- paste0(
    id,
    "_",
    gsub(paste0("^", id, "_?"), "", tmp_df$rowid)
  )
  
  labelled::var_label(
    tmp_df$rowid
  ) <- paste0("Unique identifier in ", id)

  return_survey <- survey(tmp_df, id = id, filename = filename, doi = doi)

  object_size <- as.numeric(object.size(as_tibble(tmp_df)))
  attr(return_survey, "object_size") <- object_size
  attr(return_survey, "source_file_size") <- source_file_info$size

  return_survey
}
