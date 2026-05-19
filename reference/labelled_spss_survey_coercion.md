# Coercion methods for labelled survey vectors

Convert labelled SPSS-style survey vectors to common R data types. These
helpers provide consistent coercion behavior for
\`"retroharmonize_labelled_spss_survey"\` objects while respecting
labelled missing values.

## Usage

``` r
as_numeric(x)

as_character(x)

as_factor(x, levels = "default", ordered = FALSE)
```

## Arguments

- x:

  A labelled survey vector created with \[labelled_spss_survey()\].

- levels:

  Character string indicating how factor levels should be constructed.
  Currently retained for compatibility.

- ordered:

  Logical; whether the resulting factor should be ordered. Currently
  ignored.

## Value

\* \`as_numeric()\` returns a numeric vector with labelled missing
values converted to \`NA\`. \* \`as_character()\` returns a character
vector based on the factor representation of \`x\`. \* \`as_factor()\`
returns a factor with levels derived from value labels.

## See also

\[labelled_spss_survey()\], \[haven::as_factor()\]

Other type conversion functions:
[`as_labelled_spss_survey()`](https://ropengov.github.io/retroharmonize/reference/as_labelled_spss_survey.md)
