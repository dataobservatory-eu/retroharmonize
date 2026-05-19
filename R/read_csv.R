#' Read a survey dataset from a CSV file
#'
#' Import a survey dataset stored in comma-separated value (`.csv`)
#' format and convert it into a survey-compatible tibble with
#' reproducibility metadata retained as attributes.
#'
#' The imported object is returned as a tibble with additional survey
#' metadata such as identifiers, DOI references, and optional dataset
#' bibliographic metadata.
#'
#' @param file Path to a `.csv` file.
#'
#' @param dataset_bibentry Optional bibliographic metadata created
#'   with [dataset::dublincore()] or [dataset::datacite()].
#'
#' @param id Optional dataset identifier. When omitted, the file name
#'   without extension is used.
#'
#' @param doi Optional dataset DOI identifier.
#'
#' @param ... Additional arguments passed to
#'   [utils::read.csv()].
#'
#' @return A tibble-like survey object with metadata attributes
#'   retained for reproducible workflows.
#'
#' @examples
#' # Create a temporary CSV file:
#' path <- system.file(
#'   "examples",
#'   "ZA7576.rds",
#'   package = "retroharmonize"
#' )
#'
#' read_survey <- read_rds(path)
#'
#' test_csv_file <- tempfile(fileext = ".csv")
#'
#' write.csv(
#'   x = read_survey,
#'   file = test_csv_file,
#'   row.names = FALSE
#' )
#'
#' # Read the CSV file:
#' re_read <- read_csv(
#'   file = test_csv_file,
#'   id = "ZA7576",
#'   doi = "test_doi"
#' )
#'
#' @importFrom dataset datacite dataset_df defined dublincore is.dataset_df
#' @importFrom dplyr any_of select
#' @importFrom fs is_file path_ext_remove path_file
#' @importFrom labelled to_labelled var_label `var_label<-`
#' @importFrom purrr safely
#' @importFrom tibble as_tibble rowid_to_column
#' @importFrom utils object.size read.csv
#'
#' @family import functions
#' @export

read_csv <- function(file,
                     id = NULL,
                     doi = NULL,
                     dataset_bibentry = NULL,
                     ...) {
  # filename <- fs::path_file(file)

  filename <- file
  source_file_info <- valid_file_info(file)

  if (is.null(id)) {
    id <- fs::path_ext_remove(filename)
  }

  safely_readcsv <- purrr::safely(read.csv)

  tmp <- safely_readcsv(file = file)

  if (!is.null(tmp$error)) {
    warning(tmp$error, "\nReturning an empty survey.")
    return(
      survey(data.frame(),
        id = "Could not read file",
        filename = filename,
        doi = doi
      )
    )
  } else {
    tmp <- tmp$result
  }

  tmp <- tmp %>% dplyr::select(-any_of("X"))

  chr_vars <- vapply(
    1:ncol(tmp),
    function(x) inherits(tmp[, x], "character"),
    logical(1)
  )

  chr_unique_n <- vapply(
    which(chr_vars),
    function(x) length(unique(tmp[x, ])),
    integer(1)
  )

  to_fct_vars <- which(chr_vars)[which(chr_unique_n > 1)]


  for (i in to_fct_vars) {
    tmp[, i] <- dataset::defined(as.factor(tmp[, i]))
  }

  tmp_df <- dataset_df(tmp,
    identifier = doi,
    dataset_bibentry = dataset_bibentry
  )


  if (is.null(doi)) {
    if ("doi" %in% names(tmp)) {
      doi <- tmp$doi[1]
    } else {
      doi <- ""
    }
  }

  if (!"rowid" %in% names(tmp)) {
    stop("CSV file does not contain a 'rowid' column.")
  }

  rowid_chr <- as.character(tmp$rowid)

  tmp_df$rowid <- paste0(
    id, "_",
    gsub(id, "", rowid_chr, fixed = TRUE)
  )

  var_label(tmp_df$rowid) <- paste0("Unique identifier in ", id)

  return_survey <- survey_df(
    x = tmp,
    dataset_bibentry = dataset_bibentry,
    identifier = id,
    filename = filename
  )

  object_size <- as.numeric(object.size(as_tibble(tmp)))
  attr(return_survey, "object_size") <- object_size
  attr(return_survey, "source_file_size") <- source_file_info$size

  if (dataset::dataset_title(return_survey) == "Untitled Dataset") {
    dataset::dataset_title(return_survey,
      overwrite = TRUE
    ) <- "Untitled Survey"
  }

  ## For backward compatibility
  attr(return_survey, "id") <- id
  attr(return_survey, "doi") <- doi


  return_survey
}
