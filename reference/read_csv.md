# Read a survey dataset from a CSV file

Import a survey dataset stored in comma-separated value (\`.csv\`)
format and convert it into a survey-compatible tibble with
reproducibility metadata retained as attributes.

## Usage

``` r
read_csv(file, id = NULL, doi = NULL, dataset_bibentry = NULL, ...)
```

## Arguments

- file:

  Path to a \`.csv\` file.

- id:

  Optional dataset identifier. When omitted, the file name without
  extension is used.

- doi:

  Optional dataset DOI identifier.

- dataset_bibentry:

  Optional bibliographic metadata created with \[dataset::dublincore()\]
  or \[dataset::datacite()\].

- ...:

  Additional arguments passed to \[utils::read.csv()\].

## Value

A tibble-like survey object with metadata attributes retained for
reproducible workflows.

## Details

The imported object is returned as a tibble with additional survey
metadata such as identifiers, DOI references, and optional dataset
bibliographic metadata.

## See also

Other import functions:
[`harmonize_survey_variables()`](https://ropengov.github.io/retroharmonize/reference/harmonize_survey_variables.md),
[`pull_survey()`](https://ropengov.github.io/retroharmonize/reference/pull_survey.md),
[`read_dta()`](https://ropengov.github.io/retroharmonize/reference/read_dta.md),
[`read_rds()`](https://ropengov.github.io/retroharmonize/reference/read_rds.md),
[`read_spss()`](https://ropengov.github.io/retroharmonize/reference/read_spss.md),
[`read_surveys()`](https://ropengov.github.io/retroharmonize/reference/read_surveys.md)

## Examples

``` r
# Create a temporary CSV file:
path <- system.file(
  "examples",
  "ZA7576.rds",
  package = "retroharmonize"
)

read_survey <- read_rds(path)

test_csv_file <- tempfile(fileext = ".csv")

write.csv(
  x = read_survey,
  file = test_csv_file,
  row.names = FALSE
)

# Read the CSV file:
re_read <- read_csv(
  file = test_csv_file,
  id = "ZA7576",
  doi = "test_doi"
)
```
