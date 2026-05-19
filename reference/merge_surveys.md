# Merge and harmonize surveys

\`merge_surveys()\` applies a harmonization specification to a list of
survey objects and returns harmonized survey datasets with aligned
variable names and metadata.

## Usage

``` r
merge_surveys(survey_list, var_harmonization)
```

## Arguments

- survey_list:

  A list of survey objects.

- var_harmonization:

  A metadata table describing the harmonization rules. The table must
  contain at least:

  \- \`filename\` - \`var_name_orig\` - \`var_name_target\` -
  \`var_label\`

## Value

A list of harmonized survey objects with standardized variable names and
variable labels.

## Details

Harmonize variable names, labels, and identifiers across multiple
surveys using a metadata crosswalk table.

Prior to version 0.2.0 this function was called \`merge_waves()\`,
reflecting terminology commonly used in Eurobarometer surveys.

The harmonization table supplied in \`var_harmonization\` typically
originates from \[metadata_create()\] and contains mappings between
original and harmonized variable names.

## See also

\[metadata_create()\]

Other survey harmonization functions:
[`merge_waves()`](https://ropengov.github.io/retroharmonize/reference/merge_waves.md)

## Examples

``` r
# \donttest{

examples_dir <- system.file(
  "examples",
  package = "retroharmonize"
)

survey_files <- dir(
  examples_dir,
  pattern = "\\.rds$",
  full.names = TRUE
)

example_surveys <- read_surveys(
  survey_files
)

metadata <- metadata_create(
  survey_list = example_surveys
)

to_harmonize <- metadata %>%
  dplyr::filter(
    var_name_orig %in% c("rowid", "w1") |
      grepl("^trust", var_label_orig)
  ) %>%
  dplyr::mutate(
    var_label = var_label_normalize(var_label_orig),
    var_name_target = val_label_normalize(var_label),
    var_name_target = ifelse(
      .data$var_name_orig %in%
        c("rowid", "w1", "wex"),
      .data$var_name_orig,
      .data$var_name_target
    )
  )

merged_surveys <- merge_surveys(
  survey_list = example_surveys,
  var_harmonization = to_harmonize
)

merged_surveys[[1]]
#> Unknown (2026): Untitled Dataset [dataset]
#>    rowid    trust_in_institution…¹ trust_in_institution…² trust_in_institution…³ 
#>    <chr>    <retroh_dbl>           <retroh_dbl>           <retroh_dbl>          
#>  1 ZA5913_1 2 [Tend not to trust]  2 [Tend not to trust]  2 [Tend not to trust] 
#>  2 ZA5913_2 2 [Tend not to trust]  2 [Tend not to trust]  2 [Tend not to trust] 
#>  3 ZA5913_3 1 [Tend to trust]      1 [Tend to trust]      1 [Tend to trust]     
#>  4 ZA5913_4 2 [Tend not to trust]  1 [Tend to trust]      1 [Tend to trust]     
#>  5 ZA5913_5 1 [Tend to trust]      1 [Tend to trust]      2 [Tend not to trust] 
#>  6 ZA5913_6 1 [Tend to trust]      2 [Tend not to trust]  2 [Tend not to trust] 
#>  7 ZA5913_7 2 [Tend not to trust]  3 (NA) [DK]            2 [Tend not to trust] 
#>  8 ZA5913_8 1 [Tend to trust]      1 [Tend to trust]      1 [Tend to trust]     
#>  9 ZA5913_9 2 [Tend not to trust]  2 [Tend not to trust]  2 [Tend not to trust] 
#> 10 ZA5913_… 2 [Tend not to trust]  2 [Tend not to trust]  2 [Tend not to trust] 
#> # ℹ 25 more rows
#> # ℹ abbreviated names: ¹​trust_in_institutions_european_union,
#> #   ²​trust_in_institutions_national_government,
#> #   ³​trust_in_institutions_national_parliament
#> # ℹ 3 more variables: trust_in_institutions_political_parties <retroh_dbl>,
#> #   trust_in_institutions_reg_loc_authorities <retroh_dbl>, w1 <dbl> 
# }
```
