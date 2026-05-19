# Read a survey from an \`.rds\` file

Import a serialized survey object stored in \`.rds\` format and return
it as a \`survey\` object with harmonized metadata attributes.

## Usage

``` r
read_rds(file, dataset_bibentry = NULL, id = NULL, doi = NULL)
```

## Arguments

- file:

  Path to an \`.rds\` file containing a survey object.

- dataset_bibentry:

  Optional bibliographic metadata created with \[dataset::dublincore()\]
  or \[dataset::datacite()\].

- id:

  Optional survey identifier. Defaults to the file name without
  extension.

- doi:

  Optional DOI identifier for the survey.

## Value

A \`survey\` object inheriting from \`data.frame\` and \`tbl_df\` with
survey metadata attributes.

## Details

This function restores survey objects previously saved with
\[base::saveRDS()\] or exported from the \`retroharmonize\` workflow.
The returned object retains survey metadata and gains additional
provenance attributes such as source file name and file size.

If the file cannot be read, an empty \`survey\` object is returned and a
warning is emitted.

The function:

\- restores the serialized object, - validates source file
information, - normalizes \`rowid\`, - records provenance metadata, -
and stores object and source file sizes as attributes.

## See also

Other import functions:
[`harmonize_survey_variables()`](https://ropengov.github.io/retroharmonize/reference/harmonize_survey_variables.md),
[`pull_survey()`](https://ropengov.github.io/retroharmonize/reference/pull_survey.md),
[`read_csv()`](https://ropengov.github.io/retroharmonize/reference/read_csv.md),
[`read_dta()`](https://ropengov.github.io/retroharmonize/reference/read_dta.md),
[`read_spss()`](https://ropengov.github.io/retroharmonize/reference/read_spss.md),
[`read_surveys()`](https://ropengov.github.io/retroharmonize/reference/read_surveys.md)

## Examples

``` r
path <- system.file(
  "examples",
  "ZA7576.rds",
  package = "retroharmonize"
)

survey_object <- read_rds(path)

attr(survey_object, "id")
#> [1] "ZA7576"
attr(survey_object, "filename")
#> [1] "ZA7576.rds"
attr(survey_object, "doi")
#> [1] "doi:10.4232/1.13393"
```
