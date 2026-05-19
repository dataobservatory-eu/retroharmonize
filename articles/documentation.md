# documentation

``` r

library(retroharmonize)

examples_dir <- system.file("examples", package = "retroharmonize")
my_rds_files <- dir(examples_dir)[grepl(
  ".rds",
  dir(examples_dir)
)]
```

The
[`document_surveys()`](https://ropengov.github.io/retroharmonize/reference/document_surveys.md)
function works with either a list of surveys in the memory, or a vector
of paths to survey files.

The function has two alternative input parameters. If `survey_list` is
the input, it returns the name of the original source data file, the
number of rows and columns, and the size of the object as stored in
memory. In case `survey_paths` contains the source data files, it will
sequentially read those files, and add the file size, the last access
and the last modified time attributes.

``` r

example_surveys <- read_surveys(file.path(examples_dir, my_rds_files))
documented_surveys <- document_surveys(survey_list = example_surveys)

attr(documented_surveys, "original_list")
#> [1] "example_surveys"
documented_surveys
#> # A tibble: 3 × 5
#>   id     filename    ncol  nrow object_size
#>   <chr>  <chr>      <int> <int>       <dbl>
#> 1 ZA5913 ZA5913.rds    37    35      118168
#> 2 ZA6863 ZA6863.rds    48    50      152704
#> 3 ZA7576 ZA7576.rds    55    45      173632
```

``` r

document_surveys(survey_paths = file.path(examples_dir, my_rds_files))
#> 1/1 ZA5913.rds
#> 1/2 ZA6863.rds
#> 1/3 ZA7576.rds
#> # A tibble: 3 × 8
#>   id     filename    ncol  nrow object_size file_size accessed     last_modified
#>   <chr>  <chr>      <dbl> <dbl>       <dbl>     <dbl> <chr>        <chr>        
#> 1 ZA5913 ZA5913.rds    37    35      118168      6507 2026-05-19 … 2026-05-19 1…
#> 2 ZA6863 ZA6863.rds    48    50      152704      8738 2026-05-19 … 2026-05-19 1…
#> 3 ZA7576 ZA7576.rds    55    45      173632      9312 2026-05-19 … 2026-05-19 1…
```
