# Read SPSS survey files

Import SPSS survey files in \`.sav\`, \`.zsav\`, or \`.por\` format and
convert them into harmonized \`survey\` objects with preserved metadata,
labelled variables, and provenance information.

## Usage

``` r
read_spss(
  file,
  user_na = TRUE,
  dataset_bibentry = NULL,
  id = NULL,
  doi = NULL,
  .name_repair = "unique"
)
```

## Arguments

- file:

  Path to an SPSS survey file.

- user_na:

  Logical. Should user-defined missing values be imported? Defaults to
  \`TRUE\`.

- dataset_bibentry:

  Optional bibliographic metadata created with \[dataset::dublincore()\]
  or \[dataset::datacite()\].

- id:

  Optional survey identifier. Defaults to the file name without
  extension.

- doi:

  Optional DOI identifier.

- .name_repair:

  Strategy for repairing invalid or duplicated column names. Passed to
  \[haven::read_spss()\].

## Value

A \`survey\` object inheriting from \`data.frame\` and \`tbl_df\`.

Variable labels are stored in the \`"label"\` attribute of each
variable.

Additional provenance metadata are stored as attributes, including:

\- \`"id"\` - \`"doi"\` - \`"object_size"\` - \`"source_file_size"\`

## Details

This function wraps \[haven::read_spss()\] and adds:

\- error handling, - harmonized survey metadata, - \`rowid\` creation
and normalization, - preservation of variable labels, - conversion of
labelled SPSS vectors, - handling of malformed labelled variables, - and
provenance metadata.

\`read_sav()\` reads both \`.sav\` and \`.zsav\` files. \`read_por()\`
reads portable SPSS \`.por\` files. \`read_spss()\` automatically
dispatches to the appropriate importer based on file extension.

Variables that inherit from \`haven_labelled\` but do not contain valid
label definitions are converted to standard numeric or character
vectors.

If a file cannot be imported, the function returns an empty \`survey\`
object and emits a warning.

## See also

Other import functions:
[`harmonize_survey_variables()`](https://ropengov.github.io/retroharmonize/reference/harmonize_survey_variables.md),
[`pull_survey()`](https://ropengov.github.io/retroharmonize/reference/pull_survey.md),
[`read_csv()`](https://ropengov.github.io/retroharmonize/reference/read_csv.md),
[`read_dta()`](https://ropengov.github.io/retroharmonize/reference/read_dta.md),
[`read_rds()`](https://ropengov.github.io/retroharmonize/reference/read_rds.md),
[`read_surveys()`](https://ropengov.github.io/retroharmonize/reference/read_surveys.md)

## Examples

``` r
# \donttest{
path <- system.file(
  "examples",
  "iris.sav",
  package = "haven"
)

survey_object <- read_spss(path)

attr(survey_object, "id")
#> [1] "iris"
attr(survey_object, "filename")
#> [1] "iris.sav"
# }
```
