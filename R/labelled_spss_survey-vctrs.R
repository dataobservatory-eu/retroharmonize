#' vctrs type and casting methods for labelled survey vectors
#'
#' These methods define how
#' \code{retroharmonize_labelled_spss_survey} objects interact with
#' base vectors and with each other in vctrs-based operations such as
#' concatenation, binding, and coercion.
#'
#' They ensure that labelled survey vectors:
#' \itemize{
#'   \item combine safely with numeric vectors,
#'   \item cast consistently to base types,
#'   \item error on incompatible coercions.
#' }
#'
#' These functions are part of the internal type system and are not
#' intended to be called directly by users.
#'
#' @name labelled_spss_survey_vctrs
#' @keywords internal
NULL


#' @keywords internal
vec_cast_named <- function(x, to, ...) {
  # identical to haven:::vec_cast_named()
  stats::setNames(vctrs::vec_cast(x, to, ...), names(x))
}

#' @rdname labelled_spss_survey_vctrs
#' @export
vec_ptype2.retroharmonize_labelled_spss_survey.double <- function(x,
                                                                  y,
                                                                  ...) {
  double()
}

#' @rdname labelled_spss_survey_vctrs
#' @export
vec_ptype2.double.retroharmonize_labelled_spss_survey <- function(x,
                                                                  y,
                                                                  ...) {
  double()
}

#' @rdname labelled_spss_survey_vctrs
#' @export
vec_ptype2.integer.retroharmonize_labelled_spss_survey <- function(x,
                                                                   y,
                                                                   ...) {
  double()
}

#' @rdname labelled_spss_survey_vctrs
#' @export
vec_ptype2.retroharmonize_labelled_spss_survey.integer <- function(x,
                                                                   y,
                                                                   ...) {
  double()
}


#' @rdname labelled_spss_survey_vctrs
#' @export
vec_cast.double.retroharmonize_labelled_spss_survey <- function(x,
                                                                to,
                                                                ...) {
  vctrs::vec_cast(vctrs::vec_data(x), to)
}

#' @rdname labelled_spss_survey_vctrs
#' @export
vec_cast.integer.retroharmonize_labelled_spss_survey <- function(x,
                                                                 to,
                                                                 ...) {
  vctrs::vec_cast(vctrs::vec_data(x), to)
}

#' @rdname labelled_spss_survey_vctrs
#' @export
vec_cast.character.retroharmonize_labelled_spss_survey <- function(
    x,
    to,
    ...
) {
  if (is.character(x)) {
    vctrs::vec_cast(vctrs::vec_data(x), to, ...)
  } else {
    stop_incompatible_cast(x, to, ...)
  }
}


