# Harmonize the variable names of surveys

The function harmonizes the variable names of surveys (of class
`survey`) that are imported from an external file as a wave.

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

  A list of surveys imported with
  [`read_surveys`](https://ropengov.github.io/retroharmonize/reference/read_surveys.md)

- metadata:

  A metadata table created by `metadata_create` and binded together for
  all surveys in `survey_list`.

- old:

  The column name in `metadata` that contains the old, not harmonized
  variable names.

- new:

  The column name in `metadata` that contains the new, harmonized
  variable names.

- rowids:

  Rename var labels of original vars `rowid` to simply `uniqid`?

## Value

The list of surveys with harmonized variable names.

## Details

If the `metadata` that contains subsetting information is subsetted,
then it will subset the surveys in `survey_list`.

## See also

crosswalk

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
examples_dir <- system.file("examples", package = "retroharmonize")
survey_list <- dir(examples_dir)[grepl("\\.rds", dir(examples_dir))]

example_surveys <- read_surveys(
  file.path(examples_dir, survey_list)
)

metadata <- metadata_create(example_surveys)
metadata$var_name_suggested <- label_normalize(metadata$var_name)
metadata$var_name_suggested[metadata$label_orig == "age_education"] <- "age_education"

harmonize_var_names(
  survey_list = example_surveys,
  metadata = metadata
)
#> [[1]]
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
#> 
#> [[2]]
#> Unknown (2026): Untitled Dataset [dataset]
#>    rowid    doi   version uniqid serialid isocntry p1      p2      p3    p4      
#>    <chr>    <chr> <chr>    <dbl>    <dbl> <chr>    <dbl+l> <dbl+l> <dbl> <dbl+l>
#>  1 ZA6863_1 doi:… 1.0.0 … 1.10e8     8688 NL       7 [Fri… 2 [8 -… 50    1 [Two…
#>  2 ZA6863_2 doi:… 1.0.0 … 1.10e8     8890 NL       5 [Wed… 4 [17 … 50    1 [Two…
#>  3 ZA6863_3 doi:… 1.0.0 … 1.10e8     8925 NL       5 [Wed… 4 [17 … 65    1 [Two…
#>  4 ZA6863_4 doi:… 1.0.0 … 1.10e8     8939 NL       4 [Tue… 2 [8 -… 47    1 [Two…
#>  5 ZA6863_5 doi:… 1.0.0 … 1.10e8     9035 NL       3 [Mon… 5 [20 … 49    2 [Thr…
#>  6 ZA6863_6 doi:… 1.0.0 … 1.10e8     9188 NL       3 [Mon… 5 [20 … 57    1 [Two…
#>  7 ZA6863_7 doi:… 1.0.0 … 1.10e8     9429 NL       3 [Mon… 2 [8 -… 52    1 [Two…
#>  8 ZA6863_8 doi:… 1.0.0 … 1.10e8     9450 NL       5 [Wed… 3 [13 … 58    1 [Two…
#>  9 ZA6863_9 doi:… 1.0.0 … 1.10e8     9570 NL       6 [Thu… 4 [17 … 39    1 [Two…
#> 10 ZA6863_… doi:… 1.0.0 … 1.10e8     9674 NL       7 [Fri… 3 [13 … 41    1 [Two…
#> # ℹ 40 more rows
#> # ℹ 38 more variables: nuts <chr+lbl>, d7 <dbl+lbl>, d8 <dbl+lbl>,
#> #   d25 <dbl+lbl>, d60 <dbl+lbl>, qa14_3 <dbl+lbl>, qa14_2 <dbl+lbl>,
#> #   qa14_1 <dbl+lbl>, qa8a_3 <dbl+lbl>, qa8a_9 <dbl+lbl>, qa8b_2 <dbl+lbl>,
#> #   qa8a_1 <dbl+lbl>, qa8a_7 <dbl+lbl>, qa8a_8 <dbl+lbl>, qa8a_2 <dbl+lbl>,
#> #   qa8a_5 <dbl+lbl>, qa8b_1 <dbl+lbl>, qa8a_4 <dbl+lbl>, qa8a_6 <dbl+lbl>,
#> #   qa8a_10 <dbl+lbl>, qa8b_3 <dbl+lbl>, qd7.1 <dbl+lbl>, qd7.2 <dbl+lbl>, … 
#> 
#> [[3]]
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
#> 
```
