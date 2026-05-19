# Crosswalk and harmonize surveys

Harmonize one or more surveys using a crosswalk table that defines how
variable names, value labels, numeric codes, and variable classes should
be aligned across surveys.

## Usage

``` r
crosswalk_surveys(
  crosswalk_table,
  survey_list = NULL,
  survey_paths = NULL,
  import_path = NULL,
  na_values = NULL
)

crosswalk(survey_list, crosswalk_table, na_values = NULL)
```

## Arguments

- crosswalk_table:

  A crosswalk table created with \[crosswalk_table_create()\] or a data
  frame containing at least the columns \`id\`, \`var_name_orig\`, and
  \`var_name_target\`.

  If the columns \`val_label_orig\` and \`val_label_target\` are
  present, value labels are harmonized. If \`val_numeric_orig\` and
  \`val_numeric_target\` are present, numeric codes are harmonized. If
  \`class_target\` is present, variables are coerced to the specified
  target class (\`"factor"\`, \`"numeric"\`, or \`"character"\`) using
  \[as_factor()\], \[as_numeric()\], or \[as_character()\].

- survey_list:

  A list of survey objects to be harmonized.

- survey_paths:

  Optional character vector of file paths to surveys. Used when surveys
  must be read from disk before harmonization.

- import_path:

  Optional base directory used to resolve \`survey_paths\`. This is
  primarily intended for workflows where surveys are stored outside the
  current working directory.

- na_values:

  Optional named vector defining numeric codes to be treated as missing
  values. Names correspond to missing-value labels.

## Value

\`crosswalk_surveys()\` returns a list of harmonized survey data frames.
\`crosswalk()\` returns either a single data frame (if only one survey
is harmonized) or a merged data frame combining all harmonized surveys.

## Details

A crosswalk table can be created with \[crosswalk_table_create()\] or
supplied manually as a data frame. At a minimum, the table must contain
columns \`id\`, \`var_name_orig\`, and \`var_name_target\`. Additional
columns enable harmonization of value labels, numeric codes, missing
values, and variable classes.

## See also

\[crosswalk_table_create()\] to create a crosswalk table,
\[harmonize_survey_variables()\] for lower-level variable harmonization.

Other harmonization functions:
[`collect_val_labels()`](https://ropengov.github.io/retroharmonize/reference/collect_val_labels.md),
[`harmonize_na_values()`](https://ropengov.github.io/retroharmonize/reference/harmonize_na_values.md),
[`harmonize_survey_values()`](https://ropengov.github.io/retroharmonize/reference/harmonize_survey_values.md),
[`harmonize_values()`](https://ropengov.github.io/retroharmonize/reference/harmonize_values.md),
[`harmonize_var_names()`](https://ropengov.github.io/retroharmonize/reference/harmonize_var_names.md),
[`is.crosswalk_table()`](https://ropengov.github.io/retroharmonize/reference/crosswalk_table_create.md),
[`label_normalize()`](https://ropengov.github.io/retroharmonize/reference/label_normalize.md)

## Examples

``` r
if (FALSE) { # \dontrun{
examples_dir <- system.file("examples", package = "retroharmonize")
survey_files <- dir(examples_dir, pattern = "\\.rds$")

surveys <- read_surveys(
  file.path(examples_dir, survey_files),
  save_to_rds = FALSE
)

metadata <- metadata_create(survey_list = surveys)

crosswalk_table <- crosswalk_table_create(metadata)

harmonized <- crosswalk_surveys(
  crosswalk_table = crosswalk_table,
  survey_list = surveys
)
} # }
```
