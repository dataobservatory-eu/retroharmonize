# Normalize value and variable labels

`label_normalize` removes special characters, whitespace, and other
typical typing errors.

## Usage

``` r
label_normalize(x)

var_label_normalize(x)

val_label_normalize(x)
```

## Arguments

- x:

  A character vector of labels to be normalized.

## Value

Returns a suggested, normalized label without special characters. The
`var_label_normalize` and `val_label_normalize` returns them in
`snake_case` for programmatic use.

## Details

`var_label_normalize` and `val_label_normalize` removes possible chunks
from question identifiers.

The functions `var_label_normalize` and `val_label_normalize` may be
differently implemented for various survey series.

## See also

Other variable label harmonization functions:
[`na_range_to_values()`](https://ropengov.github.io/retroharmonize/reference/na_range_to_values.md)

Other harmonization functions:
[`collect_val_labels()`](https://ropengov.github.io/retroharmonize/reference/collect_val_labels.md),
[`crosswalk_surveys()`](https://ropengov.github.io/retroharmonize/reference/crosswalk_surveys.md),
[`harmonize_na_values()`](https://ropengov.github.io/retroharmonize/reference/harmonize_na_values.md),
[`harmonize_survey_values()`](https://ropengov.github.io/retroharmonize/reference/harmonize_survey_values.md),
[`harmonize_values()`](https://ropengov.github.io/retroharmonize/reference/harmonize_values.md),
[`harmonize_var_names()`](https://ropengov.github.io/retroharmonize/reference/harmonize_var_names.md),
[`is.crosswalk_table()`](https://ropengov.github.io/retroharmonize/reference/crosswalk_table_create.md)

## Examples

``` r
label_normalize(
  c(
    "Don't know", " TRUST", "DO NOT  TRUST",
    "inap in Q.3", "Not 100%", "TRUST < 50%",
    "TRUST >=90%", "Verify & Check", "TRUST 99%+"
  )
)
#> [1] "do not know"       "trust"             "do not trust"     
#> [4] "inap in q 3"       "not 100 pct"       "trust lt 50 pct"  
#> [7] "trust ge 90 pct"   "verify and check"  "trust 99 pct plus"

var_label_normalize(
  c(
    "Q1_Do you trust the national government?",
    " Do you trust the European Commission"
  )
)
#> [1] "do_you_trust_the_national_government"
#> [2] "do_you_trust_the_european_commission"

val_label_normalize(
  c(
    "Q1_Do you trust the national government?",
    " Do you trust the European Commission"
  )
)
#> [1] "do_you_trust_the_national_government"
#> [2] "do_you_trust_the_european_commission"
```
