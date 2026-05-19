# Create a survey object

Construct a survey object from a data frame or tibble by attaching
survey-level metadata such as an identifier, source filename, and basic
dataset-level descriptive metadata.

## Usage

``` r
is.survey_df(x)

survey_df(
  x,
  title = NULL,
  creator = person("Unknown", "Creator"),
  dataset_bibentry = NULL,
  dataset_subject = NULL,
  identifier,
  filename
)

is.survey_df(x)

# S3 method for class 'survey_df'
print(x, ...)
```

## Arguments

- x:

  A data frame or tibble containing the survey data.

- title:

  Optional title for the survey. Defaults to \`"Untitled Survey"\`.

- creator:

  A \[utils::person()\] object describing the dataset creator. Defaults
  to \`person("Unknown", "Creator")\`.

- dataset_bibentry:

  Optional dataset-level bibliographic metadata. If \`NULL\`, a minimal
  DataCite entry is created automatically using \`title\`, \`creator\`,
  and \`dataset_subject\`.

- dataset_subject:

  Dataset subject metadata. If \`NULL\`, defaults to the Library of
  Congress Subject Heading
  [Surveys](https://id.loc.gov/authorities/subjects/sh85130875).

- identifier:

  A character scalar identifying the survey.

- filename:

  A character scalar giving the source filename, or \`NULL\` if unknown.

- ...:

  potentially further arguments for methods.

## Value

An object of class \`"survey_df"\`, which is a data frame with
additional survey-level metadata stored as attributes and dataset-level
metadata stored using the \`dataset\` package.

## Details

This function is primarily intended for use by import helpers such as
\[read_rds()\], \[read_spss()\], \[read_dta()\], and \[read_csv()\].
Most users will not need to call it directly.

## See also

\[read_survey()\] for importing survey data from external files.

Other importing functions:
[`survey()`](https://ropengov.github.io/retroharmonize/reference/survey.md)

## Examples

``` r
survey_df(
  x = data.frame(
    rowid = 1:6,
    observations = runif(6)
  ),
  identifier = "example",
  filename = "no_file"
)
#> Creator (2026): Untitled Survey [dataset]
#>   rowid observations filename 
#>   <int>        <dbl> <chr>   
#> 1     1        0.498 no_file 
#> 2     2        0.290 no_file 
#> 3     3        0.733 no_file 
#> 4     4        0.773 no_file 
#> 5     5        0.875 no_file 
#> 6     6        0.175 no_file  
```
