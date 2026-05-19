# Harmonize the values and labels of labelled vectors

Create a labelled vector with harmonized numeric coding and value
labels.

## Usage

``` r
harmonize_values(
  x,
  harmonize_label = NULL,
  harmonize_labels = NULL,
  na_values = c(do_not_know = 99997, declined = 99998, inap = 99999),
  na_range = NULL,
  id = "survey_id",
  name_orig = NULL,
  remove = NULL,
  perl = FALSE
)
```

## Arguments

- x:

  A labelled vector

- harmonize_label:

  A character vector of 1L containing the new, harmonize variable label.
  Defaults to `NULL`, in which case it uses the variable label of `x`,
  unless it is also `NULL`.

- harmonize_labels:

  A list of harmonization values

- na_values:

  A named vector of `na_values`, the observations that are defined to be
  treated as missing in the SPSS-style coding.

- na_range:

  A min, max range of `na_range`, the continuous missing value range. In
  most surveys this should be left `NULL`.

- id:

  A survey ID, defaults to `survey_id`

- name_orig:

  The original name of the variable. If left `NULL` it uses the latest
  name of the object `x`.

- remove:

  Defaults to `NULL`. A character or regex that will be removed from all
  old value labels, like `"\("|\)` for ( and ).

- perl:

  Use perl-like regex? Defaults to `FALSE`.

## Value

A labelled vector that contains in its metadata attributes the original
labelling, the original numeric coding and the current labelling, with
the numerical values representing the harmonized coding.

## Details

Create a labelled vector that contains in its metadata attributes the
original labelling, the original numeric coding and the current
labelling, with the numerical values representing the harmonized coding.

## See also

Other harmonization functions:
[`collect_val_labels()`](https://ropengov.github.io/retroharmonize/reference/collect_val_labels.md),
[`crosswalk_surveys()`](https://ropengov.github.io/retroharmonize/reference/crosswalk_surveys.md),
[`harmonize_na_values()`](https://ropengov.github.io/retroharmonize/reference/harmonize_na_values.md),
[`harmonize_survey_values()`](https://ropengov.github.io/retroharmonize/reference/harmonize_survey_values.md),
[`harmonize_var_names()`](https://ropengov.github.io/retroharmonize/reference/harmonize_var_names.md),
[`is.crosswalk_table()`](https://ropengov.github.io/retroharmonize/reference/crosswalk_table_create.md),
[`label_normalize()`](https://ropengov.github.io/retroharmonize/reference/label_normalize.md)

## Examples

``` r
var1 <- labelled::labelled_spss(
  x = c(1, 0, 1, 1, 0, 8, 9),
  labels = c(
    "TRUST" = 1,
    "NOT TRUST" = 0,
    "DON'T KNOW" = 8,
    "INAP. HERE" = 9
  ),
  na_values = c(8, 9)
)

harmonize_values(
  var1,
  harmonize_labels = list(
    from = c("^tend\\sto|^trust", "^tend\\snot|not\\strust", "^dk|^don", "^inap"),
    to = c("trust", "not_trust", "do_not_know", "inap"),
    numeric_values = c(1, 0, 99997, 99999)
  ),
  na_values = c(
    "do_not_know" = 99997,
    "inap" = 99999
  ),
  id = "survey_id"
)
#> <labelled_spss_survey<double>[7]>: var1
#> 1 0 1 1 0 99997 99999
#> Missing values: 99997, 99999
#> See all attributes survey_id_name, survey_id_values, survey_id_label [...], survey_id_na_values with attributes(x)
```
