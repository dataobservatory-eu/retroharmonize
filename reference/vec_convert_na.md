# Convert labelled missing values to NA

Internal helper used by numeric summary methods to replace SPSS-style
missing values with \`NA\`.

## Usage

``` r
vec_convert_na(x)
```

## Arguments

- x:

  A labelled survey vector.

## Value

A numeric vector with missing values converted to \`NA\`.
