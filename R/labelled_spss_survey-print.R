## Displaying methods -----------------------------------------
#' @keywords internal
get_labeltext <- function(x, prefix = ": ") {
  label <- attr(x, "label", exact = TRUE)
  if (!is.null(label)) {
    paste0(prefix, label)
  }
}

#' @keywords internal
print_attributes <- function(x, full = TRUE) {
  na_values <- attr(x, "na_values")
  if (!is.null(na_values)) {
    cli::cat_line("Missing values: ", paste(na_values, collapse = ", "))
  }
  na_range <- attr(x, "na_range")
  if (!is.null(na_range)) {
    cli::cat_line("Missing range:  [", paste(na_range, collapse = ", "), "]")
  }

  if (full == FALSE) invisible(x)
  ## full printing goes on below ---------------------

  history_attributes <- names(attributes(x))
  history_attributes <- history_attributes[
    !history_attributes %in% c(
      "label", "labels",
      "na_values", "na_range", "class", "id"
    )
  ]

  if (length(history_attributes) > 0) {
    last_attribute <- history_attributes[length(history_attributes)]
    history_attributes <- c(history_attributes[1:3], "...", last_attribute)
    history_attributes <- paste(history_attributes, collapse = ", ")
    history_attributes <- gsub("\\,\\s\\.\\.\\.", " [...]", history_attributes)
  }

  cli::cat_line(paste0(
    "See all attributes ",
    history_attributes,
    " with attributes(",
    deparse(substitute(x)),
    ")"
  ))
}


#' @export
#' @importFrom cli cat_line
obj_print_header.retroharmonize_labelled_spss_survey <- function(x, ...) {
  cli::cat_line(
    "<",
    vec_ptype_full(x),
    "[",
    vctrs::vec_size(x),
    "]>", get_labeltext(x)
  )
  invisible(x)
}

#' @export
obj_print_footer.retroharmonize_labelled_spss_survey <- function(x, ...) {
  print_attributes(x)
  invisible(x)
}


#' @rdname labelled_spss_survey
#' @importFrom cli cat_line
#' @importFrom utils head
#' @export
print.retroharmonize_labelled_spss_survey <- function(x, ...) {
  cli::cat_line(
    "<", vec_ptype_full(x),
    "[", vec_size(x), "]>", get_labeltext(x)
  )
  cat(head(vctrs::vec_data(x), 20))
  cat("\n")
  print_attributes(x)
  invisible(x)
}


#' @export
vec_ptype_full.retroharmonize_labelled_spss_survey <- function(x, ...) {
  paste0(
    "labelled_spss_survey<",
    vctrs::vec_ptype_full(vctrs::vec_data(x)),
    ">"
  )
}


#' @export
vec_ptype_abbr.retroharmonize_labelled_spss_survey <- function(x, ...) {
  if (vctrs::vec_ptype_full(vctrs::vec_data(x)) == "character") {
    "retroh_chr"
  } else if (vec_ptype_full(vctrs::vec_data(x)) == "integer") {
    "retroh_int"
  } else if (vec_ptype_full(vctrs::vec_data(x)) == "double") {
    "retroh_dbl"
  } else {
    "retroh"
  }
}
