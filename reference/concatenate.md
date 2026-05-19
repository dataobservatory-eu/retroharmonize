# Concatenate haven_labelled_spss vectors

Concatenate haven_labelled_spss vectors

## Usage

``` r
concatenate(x, y)
```

## Arguments

- x:

  A haven_labelled_spss vector.

- y:

  A haven_labelled_spss vector.

## Value

A concatenated haven_labelled_spss vector. Returns an error if the
attributes do not match. Gives a warning when only the variable label do
not match.

## Examples

``` r
v1 <- labelled::labelled(
  c(3, 4, 4, 3, 8, 9),
  c(YES = 3, NO = 4, `WRONG LABEL` = 8, REFUSED = 9)
)
v2 <- labelled::labelled(
  c(4, 3, 3, 9),
  c(YES = 3, NO = 4, `WRONG LABEL` = 8, REFUSED = 9)
)
s1 <- haven::labelled_spss(
  x = unclass(v1), # remove labels from earlier defined
  labels = labelled::val_labels(v1), # use the labels from earlier defined
  na_values = NULL,
  na_range = 8:9,
  label = "Variable Example"
)

s2 <- haven::labelled_spss(
  x = unclass(v2), # remove labels from earlier defined
  labels = labelled::val_labels(v2), # use the labels from earlier defined
  na_values = NULL,
  na_range = 8:9,
  label = "Variable Example"
)
concatenate(s1, s2)
#> <labelled_spss<double>[10]>: Variable Example
#>  [1] 3 4 4 3 8 9 4 3 3 9
#> Missing range:  [8, 9]
#> 
#> Labels:
#>  value       label
#>      3         YES
#>      4          NO
#>      8 WRONG LABEL
#>      9     REFUSED
```
