# Harmonize values in surveys

Harmonize value codes and value labels across multiple surveys and
combine them into a single data frame.

## Usage

``` r
harmonize_survey_values(survey_list, .f, status_message = FALSE)

harmonize_waves(waves, .f, status_message = FALSE)
```

## Arguments

- survey_list:

  A list of surveys (data frames). In earlier versions this argument was
  called `waves`.

- .f:

  A function applied to each labelled variable (class
  `"retroharmonize_labelled_spss_survey"`). The function must not change
  the length of the input vector.

- status_message:

  Logical. If `TRUE`, prints the identifier of each survey as it is
  processed.

- waves:

  A list of surveys. Deprecated.

## Value

A data frame containing the row-wise combination of all surveys, with
harmonized labelled variables and preserved attributes describing the
original surveys.

## Details

The function first aligns the structure of all surveys by ensuring that
they contain the same set of variables. Missing variables are added and
filled with appropriate missing values depending on their type.

Variables of class `"retroharmonize_labelled_spss_survey"` are then
harmonized by applying a user-supplied function `.f` to each variable
separately within each survey.

The harmonization function `.f` must return a vector of the same length
as its input. If `.f` returns `NULL`, the original variable is kept
unchanged.

Prior to version 0.2.0 this function was called `harmonize_waves`.

The earlier form `harmonize_waves` is deprecated. The function is
currently called `harmonize_waves`.

## See also

Other harmonization functions:
[`collect_val_labels()`](https://ropengov.github.io/retroharmonize/reference/collect_val_labels.md),
[`crosswalk_surveys()`](https://ropengov.github.io/retroharmonize/reference/crosswalk_surveys.md),
[`harmonize_na_values()`](https://ropengov.github.io/retroharmonize/reference/harmonize_na_values.md),
[`harmonize_values()`](https://ropengov.github.io/retroharmonize/reference/harmonize_values.md),
[`harmonize_var_names()`](https://ropengov.github.io/retroharmonize/reference/harmonize_var_names.md),
[`is.crosswalk_table()`](https://ropengov.github.io/retroharmonize/reference/crosswalk_table_create.md),
[`label_normalize()`](https://ropengov.github.io/retroharmonize/reference/label_normalize.md)

## Examples

``` r
# \donttest{
examples_dir <- system.file("examples", package = "retroharmonize")
survey_files <- dir(examples_dir, pattern = "\\.rds$", full.names = TRUE)

surveys <- read_surveys(
  survey_files,
  export_path = NULL
)

# Keep only supported variable types
surveys <- lapply(
  surveys,
  function(s) {
    s[, vapply(
      s,
      function(x) {
        inherits(x, c(
          "retroharmonize_labelled_spss_survey",
          "numeric",
          "character",
          "Date"
        ))
      },
      logical(1)
    )]
  }
)

# Identity harmonization (no-op)
harmonized <- harmonize_survey_values(
  survey_list = surveys,
  .f = function(x) x,
  status_message = FALSE
)

head(harmonized)
#> # A tibble: 0 × 0
# }
```
