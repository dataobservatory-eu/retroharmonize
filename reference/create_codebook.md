# Create a survey codebook

Expand survey metadata into a long-format codebook of value labels.

## Usage

``` r
create_codebook(metadata = NULL, survey = NULL)

codebook_waves_create(waves)

codebook_surveys_create(survey_list)
```

## Arguments

- metadata:

  A metadata table created by \[metadata_create()\]. If supplied,
  \`survey\` must be \`NULL\`.

- survey:

  A survey object of class \`"survey"\`. If supplied, metadata is
  generated internally using \[metadata_create()\].

- waves:

  A list of surveys.

- survey_list:

  A list containing surveys of class survey.

## Value

A data frame with one row per value label, including:

- survey identifiers (\`id\`, \`filename\`)

- original variable names and labels

- value codes and value labels

- label type (\`"valid"\` or \`"missing"\`)

- summary counts of labels

Additional user-defined metadata columns present in the input metadata
are preserved.

## Details

\`create_codebook()\` takes survey-level metadata and returns a tidy
data frame describing all labelled variables and their associated value
labels. Each row corresponds to a single value label, classified as
either a valid value or a missing value.

Unlabelled numeric and character variables are excluded.

For multiple survey waves, use \[codebook_surveys_create()\].

If both \`metadata\` and \`survey\` are provided, \`survey\` takes
precedence.

## See also

\[metadata_create()\], \[codebook_surveys_create()\]

Other metadata functions:
[`is.crosswalk_table()`](https://ropengov.github.io/retroharmonize/reference/crosswalk_table_create.md),
[`metadata_create()`](https://ropengov.github.io/retroharmonize/reference/metadata_create.md),
[`metadata_survey_create()`](https://ropengov.github.io/retroharmonize/reference/metadata_survey_create.md)

## Examples

``` r
survey <- read_rds(
  system.file("examples", "ZA7576.rds", package = "retroharmonize")
)

cb <- create_codebook(survey = survey)
head(cb)
#> # A tibble: 6 × 12
#>   entry id    filename var_name_orig var_label_orig val_code_orig val_label_orig
#>   <int> <chr> <chr>    <chr>         <chr>          <chr>         <chr>         
#> 1     8 ZA75… ZA7576.… p1            date_of_inter… 1             Friday, 7th J…
#> 2     8 ZA75… ZA7576.… p1            date_of_inter… 10            Sunday, 16th …
#> 3     8 ZA75… ZA7576.… p1            date_of_inter… 11            Monday, 17th …
#> 4     8 ZA75… ZA7576.… p1            date_of_inter… 12            Tuesday, 18th…
#> 5     8 ZA75… ZA7576.… p1            date_of_inter… 13            Wedneday, 19t…
#> 6     8 ZA75… ZA7576.… p1            date_of_inter… 14            Thursday, 20t…
#> # ℹ 5 more variables: label_range <chr>, na_range <named list>, n_labels <dbl>,
#> #   n_valid_labels <dbl>, n_na_labels <dbl>

# \donttest{
examples_dir <- system.file("examples", package = "retroharmonize")
survey_list <- dir(examples_dir)[grepl("\\.rds", dir(examples_dir))]

example_surveys <- read_surveys(
  file.path(examples_dir, survey_list),
  save_to_rds = FALSE
)

codebook_surveys_create(example_surveys)
#> # A tibble: 1,366 × 12
#>    entry id     filename   var_name_orig var_label_orig    val_code_orig
#>    <int> <chr>  <chr>      <chr>         <chr>             <chr>        
#>  1     6 ZA5913 ZA5913.rds p1            date_of_interview 1            
#>  2     6 ZA5913 ZA5913.rds p1            date_of_interview 10           
#>  3     6 ZA5913 ZA5913.rds p1            date_of_interview 11           
#>  4     6 ZA5913 ZA5913.rds p1            date_of_interview 12           
#>  5     6 ZA5913 ZA5913.rds p1            date_of_interview 13           
#>  6     6 ZA5913 ZA5913.rds p1            date_of_interview 14           
#>  7     6 ZA5913 ZA5913.rds p1            date_of_interview 2            
#>  8     6 ZA5913 ZA5913.rds p1            date_of_interview 3            
#>  9     6 ZA5913 ZA5913.rds p1            date_of_interview 4            
#> 10     6 ZA5913 ZA5913.rds p1            date_of_interview 5            
#> # ℹ 1,356 more rows
#> # ℹ 6 more variables: val_label_orig <chr>, label_range <chr>,
#> #   na_range <named list>, n_labels <dbl>, n_valid_labels <dbl>,
#> #   n_na_labels <dbl>
# }
```
