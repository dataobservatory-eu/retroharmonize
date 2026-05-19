# Labelled SPSS-style vectors with survey provenance

Create a labelled vector compatible with \[haven::labelled_spss()\] that
carries additional survey-level provenance metadata.

## Usage

``` r
labelled_spss_survey(
  x = double(),
  labels = NULL,
  na_values = NULL,
  na_range = NULL,
  label = NULL,
  id = NULL,
  name_orig = NULL
)

# S3 method for class 'retroharmonize_labelled_spss_survey'
x[i, ...]

# S3 method for class 'retroharmonize_labelled_spss_survey'
x[i, ...]

# S3 method for class 'retroharmonize_labelled_spss_survey'
print(x, ...)

# S3 method for class 'retroharmonize_labelled_spss_survey'
summary(object, ...)

# S3 method for class 'retroharmonize_labelled_spss_survey'
is.na(x)

# S3 method for class 'retroharmonize_labelled_spss_survey'
levels(x)

# S3 method for class 'retroharmonize_labelled_spss_survey'
names(x) <- value

# S3 method for class 'retroharmonize_labelled_spss_survey'
format(x, ..., digits = getOption("digits"))

is.labelled_spss_survey(x)

# S3 method for class 'retroharmonize_labelled_spss_survey'
print(x, ...)

# S3 method for class 'retroharmonize_labelled_spss_survey'
summary(object, ...)

# S3 method for class 'retroharmonize_labelled_spss_survey'
is.na(x)

# S3 method for class 'retroharmonize_labelled_spss_survey'
levels(x)

# S3 method for class 'retroharmonize_labelled_spss_survey'
names(x) <- value

# S3 method for class 'retroharmonize_labelled_spss_survey'
format(x, ..., digits = getOption("digits"))

is.labelled_spss_survey(x)

# S3 method for class 'retroharmonize_labelled_spss_survey'
median(x, na.rm = TRUE, ...)

# S3 method for class 'retroharmonize_labelled_spss_survey'
quantile(x, probs, ...)

# S3 method for class 'retroharmonize_labelled_spss_survey'
weighted.mean(x, w, ...)

# S3 method for class 'retroharmonize_labelled_spss_survey'
mean(x, ...)

# S3 method for class 'retroharmonize_labelled_spss_survey'
sum(x, ...)
```

## Arguments

- x:

  A vector of values.

- labels:

  A named vector of value labels.

- na_values:

  A vector of values to be treated as missing.

- na_range:

  A numeric range defining missing values.

- label:

  A variable label.

- id:

  A character scalar identifying the survey.

- name_orig:

  Original variable name. Defaults to the name of \`x\`.

- i:

  Index vector used for subsetting.

- ...:

  potentially further arguments for methods; not used in the default
  method.

- object:

  A labelled_spss_survey to summarize.

- value:

  Replacement values used when assigning names.

- digits:

  Number of digits to use in string representation in the format method.

- na.rm:

  a logical value indicating whether `NA` values should be stripped
  before the computation proceeds.

- probs:

  numeric vector of probabilities with values in \\\[0,1\]\\. (Values up
  to `2e-14` outside that range are accepted and moved to the nearby
  endpoint.)

- w:

  a numerical vector of weights the same length as `x` giving the
  weights to use for elements of `x`.

## Value

An object of class \`"retroharmonize_labelled_spss_survey"\`, extending
\[haven::labelled_spss()\].

## Details

The resulting object behaves like a \`haven_labelled_spss\` vector, but
stores:

- a survey identifier

- the original variable name

- the original value coding

Several arithmetic (statistical summary) methods operate on the numeric
representation of labelled survey vectors, converting SPSS-style missing
values to \`NA\` before computation.

You can coerce labelled_spss_survey vectors to numeric, character or
factor representation.

## See also

\[haven::labelled_spss()\], \[as_factor()\], \[as_numeric()\],
\[as_character()\]

## Examples

``` r
x <- labelled_spss_survey(
  x = c(1, 2, 9),
  labels = c(Yes = 1, No = 2),
  na_values = 9,
  id = "survey_1"
)

is.na(x)
#> [1] FALSE FALSE  TRUE
as_factor(x)
#> [1] Yes No  9  
#> attr(,"label")
#> [1] 
#> Levels: Yes No 9
```
