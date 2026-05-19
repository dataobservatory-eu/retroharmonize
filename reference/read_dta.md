# Read a Stata \`.dta\` survey file

Import a survey dataset stored in Stata \`.dta\` format and convert it
into a \`survey\` object with harmonized metadata and labelled
variables.

## Usage

``` r
read_dta(file, id = NULL, doi = NULL, .name_repair = "unique")
```

## Arguments

- file:

  Path to a Stata \`.dta\` file.

- id:

  Optional survey identifier. Defaults to the file name without
  extension.

- doi:

  Optional DOI identifier for the survey.

- .name_repair:

  Strategy for repairing invalid or duplicated column names. Passed to
  \[haven::read_dta()\].

## Value

A \`survey\` object inheriting from \`data.frame\` and \`tbl_df\`.

## Details

This function wraps \[haven::read_dta()\] and adds:

\- error handling, - survey metadata creation, - \`rowid\`
normalization, - preservation of variable labels, - conversion of
labelled variables, - and provenance metadata.

Variable labels are preserved using the \`"label"\` attribute.

Labelled variables are converted to harmonized labelled survey vectors
where possible. Variables that inherit from \`haven_labelled\` but do
not contain valid label definitions are converted back to standard
vectors.

If the file cannot be read, the function returns an empty \`survey\`
object and emits a warning.

## See also

Other import functions:
[`harmonize_survey_variables()`](https://ropengov.github.io/retroharmonize/reference/harmonize_survey_variables.md),
[`pull_survey()`](https://ropengov.github.io/retroharmonize/reference/pull_survey.md),
[`read_csv()`](https://ropengov.github.io/retroharmonize/reference/read_csv.md),
[`read_rds()`](https://ropengov.github.io/retroharmonize/reference/read_rds.md),
[`read_spss()`](https://ropengov.github.io/retroharmonize/reference/read_spss.md),
[`read_surveys()`](https://ropengov.github.io/retroharmonize/reference/read_surveys.md)

## Examples

``` r
# \donttest{
path <- system.file(
  "examples",
  "iris.dta",
  package = "haven"
)

survey_object <- read_dta(path)

attr(survey_object, "id")
#> [1] "iris"
attr(survey_object, "filename")
#> [1] "iris.dta"
# }
```