## Prototype --------------------------------------
#' @rdname labelled_spss_survey_vctrs
#' @export
vec_ptype2.retroharmonize_labelled_spss_survey.retroharmonize_labelled_spss_survey <- function(
    x,
    y,
    ...,
    x_arg = "",
    y_arg = ""
) {
   data_type <- vec_ptype2(vec_data(x),
                          vctrs::vec_data(y),
                          x_arg = x_arg,
                          y_arg = y_arg
  )
  
  x_labels <- labelled::val_labels(x)
  y_labels <- labelled::val_labels(y)
  
  dots <- list2(...)
  
  if (is.null(dots)) {
    dots <- list(orig_name = "")
    
    same_in <- paste0(
      attr(x, "id"), " and ",
      attr(y, "id"), "."
    )
  } else {
    same_in <- paste0(
      attr(x, "id"), "$", dots$orig_name, " and ",
      attr(y, "id"), "$", dots$orig_name
    )
  }
  
  if (length(x_labels) == 0 || length(y_labels) == 0) {
    stop_incompatible_type(
      x, y,
      x_arg = dots$orig_name,
      y_arg = paste(names(y_labels), collapse = ", "),
      details = paste0(
        "Must be labelled in ", dots$orig_name
      )
    )
  }
  
  if (!setequal(x_labels, y_labels)) {
    stop_incompatible_type(
      x, y,
      x_arg = paste(names(x_labels), collapse = ", "),
      y_arg = paste(names(y_labels), collapse = ", "),
      details = paste0(
        "The labelled numeric values must be the same in ", same_in
      )
    )
  }
  
  
  if (!setequal(names(x_labels), names(y_labels))) {
    stop_incompatible_type(
      x, y,
      x_arg = paste(names(x_labels), collapse = ", "),
      y_arg = paste(names(y_labels), collapse = ", "),
      details = paste0(
        "The labels must be the same in ", same_in
      )
    )
  }
  
  if (!setequal(attr(x, "na_values"), attr(y, "na_values"))) {
    stop_incompatible_type(
      x, y,
      x_arg = paste(names(attr(x, "na_values")), collapse = ", "),
      y_arg = paste(names(attr(y, "na_values")), collapse = ", "),
      message = paste0(
        "The na_values attributes are not the same in ",
        same_in
      )
    )
  }
  
  if (!setequal(attr(x, "na_range"), attr(y, "na_range"))) {
    stop_incompatible_type(
      x, y,
      x_arg = paste(names(attr(x, "na_range")), collapse = ", "),
      y_arg = paste(names(attr(y, "na_range")), collapse = ", "),
      message = paste0(
        "The na_range attributes are not the same in ", same_in
      )
    )
  }
  
  x_labels <- vec_cast_named(attr(x, "labels"), data_type, x_arg = x_arg)
  y_labels <- vec_cast_named(attr(y, "labels"), data_type, x_arg = y_arg)
  
  x_label <- attr(x, "label")
  y_label <- attr(y, "label")
  
  x_id <- attr(x, "id")
  y_id <- attr(y, "id")
  
  x_attr_names <- names(attributes(x))
  y_attr_names <- names(attributes(y))
  
  x_orig_attr <- x_attr_names[which(x_attr_names == paste0(x_id, "_name"))]
  y_orig_attr <- y_attr_names[which(y_attr_names == paste0(y_id, "_name"))]
  
  x_orig_name <- as.character(attr(x, x_orig_attr[1]))
  y_orig_name <- as.character(attr(y, y_orig_attr[1]))
  
  name_orig <- paste(vec_c(x_orig_name, y_orig_name), collapse = ", ")
  
  x_na_values <- attr(x, "na_values")
  y_na_values <- attr(y, "na_values")
  
  x_na_range <- attr(x, "na_range")
  y_na_range <- attr(y, "na_range")
  
  label <- x_label
  
  if (!identical(x_label, y_label)) {
    # strip labels if not compatible
    if (is.null(x_label)) {
      label <- y_label
    }
  }
  
  id <- "multi-wave"
  
  s1 <- attributes(x)
  s2 <- attributes(y)
  
  c_vector <- new_labelled_spss_survey(
    x = vec_c(vctrs::vec_data(x), vctrs::vec_data(y)),
    labels = x_labels,
    label = label,
    id = id,
    na_values = x_na_values,
    na_range = x_na_range,
    name_orig = name_orig
  )
  
  for (x_attr in setdiff(names(s1), names(s2))) {
    # Copy the history of x to the new vector
    attr(c_vector, x_attr) <- attr(x, x_attr)
  }
  
  for (y_attr in setdiff(names(s2), names(s1))) {
    # Copy the history of y to the new vector
    attr(c_vector, y_attr) <- attr(y, y_attr)
  }
  
  c_vector
}

#' @importFrom haven is_tagged_na
#' @export
vec_cast.retroharmonize_labelled_spss_survey.retroharmonize_labelled_spss_survey <- function(
    x,
    to, ...,
    x_arg = "", 
    to_arg = ""
) {
  out_data <- vec_cast(vctrs::vec_data(x), 
                       vctrs::vec_data(to), 
                       x_arg = x_arg, 
                       to_arg = to_arg)
  x_labels <- labelled::val_labels(x)

  x_label <- attr(x, "label")
  to_label <- attr(to, "label")
  
  x_id <- attr(x, "id")
  to_id <- attr(to, "id")
  
  x_attr_names <- names(attributes(x))
  to_attr_names <- names(attributes(to))

  x_orig_attr <- x_attr_names[which(x_attr_names == paste0(x_id, "_name"))]
  to_orig_attr <- to_attr_names[which(to_attr_names == paste0(to_id, "_name"))]
  
  x_orig_name <- as.character(attr(x, x_orig_attr[1]))
  to_orig_name <- as.character(attr(to, to_orig_attr[1]))
  
  name_orig <- paste(vec_c(x_orig_name, to_orig_name), collapse = ", ")
  
  x_na_values <- attr(x, "na_values")
  to_na_values <- attr(to, "na_values")
  
  x_na_range <- attr(x, "na_range")
  to_na_range <- attr(to, "na_range")
  
  label <- x_label
  
  if (!identical(x_label, to_label)) {
    # strip labels if not compatible
    if (is.null(x_label)) {
      label <- to_label
    }
  }
  
  id <- paste(vec_c(x_id, to_id), collapse = ", ")
  
  out <- new_labelled_spss_survey(
    out_data,
    labels = x_labels,
    label = label,
    id = id,
    na_values = x_na_values,
    na_range = x_na_range,
    name_orig = name_orig
  )
  
  # do we lose tagged na values? from haven
  if (is.double(x) && !is.double(out)) {
    lossy <- haven::is_tagged_na(x)
    maybe_lossy_cast(out, x, to, lossy,
                     x_arg = x_arg,
                     to_arg = to_arg,
                     details = "Only doubles can hold tagged na values."
    )
  }
  
  out
}
