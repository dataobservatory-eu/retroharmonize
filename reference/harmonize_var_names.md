# Harmonize variable names across surveys

\`harmonize_var_names()\` renames variables across multiple surveys to a
shared harmonized naming scheme.

The harmonization rules are defined in a metadata table, typically
created with \[metadata_create()\].

## Usage

``` r
harmonize_var_names(
  survey_list,
  metadata,
  old = "var_name_orig",
  new = "var_name_suggested",
  rowids = TRUE
)
```

## Arguments

- survey_list:

  A list of survey objects, typically imported with \[read_surveys()\].

- metadata:

  A metadata table containing harmonization rules. Typically created
  with \[metadata_create()\] and combined across surveys.

- old:

  Name of the column in \`metadata\` containing the original variable
  names.

- new:

  Name of the column in \`metadata\` containing the harmonized variable
  names.

- rowids:

  Logical. Should original \`rowid\` variables be renamed to
  \`"uniqid"\`?

## Value

A list of surveys with harmonized variable names.

## Details

Harmonize variable names in a list of survey objects using a metadata
crosswalk table.

The function can also be used for survey subsetting workflows. If
\`metadata\` contains only a subset of variables for a survey, only
those variables are retained in the harmonized output.

## See also

\[metadata_create()\], \[crosswalk()\]

Other harmonization functions:
[`collect_val_labels()`](https://ropengov.github.io/retroharmonize/reference/collect_val_labels.md),
[`crosswalk_surveys()`](https://ropengov.github.io/retroharmonize/reference/crosswalk_surveys.md),
[`harmonize_na_values()`](https://ropengov.github.io/retroharmonize/reference/harmonize_na_values.md),
[`harmonize_survey_values()`](https://ropengov.github.io/retroharmonize/reference/harmonize_survey_values.md),
[`harmonize_values()`](https://ropengov.github.io/retroharmonize/reference/harmonize_values.md),
[`is.crosswalk_table()`](https://ropengov.github.io/retroharmonize/reference/crosswalk_table_create.md),
[`label_normalize()`](https://ropengov.github.io/retroharmonize/reference/label_normalize.md)

## Examples

``` r
examples_dir <- system.file(
  "examples",
  package = "retroharmonize"
)

survey_files <- dir(
  examples_dir,
  pattern = "\\.rds$"
)

example_surveys <- read_surveys(
  file.path(examples_dir, survey_files)
)

metadata <- metadata_create(
  example_surveys
)

metadata$var_name_suggested <-
  label_normalize(metadata$var_name)

metadata$var_name_suggested[
  metadata$label_orig == "age_education"
] <- "age_education"

harmonized_surveys <- harmonize_var_names(
  survey_list = example_surveys,
  metadata = metadata
)

harmonized_surveys[[1]]
#> Unknown (2026): Untitled Dataset [dataset]
#>    rowid     doi       version uniqid isocntry p1       p3    p4      nuts       
#>    <chr>     <chr>     <chr>    <dbl> <chr>    <dbl+lb> <dbl> <dbl+l> <chr+lbl> 
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
