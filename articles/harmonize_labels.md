# Harmonize Value Labels

``` r

library(retroharmonize)
```

This vignette follows up on the [Working With A Crosswalk
Table](https://retroharmonize.dataobservatory.eu/articles/crosswalk.html).
In the that vignette, you learned how to remove variables that cannot be
harmonized with
[`subset_surveys()`](https://ropengov.github.io/retroharmonize/reference/subset_surveys.md)
and harmonize variable names with
[`harmonize_survey_variables()`](https://ropengov.github.io/retroharmonize/reference/harmonize_survey_variables.md).

As a result of these steps, you have a list of surveys, or surveys saved
in files that are harmonization candidates. They now need a consistent
numerical coding, labelling with special attention given to missing
values and other special values.

## Harmonize value codes and labels

The function
[`harmonize_values()`](https://ropengov.github.io/retroharmonize/reference/harmonize_values.md)
solves problems in the following situations:

1.  When the data are read from an SPSS file, in one dataset the
    variable `survey1$trust` has no user-defined missing values, but in
    another dataset the variable `survey2$trust` does have missing
    values defined. The two variables cannot be combined. We add
    harmonized missing values to the missing value range, even if they
    are not present among the observations.

2.  The labels are not matching in `survey1$trust` and `survey2$trust`.
    We harmonize the labels, and record their initial values for
    reproducibility.

3.  The missing value ranges in `survey1$trust` and `survey2$trust` do
    not match. We harmonize the missing values, and record their initial
    values for reproducibility.

4.  There are unexpected labels present in the range of substantive or
    missing values. They are taken out from the value range with a
    special code and marked with a special label.

### Scenario 1

All values are present, and only the missing values are recoded.

``` r

v1 <- labelled_spss_survey(
  c(1, 0, 1, 9),
  labels = c(
    "yes" = 1,
    "no" = 0,
    "inap" = 9
  ),
  na_values = 9
)

h1 <- harmonize_values(
  x = v1,
  harmonize_labels = list(
    from = c("^yes", "^no", "^inap"),
    to = c("trust", "not_trust", "inap"),
    numeric_values = c(1, 0, 99999)
  ),
  id = "survey1"
)

str(h1)
#>  'retroharmonize_labelled_spss_survey' num [1:4]     1     0     1 99999
#>  - attr(*, "labels")= Named num [1:5] 0 1 99997 99998 99999
#>   ..- attr(*, "names")= chr [1:5] "not_trust" "trust" "do_not_know" "declined" ...
#>  - attr(*, "label")= chr ""
#>  - attr(*, "na_values")= num [1:3] 99997 99998 99999
#>  - attr(*, "survey1_name")= chr "v1"
#>  - attr(*, "survey1_values")= Named num [1:3] 0 1 99999
#>   ..- attr(*, "names")= chr [1:3] "0" "1" "9"
#>  - attr(*, "survey1_label")= chr ""
#>  - attr(*, "survey1_labels")= Named num [1:3] 1 0 9
#>   ..- attr(*, "names")= chr [1:3] "yes" "no" "inap"
#>  - attr(*, "survey1_na_values")= num 9
#>  - attr(*, "id")= chr "survey1"
```

- the attribute `survey1_values` may be used to restore the original
  coding.

- the attribute `survey1_labels` may be used to restore the original
  labelling.

- the attribute `na_values` can re-define if a category should be
  treated as missing.

The `to_numeric()` method converts the missing value range to
`NA_real_`.

### Scenario 2

The original variable is of class
[`haven::labelled_spss()`](https://haven.tidyverse.org/reference/labelled_spss.html).
It has an invalid missing value.

``` r

v2 <- haven::labelled_spss(
  c(1, 1, 0, 8),
  labels = c(
    "yes" = 1,
    "no" = 0,
    "declined" = 8
  ),
  na_values = 8
)

h2 <- harmonize_values(
  v2,
  harmonize_labels = list(
    from = c("^yes", "^no", "^inap"),
    to = c("trust", "not_trust", "inap"),
    numeric_values = c(1, 0, 99999)
  ),
  id = "survey2"
)
str(h2)
#>  'retroharmonize_labelled_spss_survey' num [1:4] 1 1 0 8
#>  - attr(*, "labels")= Named num [1:5] 0 1 99997 99998 99999
#>   ..- attr(*, "names")= chr [1:5] "not_trust" "trust" "do_not_know" "declined" ...
#>  - attr(*, "label")= chr "v2"
#>  - attr(*, "na_values")= num [1:3] 99997 99998 99999
#>  - attr(*, "survey2_name")= chr "v2"
#>  - attr(*, "survey2_values")= Named num [1:3] 0 1 8
#>   ..- attr(*, "names")= chr [1:3] "0" "1" "8"
#>  - attr(*, "survey2_label")= chr "v2"
#>  - attr(*, "survey2_labels")= Named num [1:3] 1 0 8
#>   ..- attr(*, "names")= chr [1:3] "yes" "no" "declined"
#>  - attr(*, "survey2_na_values")= num 8
#>  - attr(*, "id")= chr "survey2"
```

We apply the code `99901` for this value and label it as
`invalid_label`.

After modifying the user-defined missing value labels:

``` r

h2b <- harmonize_values(
  v2,
  harmonize_labels = list(
    from = c("^yes", "^no", "^decline"),
    to = c("trust", "not_trust", "inap"),
    numeric_values = c(1, 0, 99999)
  ),
  id = "survey2"
)

str(h2b)
#>  'retroharmonize_labelled_spss_survey' num [1:4]     1     1     0 99999
#>  - attr(*, "labels")= Named num [1:5] 0 1 99997 99998 99999
#>   ..- attr(*, "names")= chr [1:5] "not_trust" "trust" "do_not_know" "declined" ...
#>  - attr(*, "label")= chr "v2"
#>  - attr(*, "na_values")= num [1:3] 99997 99998 99999
#>  - attr(*, "survey2_name")= chr "v2"
#>  - attr(*, "survey2_values")= Named num [1:3] 0 1 99999
#>   ..- attr(*, "names")= chr [1:3] "0" "1" "8"
#>  - attr(*, "survey2_label")= chr "v2"
#>  - attr(*, "survey2_labels")= Named num [1:3] 1 0 8
#>   ..- attr(*, "names")= chr [1:3] "yes" "no" "declined"
#>  - attr(*, "survey2_na_values")= num 8
#>  - attr(*, "id")= chr "survey2"
```

### Scenario 3

The original vector is of class `haven_labelled`, therefore it has no
defined missing value range. We want to remove `DK` from the value range
to the missing range as `do_not_know`. The original vector also has an
unlabelled value (9). Because we believe that in this vector all values
should have a value label, we treat it as an invalid observation.

``` r

var3 <- labelled::labelled(
  x = c(1, 6, 2, 9, 1, 1, 2),
  labels = c(
    "Tend to trust" = 1,
    "Tend not to trust" = 2,
    "DK" = 6
  )
)

h3 <- harmonize_values(
  x = var3,
  harmonize_labels = list(
    from = c(
      "^tend\\sto|^trust",
      "^tend\\snot|not\\strust", "^dk",
      "^inap"
    ),
    to = c(
      "trust",
      "not_trust", "do_not_know",
      "inap"
    ),
    numeric_values = c(1, 0, 99997, 99999)
  ),
  id = "S3_"
)

str(h3)
#>  'retroharmonize_labelled_spss_survey' num [1:7]     1 99997     0     9     1     1     0
#>  - attr(*, "labels")= Named num [1:5] 0 1 99997 99998 99999
#>   ..- attr(*, "names")= chr [1:5] "not_trust" "trust" "do_not_know" "declined" ...
#>  - attr(*, "label")= chr "var3"
#>  - attr(*, "S3__name")= chr "var3"
#>  - attr(*, "S3__values")= Named num [1:4] 0 1 9 99997
#>   ..- attr(*, "names")= chr [1:4] "2" "1" "9" "6"
#>  - attr(*, "S3__label")= chr "var3"
#>  - attr(*, "S3__labels")= Named num [1:3] 1 2 6
#>   ..- attr(*, "names")= chr [1:3] "Tend to trust" "Tend not to trust" "DK"
#>  - attr(*, "id")= chr "S3_"
#>  - attr(*, "na_values")= num [1:3] 99997 99998 99999
```

### Base Types & Summary

- as factor:

``` r

summary(as_factor(h3))
#>   not_trust       trust           9 do_not_know    declined        inap 
#>           2           3           1           1           0           0
levels(as_factor(h3))
#> [1] "not_trust"   "trust"       "9"           "do_not_know" "declined"   
#> [6] "inap"
unique(as_factor(h3))
#> [1] trust       do_not_know not_trust   9          
#> Levels: not_trust trust 9 do_not_know declined inap
```

- as numeric:

``` r

summary(as_numeric(h3))
#>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     NAs 
#>    0.00    0.25    1.00    2.00    1.00    9.00       1
unique(as_numeric(h3))
#> [1]  1 NA  0  9
```

- as character:

``` r

summary(as_character(h3))
#>    Length  N.unique   N.blank Min.nchar Max.nchar 
#>         7         4         0         1        11
unique(as_character(h3))
#> [1] "trust"       "do_not_know" "not_trust"   "9"
```

## Combination of harmonized values

You can combine `labelled_spss_survey` vectors if the metadata
describing their current state is an exact match. This means that the
labels, missing values and missing range are defined the same way, and
the base type of the vector is matching numeric or character — though
labelling character vectors makes little sense.

The historic metadata, i.e. the earlier naming and coding of the
variable do not have to match, they are added to all “inherited
vectors”.

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

var2 <- labelled::labelled_spss(
  x = c(2, 2, 8, 9, 1, 1),
  labels = c(
    "Tend to trust" = 1,
    "Tend not to trust" = 2,
    "DK" = 8,
    "Inap" = 9
  ),
  na_values = c(8, 9)
)


h1 <- harmonize_values(
  x = var1,
  harmonize_label = "Do you trust the European Union?",
  harmonize_labels = list(
    from = c("^tend\\sto|^trust", "^tend\\snot|not\\strust", "^dk|^don", "^inap"),
    to = c("trust", "not_trust", "do_not_know", "inap"),
    numeric_values = c(1, 0, 99997, 99999)
  ),
  na_values = c(
    "do_not_know" = 99997,
    "inap" = 99999
  ),
  id = "survey1"
)

h2 <- harmonize_values(
  x = var2,
  harmonize_label = "Do you trust the European Union?",
  harmonize_labels = list(
    from = c("^tend\\sto|^trust", "^tend\\snot|not\\strust", "^dk|^don", "^inap"),
    to = c("trust", "not_trust", "do_not_know", "inap"),
    numeric_values = c(1, 0, 99997, 99999)
  ),
  na_values = c(
    "do_not_know" = 99997,
    "inap" = 99999
  ),
  id = "survey2"
)
```

For a single vector, you can use the
[`concatenate()`](https://ropengov.github.io/retroharmonize/reference/concatenate.md)
function, which, under the hood, calls the
[`vctrs::vec_c`](https://vctrs.r-lib.org/reference/vec_c.html) method
with some additional validation.

``` r

vctrs::vec_c(h1, h2)
#> <labelled_spss_survey<double>[13]>: Do you trust the European Union?
#> 1 0 1 1 0 99997 99999 0 0 99997 99999 1 1
#> Missing values: 99997, 99999
#> See all attributes multi-wave_name, multi-wave_values, multi-wave_label [...], survey2_na_values with attributes(x)
```

## Binding surveys together

As soon as you have only compatible variables with matching names in two
data frames, you can bind them together in a way that their history is
preserved. You can do this with
[`vctrs::vec_rbind`](https://vctrs.r-lib.org/reference/vec_bind.html) or
[`dplyr::bind_rows()`](https://dplyr.tidyverse.org/reference/bind_rows.html).
The generic [`rbind()`](https://rdrr.io/r/base/cbind.html) will lose the
labelling information.

``` r

a <- tibble::tibble(
  rowid = paste0("survey1", 1:length(h1)),
  hvar = h1,
  w = runif(n = length(h1), 0, 1)
)
b <- tibble::tibble(
  rowid = paste0("survey2", 1:length(h2)),
  hvar = h2,
  w = runif(n = length(h2), 0, 1)
)

c <- dplyr::bind_rows(a, b)
```

``` r

summary(c)
#> Do you trust the European Union?
#> Numeric values without coding:
#>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#>       0       0       1   30769   99997   99999 
#> Numeric representation:
#>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     NAs 
#>  0.0000  0.0000  1.0000  0.5556  1.0000  1.0000       4 
#> Factor representation:
#>        rowid             hvar         w           
#>  Length   :13   not_trust  :4   Min.   :0.007399  
#>  N.unique :13   trust      :5   1st Qu.:0.157208  
#>  N.blank  : 0   do_not_know:2   Median :0.466394  
#>  Min.nchar: 8   inap       :2   Mean   :0.424890  
#>  Max.nchar: 8                   3rd Qu.:0.732882  
#>                                 Max.   :0.874601
```

``` r

print(c)
#> # A tibble: 13 × 3
#>    rowid    hvar                           w
#>    <chr>    <retroh_dbl>               <dbl>
#>  1 survey11     1 [trust]            0.0808 
#>  2 survey12     0 [not_trust]        0.834  
#>  3 survey13     1 [trust]            0.601  
#>  4 survey14     1 [trust]            0.157  
#>  5 survey15     0 [not_trust]        0.00740
#>  6 survey16 99997 (NA) [do_not_know] 0.466  
#>  7 survey17 99999 (NA) [inap]        0.498  
#>  8 survey21     0 [not_trust]        0.290  
#>  9 survey22     0 [not_trust]        0.733  
#> 10 survey23 99997 (NA) [do_not_know] 0.773  
#> 11 survey24 99999 (NA) [inap]        0.875  
#> 12 survey25     1 [trust]            0.175  
#> 13 survey26     1 [trust]            0.0342
```

While dplyr’s join functions may result in correct values, the metadata
get lost. A new join method will be developed.
