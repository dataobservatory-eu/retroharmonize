# Document survey lists

Document the key attributes surveys in a survey list.

## Usage

``` r
document_surveys(survey_list = NULL, survey_paths = NULL, .f = NULL)

document_waves(waves)
```

## Arguments

- survey_list:

  A list of
  [`survey`](https://ropengov.github.io/retroharmonize/reference/survey.md)
  objects.

- survey_paths:

  A vector of full file paths to the surveys to subset, defaults to
  `NULL`.

- .f:

  A function to import the surveys with. Defaults to `'read_rds'`. For
  SPSS files, `read_spss` is recommended, which is a well-parameterized
  version of
  [`read_spss`](https://haven.tidyverse.org/reference/read_spss.html)
  that saves some metadata, too. For STATA files use `read_dta`.

- waves:

  A list of
  [`survey`](https://ropengov.github.io/retroharmonize/reference/survey.md)
  objects.

## Value

Returns a data frame with the key attributes of the surveys in a survey
list: the name of the data file, the number of rows and columns, and the
size of the object as stored in memory.

## Details

The function has two alternative input parameters. If `survey_list` is
the input, it returns the name of the original source data file, the
number of rows and columns, and the size of the object as stored in
memory. In case `survey_paths` contains the source data files, it will
sequentially read those files, and add the file size, the last access
and the last modified time attributes.

The earlier form `document_waves` is deprecated. Currently called
`document_surveys`.

## See also

Other documentation functions:
[`document_survey_item()`](https://ropengov.github.io/retroharmonize/reference/document_survey_item.md)

## Examples

``` r
examples_dir <- system.file("examples", package = "retroharmonize")

my_rds_files <- dir(examples_dir)[grepl(
  ".rds",
  dir(examples_dir)
)]

example_surveys <- read_surveys(file.path(examples_dir, my_rds_files))

documented <- document_surveys(example_surveys)

attr(documented, "original_list")
#> [1] "example_surveys"
documented
#> # A tibble: 3 × 5
#>   id     filename    ncol  nrow object_size
#>   <chr>  <chr>      <int> <int>       <dbl>
#> 1 ZA5913 ZA5913.rds    37    35      118168
#> 2 ZA6863 ZA6863.rds    48    50      152704
#> 3 ZA7576 ZA7576.rds    55    45      173632

document_surveys(survey_paths = file.path(examples_dir, my_rds_files))
#> 1/1 ZA5913.rds
#> 1/2 ZA6863.rds
#> 1/3 ZA7576.rds
#> # A tibble: 3 × 8
#>   id     filename    ncol  nrow object_size file_size accessed     last_modified
#>   <chr>  <chr>      <dbl> <dbl>       <dbl>     <dbl> <chr>        <chr>        
#> 1 ZA5913 ZA5913.rds    37    35      118168      6507 2026-05-20 … 2026-05-20 1…
#> 2 ZA6863 ZA6863.rds    48    50      152704      8738 2026-05-20 … 2026-05-20 1…
#> 3 ZA7576 ZA7576.rds    55    45      173632      9312 2026-05-20 … 2026-05-20 1…
```
