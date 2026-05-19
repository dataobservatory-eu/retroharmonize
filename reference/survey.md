# Create a survey data frame

Store the data of a survey in a tibble (data frame) with a unique survey
identifier, import filename, and optional document object identifier.

## Usage

``` r
survey(object = data.frame(), id = "survey_id", filename = NULL, doi = NULL)

is.survey(object)

# S3 method for class 'survey'
summary(object, ...)
```

## Arguments

- object:

  A tibble or data frame that contains the survey data.

- id:

  A mandatory identifier for the survey.

- filename:

  The import file name.

- doi:

  Optional document object identifier (doi), can be omitted.

- ...:

  Arguments passed to summary method.

## Value

A tibble with `id`, `filename`, `doi` metadata information.

## Details

Whilst you can create a survey object with this helper function, it is
most likely that you will receive it with an importing function, i.e.
[`read_rds`](https://ropengov.github.io/retroharmonize/reference/read_rds.md),
[`read_spss`](https://ropengov.github.io/retroharmonize/reference/read_spss.md)
[`read_dta`](https://ropengov.github.io/retroharmonize/reference/read_dta.md),
[`read_csv`](https://ropengov.github.io/retroharmonize/reference/read_csv.md)
or their common wrapper
[`read_survey`](https://ropengov.github.io/retroharmonize/reference/read_surveys.md).

## See also

Other importing functions:
[`is.survey_df()`](https://ropengov.github.io/retroharmonize/reference/survey_df.md)

## Examples

``` r
example_survey <- survey(
  object = data.frame(
    rowid = 1:6,
    observations = runif(6)
  ),
  id = "example",
  filename = "no_file"
)
```
