# Harmonize na_values in haven_labelled_spss

Harmonize na_values in haven_labelled_spss

## Usage

``` r
harmonize_na_values(df)
```

## Arguments

- df:

  A data frame that contains haven_labelled_spss vectors.

## Value

A tibble where the na_values are consistent

## See also

Other harmonization functions:
[`collect_val_labels()`](https://ropengov.github.io/retroharmonize/reference/collect_val_labels.md),
[`crosswalk_surveys()`](https://ropengov.github.io/retroharmonize/reference/crosswalk_surveys.md),
[`harmonize_survey_values()`](https://ropengov.github.io/retroharmonize/reference/harmonize_survey_values.md),
[`harmonize_values()`](https://ropengov.github.io/retroharmonize/reference/harmonize_values.md),
[`harmonize_var_names()`](https://ropengov.github.io/retroharmonize/reference/harmonize_var_names.md),
[`is.crosswalk_table()`](https://ropengov.github.io/retroharmonize/reference/crosswalk_table_create.md),
[`label_normalize()`](https://ropengov.github.io/retroharmonize/reference/label_normalize.md)

## Examples

``` r
# \donttest{
examples_dir <- system.file(
  "examples",
  package = "retroharmonize"
)

test_read <- read_rds(
  file.path(examples_dir, "ZA7576.rds"),
  id = "ZA7576",
  doi = "test_doi"
)

harmonize_na_values(test_read)
#> Unknown (2026): Untitled Dataset [dataset]
#>    rowid    doi   version uniqid caseid serialid isocntry p1       p2      p3    
#>    <chr>    <chr> <chr>    <dbl>  <dbl>    <dbl> <chr>    <dbl+lb> <dbl+l> <dbl>
#>  1 ZA7576_1 doi:… 1.0.0 … 5.00e7    481     3209 ES        4 [Mon… 3 [13 … 25   
#>  2 ZA7576_2 doi:… 1.0.0 … 1.10e8     76     8706 NL        6 [Wed… 3 [13 … 58   
#>  3 ZA7576_3 doi:… 1.0.0 … 1.10e8    343     8890 NL       11 [Mon… 3 [13 … 56   
#>  4 ZA7576_4 doi:… 1.0.0 … 1.10e8    473     8989 NL        5 [Tue… 3 [13 … 62   
#>  5 ZA7576_5 doi:… 1.0.0 … 1.10e8    493     9001 NL        8 [Fri… 4 [17 … 30   
#>  6 ZA7576_6 doi:… 1.0.0 … 1.10e8    897     9272 NL        6 [Wed… 3 [13 … 56   
#>  7 ZA7576_7 doi:… 1.0.0 … 1.10e8   1041     9379 NL        5 [Tue… 3 [13 … 57   
#>  8 ZA7576_8 doi:… 1.0.0 … 1.10e8   1192     9493 NL        6 [Wed… 2 [8 -… 60   
#>  9 ZA7576_9 doi:… 1.0.0 … 1.10e8   1274     9543 NL        7 [Thu… 4 [17 … 57   
#> 10 ZA7576_… doi:… 1.0.0 … 1.10e8   1344     9590 NL        6 [Wed… 2 [8 -… 83   
#> # ℹ 35 more rows
#> # ℹ 45 more variables: p4 <dbl+lbl>, nuts <chr+lbl>, d7 <dbl+lbl>,
#> #   d8 <dbl+lbl>, d25 <dbl+lbl>, d60 <dbl+lbl>, qa14_5 <dbl+lbl>,
#> #   qa14_3 <dbl+lbl>, qa14_2 <dbl+lbl>, qa14_4 <dbl+lbl>, qa14_1 <dbl+lbl>,
#> #   qa6a_5 <dbl+lbl>, qa6a_10 <dbl+lbl>, qa6b_2 <dbl+lbl>, qa6a_3 <dbl+lbl>,
#> #   qa6a_1 <dbl+lbl>, qa6b_4 <dbl+lbl>, qa6a_8 <dbl+lbl>, qa6a_9 <dbl+lbl>,
#> #   qa6a_4 <dbl+lbl>, qa6a_2 <dbl+lbl>, qa6b_1 <dbl+lbl>, qa6a_6 <dbl+lbl>, … 
# }
```
