# Read a survey from a CSV file

Import a survey stored in a CSV file and return it as a survey object
with attached dataset- and survey-level metadata.

## Usage

``` r
harmonize_survey_variables(
  crosswalk_table,
  subset_name = "subset",
  survey_list = NULL,
  survey_paths = NULL,
  import_path = NULL,
  export_path = NULL
)
```

## Arguments

- crosswalk_table:

  A crosswalk table created with \[crosswalk_table_create()\].

- subset_name:

  Character string appended to filenames of subsetted surveys. Defaults
  to \`"subset"\`.

- survey_list:

  A list containing surveys of class survey.

- survey_paths:

  Optional character vector of file paths to surveys.

- import_path:

  Optional base directory used to resolve \`survey_paths\`.

- export_path:

  Optional directory where subsetted surveys are exported to

## Value

An object of class \`"survey"\`, which is a data frame with attached
survey- and dataset-level metadata.

## Details

The CSV file is read using \[utils::read.csv()\]. Character variables
with more than one unique value are automatically converted to labelled
factors. A unique row identifier is added and labelled.

If the file cannot be read, an empty survey object is returned with a
warning.

If a column named \`"X"\` is present (commonly created by
\`write.csv()\`), it is removed automatically.

## See also

\[read_rds()\] for importing surveys from RDS files, \[survey_df()\] for
constructing survey objects manually.

Other import functions:
[`pull_survey()`](https://ropengov.github.io/retroharmonize/reference/pull_survey.md),
[`read_csv()`](https://ropengov.github.io/retroharmonize/reference/read_csv.md),
[`read_dta()`](https://ropengov.github.io/retroharmonize/reference/read_dta.md),
[`read_rds()`](https://ropengov.github.io/retroharmonize/reference/read_rds.md),
[`read_spss()`](https://ropengov.github.io/retroharmonize/reference/read_spss.md),
[`read_surveys()`](https://ropengov.github.io/retroharmonize/reference/read_surveys.md)

## Examples

``` r
# Create a temporary CSV file from an example survey
path <- system.file("examples", "ZA7576.rds",
  package = "retroharmonize"
)
survey <- read_rds(path)

tmp <- tempfile(fileext = ".csv")
write.csv(survey, tmp, row.names = FALSE)

# Read the CSV file back as a survey
re_read <- read_csv(
  file = tmp,
  id = "ZA7576",
  doi = "10.0000/example"
)
```
