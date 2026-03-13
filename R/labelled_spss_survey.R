#' Labelled SPSS-style vectors with survey provenance
#'
#' Create a labelled vector compatible with
#' [haven::labelled_spss()] that carries additional
#' survey-level provenance metadata.
#'
#' The resulting object behaves like a
#' `haven_labelled_spss` vector, but stores:
#' \itemize{
#'   \item a survey identifier;
#'   \item the original variable name;
#'   \item the original value coding.
#' }
#'
#' @details
#' Several arithmetic and statistical summary methods operate on
#' the numeric representation of labelled survey vectors,
#' converting SPSS-style missing values to `NA` before computation.
#'
#' You can coerce `labelled_spss_survey` vectors to numeric,
#' character or factor representation.
#'
#' @param x A vector of values.
#' @param labels A named vector of value labels.
#' @param na_values A vector of values to be treated as missing.
#' @param na_range A numeric range defining missing values.
#' @param label A variable label.
#' @param id A character scalar identifying the survey.
#' @param name_orig Original variable name. Defaults to the name of `x`.
#'
#' @return
#' An object of class `"retroharmonize_labelled_spss_survey"`,
#' extending [haven::labelled_spss()].
#'
#' @seealso
#' [haven::labelled_spss()],
#' [as_factor()],
#' [as_numeric()],
#' [as_character()]
#'
#' @examples
#' x <- labelled_spss_survey(
#'   x = c(1, 2, 9),
#'   labels = c(Yes = 1, No = 2),
#'   na_values = 9,
#'   id = "survey_1"
#' )
#'
#' is.na(x)
#' as_factor(x)
#'
#' @export
labelled_spss_survey <- function(
  x = double(),
  labels = NULL,
  na_values = NULL,
  na_range = NULL,
  label = NULL,
  id = NULL,
  name_orig = NULL
) {
  x_vector <- vctrs::vec_data(x)
  na_values <- vec_cast_named(na_values, x_vector,
    x_arg = "na_values", to_arg = "x"
  )
  labelled <- labelled::labelled(x, labels = labels)

  if (is.null(name_orig)) {
    name_orig <- deparse(substitute(x))
  }

  if (is.null(id)) id <- name_orig

  new_labelled_spss_survey(
    vctrs::vec_data(labelled),
    labels = labels,
    label = label,
    na_values = na_values,
    na_range = na_range,
    id = id,
    name_orig = name_orig
  )
}

#' @keywords internal
new_labelled_spss_survey <- function(x,
                                     labels,
                                     na_values,
                                     na_range,
                                     label,
                                     id,
                                     name_orig) {
  if (!is.null(na_values) && !vctrs::vec_is(x, na_values)) {
    stop("`na_values` must be same type as `x`.",
      call. = FALSE
    )
  }

  if (!is.null(na_range)) {
    if (!is.numeric(x)) {
      stop("`na_range` is only applicable for labelled numeric vectors.",
        call. = FALSE
      )
    }
    if (!is.numeric(na_range) || length(na_range) != 2) {
      stop("`na_range` must be a numeric vector of length two.",
        call. = FALSE
      )
    }
  }

  if (is.null(label)) {
    # haven no longer allows NULL labels
    label <- ""
  }

  tmp <- haven::labelled_spss(vctrs::vec_data(x),
    labels = labels,
    label = label,
    na_values = na_values,
    na_range = na_range
  )

  original_coding <- sort(unique(x))
  names(original_coding) <- original_coding

  attr(tmp, "class") <- c(
    "retroharmonize_labelled_spss_survey",
    "haven_labelled_spss",
    "haven_labelled"
  )
  if (length(id) == 1) {
    attr(tmp, paste0(id, "_name")) <- name_orig
    attr(tmp, paste0(id, "_values")) <- original_coding
    attr(tmp, paste0(id, "_label")) <- label
    attr(tmp, paste0(id, "_labels")) <- attr(tmp, "labels")
    attr(tmp, paste0(id, "_na_values")) <- attr(tmp, "na_values")
    attr(tmp, paste0(id, "_na_range")) <- attr(tmp, "na_range")
  } else {
    id <- paste(id, collapse = ", ")
  }

  attr(tmp, "id") <- id

  tmp
}

## Subsetting -------------------------------------------------

#' @rdname labelled_spss_survey
#' @export
`[.retroharmonize_labelled_spss_survey` <- function(x, i, ...) {
  preserve_structure <- attributes(x)
  x <- vctrs::vec_data(x)[i]
  attributes(x) <- preserve_structure
  x
}

## Displaying methods -----------------------------------------
#' @keywords internal
get_labeltext <- function(x, prefix = ": ") {
  label <- attr(x, "label", exact = TRUE)
  if (!is.null(label)) {
    paste0(prefix, label)
  }
}

#' @rdname labelled_spss_survey
#' @param object A labelled_spss_survey to summarize.
#' @export
summary.retroharmonize_labelled_spss_survey <- function(object, ...) {
  if (!is.null(attr(object, "label"))) {
    cat(attr(object, "label"))
  }
  cat("\nNumeric values without coding:\n")
  print(summary(vctrs::vec_data(object), ...))
  cat("Numeric representation:\n")
  print(summary(as_numeric(object)))
  cat("Factor representation:\n")
  summary(as_factor(object))
}

#' @rdname labelled_spss_survey
#' @param value Replacement values used when assigning names.
#' @export
"names<-.retroharmonize_labelled_spss_survey" <- function(x, value) {
  attr(x, "names") <- value
  x
}

## Missingness ------------------------------------------------------

#' @rdname labelled_spss_survey
#' @export
is.na.retroharmonize_labelled_spss_survey <- function(x) {
  miss <- NextMethod()
  val <- vctrs::vec_data(x)

  na_values <- attr(x, "na_values")
  if (!is.null(na_values)) {
    miss <- miss | val %in% na_values
  }

  na_range <- attr(x, "na_range")
  if (!is.null(na_range)) {
    miss <- miss | (val >= na_range[1] & val <= na_range[2])
  }

  miss
}

#' @rdname labelled_spss_survey
#' @exportS3Method
levels.retroharmonize_labelled_spss_survey <- function(x) {
  NULL
}

#' @rdname labelled_spss_survey
#' @importFrom haven format_tagged_na
#' @param digits Number of digits to use in string representation in
#' the format method.
#' @export
format.retroharmonize_labelled_spss_survey <- function(
  x,
  ...,
  digits = getOption("digits")
) {
  if (is.double(x)) {
    haven::format_tagged_na(x, digits = digits)
  } else {
    format(vctrs::vec_data(x), ...)
  }
}

# Type system -------------------------------------------------------------

#' @rdname labelled_spss_survey
#' @export
is.labelled_spss_survey <- function(x) {
  inherits(x, "retroharmonize_labelled_spss_survey")
}
