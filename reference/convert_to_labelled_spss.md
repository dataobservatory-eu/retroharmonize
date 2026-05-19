# Convert to haven_labelled_spss

Convert to haven_labelled_spss

## Usage

``` r
convert_to_labelled_spss(x, na_labels = NULL)
```

## Arguments

- x:

  A vector

- na_labels:

  A named vector of missing values, defaults to `c( "inap" = "inap")`
  for character vectors and `c( 99999 = "inap")` for numeric vectors.

## Value

A haven_labelled_spss vector
