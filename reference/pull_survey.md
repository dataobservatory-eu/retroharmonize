# Retrieve a survey from a survey list

Extract a single survey object from a list of surveys using either its
survey identifier or source file name.

## Usage

``` r
pull_survey(survey_list, id = NULL, filename = NULL)
```

## Arguments

- survey_list:

  A list of \`survey\` objects.

- id:

  Optional survey identifier stored in the \`"id"\` attribute.

- filename:

  Optional source file name stored in the \`"filename"\` attribute.

## Value

A single \`survey\` object.

## Details

Either \`id\` or \`filename\` must be supplied.

The function throws an error if:

\- neither identifier is provided, - the requested survey is not
found, - or multiple surveys match the query.

## See also

Other import functions:
[`harmonize_survey_variables()`](https://ropengov.github.io/retroharmonize/reference/harmonize_survey_variables.md),
[`read_csv()`](https://ropengov.github.io/retroharmonize/reference/read_csv.md),
[`read_dta()`](https://ropengov.github.io/retroharmonize/reference/read_dta.md),
[`read_rds()`](https://ropengov.github.io/retroharmonize/reference/read_rds.md),
[`read_spss()`](https://ropengov.github.io/retroharmonize/reference/read_spss.md),
[`read_surveys()`](https://ropengov.github.io/retroharmonize/reference/read_surveys.md)

## Examples

``` r
examples_dir <- system.file(
  "examples",
  package = "retroharmonize"
)

my_rds_files <- dir(examples_dir)[grepl(
  "\\.rds$",
  dir(examples_dir)
)]

example_surveys <- read_surveys(
  file.path(examples_dir, my_rds_files)
)

pull_survey(
  example_surveys,
  id = "ZA5913"
)
#> Unknown (2026): Untitled Dataset [dataset]
#>    rowid     doi       version uniqid isocntry p1       p3    p4      nuts       
#>  * <chr>     <chr>     <chr>    <dbl> <chr>    <dbl+lb> <dbl> <dbl+l> <chr+lbl> 
#>  1 ZA5913_1  doi:10.4… 2.0.0 … 1.13e7 NL        8 [Tue… 27    1 [Two… NL21 [Ove…
#>  2 ZA5913_2  doi:10.4… 2.0.0 … 1.13e7 NL        8 [Tue… 31    1 [Two… NL33 [Zui…
#>  3 ZA5913_3  doi:10.4… 2.0.0 … 1.13e7 NL       10 [Thu… 26    1 [Two… NL32 [Noo…
#>  4 ZA5913_4  doi:10.4… 2.0.0 … 1.13e7 NL       14 [Mon… 23    1 [Two… NL22 [Gel…
#>  5 ZA5913_5  doi:10.4… 2.0.0 … 1.13e7 NL       10 [Thu… 31    2 [Thr… NL33 [Zui…
#>  6 ZA5913_6  doi:10.4… 2.0.0 … 1.13e7 NL        8 [Tue… 33    1 [Two… NL41 [Noo…
#>  7 ZA5913_7  doi:10.4… 2.0.0 … 1.13e7 NL       10 [Thu… 21    1 [Two… NL13 [Dre…
#>  8 ZA5913_8  doi:10.4… 2.0.0 … 1.13e7 NL       10 [Thu… 44    1 [Two… NL13 [Dre…
#>  9 ZA5913_9  doi:10.4… 2.0.0 … 1.13e7 NL        5 [Sat… 19    1 [Two… NL34 [Zee…
#> 10 ZA5913_10 doi:10.4… 2.0.0 … 1.13e7 NL       14 [Mon… 22    1 [Two… NL22 [Gel…
#> # ℹ 25 more rows
#> # ℹ 28 more variables: d7 <dbl+lbl>, d8 <dbl+lbl>, d25 <dbl+lbl>,
#> #   d60 <dbl+lbl>, qa10_3 <dbl+lbl>, qa10_2 <dbl+lbl>, qa10_1 <dbl+lbl>,
#> #   qa7_4 <dbl+lbl>, qa7_2 <dbl+lbl>, qa7_3 <dbl+lbl>, qa7_1 <dbl+lbl>,
#> #   qa7_5 <dbl+lbl>, qd3_1 <dbl+lbl>, qd3_2 <dbl+lbl>, qd3_3 <dbl+lbl>,
#> #   qd3_4 <dbl+lbl>, qd3_5 <dbl+lbl>, qd3_6 <dbl+lbl>, qd3_7 <dbl+lbl>,
#> #   qd3_8 <dbl+lbl>, qd3_9 <dbl+lbl>, qd3_10 <dbl+lbl>, qd3_11 <dbl+lbl>, … 
```
