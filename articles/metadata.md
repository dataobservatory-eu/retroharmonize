# Working With Survey Metadata

``` r

library(retroharmonize)
#> Warning: S3 methods 'vec_cast.retroharmonize_labelled_spss_survey',
#> 'vec_ptype2.retroharmonize_labelled_spss_survey' were declared in NAMESPACE but
#> not found
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
```

``` r

examples_dir <- system.file("examples", package = "retroharmonize")
survey_files <- dir(examples_dir)[grepl("\\.rds", dir(examples_dir))]
survey_files
#> [1] "ZA5913.rds" "ZA6863.rds" "ZA7576.rds"
```

## Working With a Single Survey

``` r

survey_1 <- read_rds(file.path(examples_dir, survey_files[1]))
```

This function should be renamed and slightly rewritten, it does too many
things.

``` r

metadata_create(survey_1) %>% head()
#>            filename     id var_name_orig     class_orig
#> ZA5913.1 ZA5913.rds ZA5913         rowid      character
#> ZA5913.2 ZA5913.rds ZA5913           doi      character
#> ZA5913.3 ZA5913.rds ZA5913       version      character
#> ZA5913.4 ZA5913.rds ZA5913        uniqid        numeric
#> ZA5913.5 ZA5913.rds ZA5913      isocntry      character
#> ZA5913.6 ZA5913.rds ZA5913            p1 haven_labelled
#>                                           var_label_orig
#> ZA5913.1                    unique_identifier_in_za_5913
#> ZA5913.2                       digital_object_identifier
#> ZA5913.3                  gesis_archive_version_and_date
#> ZA5913.4 unique_respondent_id_caseid_by_tns_country_code
#> ZA5913.5                           country_code_iso_3166
#> ZA5913.6                               date_of_interview
#>                                                 labels
#> ZA5913.1                                            NA
#> ZA5913.2                                            NA
#> ZA5913.3                                            NA
#> ZA5913.4                                            NA
#> ZA5913.5                                            NA
#> ZA5913.6 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
#>                                           valid_labels na_labels na_range
#> ZA5913.1                                            NA        NA       NA
#> ZA5913.2                                            NA        NA       NA
#> ZA5913.3                                            NA        NA       NA
#> ZA5913.4                                            NA        NA       NA
#> ZA5913.5                                            NA        NA       NA
#> ZA5913.6 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14                 NA
#>          n_labels n_valid_labels n_na_labels
#> ZA5913.1        0              0           0
#> ZA5913.2        0              0           0
#> ZA5913.3        0              0           0
#> ZA5913.4        0              0           0
#> ZA5913.5        0              0           0
#> ZA5913.6       14             14           0
```

## Working With Multiple Surveys

``` r

survey_paths <- file.path(examples_dir, survey_files)
```

With smaller data frames representing your surveys, the most efficient
way to work with the information is to read them into a list of surveys.

Read the surveys into a list object in the memory:

``` r

example_surveys <- read_surveys(survey_paths, .f = "read_rds")
```

Map the metadata contents of the files:

``` r

set.seed(2022)
metadata_create(survey_list = example_surveys) %>%
  sample_n(12)
#>      filename     id var_name_orig          class_orig
#> 1  ZA6863.rds ZA6863        qa14_1      haven_labelled
#> 2  ZA6863.rds ZA6863         qd7.7      haven_labelled
#> 3  ZA5913.rds ZA5913            p1      haven_labelled
#> 4  ZA7576.rds ZA7576         qd6.2 haven_labelled_spss
#> 5  ZA5913.rds ZA5913        qa10_3 haven_labelled_spss
#> 6  ZA5913.rds ZA5913            p3 haven_labelled_spss
#> 7  ZA7576.rds ZA7576            p1      haven_labelled
#> 8  ZA7576.rds ZA7576        qa6b_4 haven_labelled_spss
#> 9  ZA5913.rds ZA5913         rowid           character
#> 10 ZA6863.rds ZA6863           d25 haven_labelled_spss
#> 11 ZA5913.rds ZA5913        qd3_11      haven_labelled
#> 12 ZA7576.rds ZA7576            d7      haven_labelled
#>                              var_label_orig
#> 1                 european_parliament_trust
#> 2            important_values_pers_equality
#> 3                         date_of_interview
#> 4  important_values_pers_respect_human_life
#> 5               european_central_bank_trust
#> 6             duration_of_interview_minutes
#> 7                         date_of_interview
#> 8           trust_in_institutions_media_tcc
#> 9              unique_identifier_in_za_5913
#> 10                        type_of_community
#> 11    important_values_pers_self_fulfilment
#> 12                           marital_status
#>                                                                       labels
#> 1                                                                    1, 2, 3
#> 2                                                                       0, 1
#> 3                              1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
#> 4                                                                    0, 1, 9
#> 5                                                                    1, 2, 3
#> 6                                                                2, 225, 999
#> 7  1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21
#> 8                                                                 1, 2, 3, 9
#> 9                                                                         NA
#> 10                                                                1, 2, 3, 8
#> 11                                                                      0, 1
#> 12                     1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 97
#>                                                                 valid_labels
#> 1                                                                    1, 2, 3
#> 2                                                                       0, 1
#> 3                              1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
#> 4                                                                       0, 1
#> 5                                                                       1, 2
#> 6                                                                     2, 225
#> 7  1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21
#> 8                                                                    1, 2, 3
#> 9                                                                         NA
#> 10                                                                   1, 2, 3
#> 11                                                                      0, 1
#> 12                     1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 97
#>    na_labels na_range n_labels n_valid_labels n_na_labels
#> 1                  NA        3              3           0
#> 2                  NA        2              2           0
#> 3                  NA       14             14           0
#> 4          9       NA        3              2           1
#> 5          3       NA        3              2           1
#> 6        999       NA        3              2           1
#> 7                  NA       21             21           0
#> 8          9       NA        4              3           1
#> 9         NA       NA        0              0           0
#> 10         8       NA        4              3           1
#> 11                 NA        2              2           0
#> 12                 NA       16             16           0
```

If you may ran out of memory, you can work with files. The advantage of
keeping the surveys in memory is that later it will be much faster to
continue working with them, but from the metadata point of view, the
returned object is the same either way.

``` r

example_metadata <- metadata_create(survey_paths = survey_paths, .f = "read_rds")
#> Read: /home/runner/work/_temp/Library/retroharmonize/examples/ZA5913.rds
#> Read: /home/runner/work/_temp/Library/retroharmonize/examples/ZA6863.rds
#> Read: /home/runner/work/_temp/Library/retroharmonize/examples/ZA7576.rds
```

``` r

set.seed(2022)
example_metadata %>%
  sample_n(12)
#>      filename     id var_name_orig          class_orig
#> 1  ZA6863.rds ZA6863        qa14_1      haven_labelled
#> 2  ZA6863.rds ZA6863         qd7.7      haven_labelled
#> 3  ZA5913.rds ZA5913            p1      haven_labelled
#> 4  ZA7576.rds ZA7576         qd6.2 haven_labelled_spss
#> 5  ZA5913.rds ZA5913        qa10_3 haven_labelled_spss
#> 6  ZA5913.rds ZA5913            p3 haven_labelled_spss
#> 7  ZA7576.rds ZA7576            p1      haven_labelled
#> 8  ZA7576.rds ZA7576        qa6b_4 haven_labelled_spss
#> 9  ZA5913.rds ZA5913         rowid           character
#> 10 ZA6863.rds ZA6863           d25 haven_labelled_spss
#> 11 ZA5913.rds ZA5913        qd3_11      haven_labelled
#> 12 ZA7576.rds ZA7576            d7      haven_labelled
#>                              var_label_orig
#> 1                 european_parliament_trust
#> 2            important_values_pers_equality
#> 3                         date_of_interview
#> 4  important_values_pers_respect_human_life
#> 5               european_central_bank_trust
#> 6             duration_of_interview_minutes
#> 7                         date_of_interview
#> 8           trust_in_institutions_media_tcc
#> 9              unique_identifier_in_za_5913
#> 10                        type_of_community
#> 11    important_values_pers_self_fulfilment
#> 12                           marital_status
#>                                                                       labels
#> 1                                                                    1, 2, 3
#> 2                                                                       0, 1
#> 3                              1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
#> 4                                                                    0, 1, 9
#> 5                                                                    1, 2, 3
#> 6                                                                2, 225, 999
#> 7  1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21
#> 8                                                                 1, 2, 3, 9
#> 9                                                                         NA
#> 10                                                                1, 2, 3, 8
#> 11                                                                      0, 1
#> 12                     1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 97
#>                                                                 valid_labels
#> 1                                                                    1, 2, 3
#> 2                                                                       0, 1
#> 3                              1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
#> 4                                                                       0, 1
#> 5                                                                       1, 2
#> 6                                                                     2, 225
#> 7  1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21
#> 8                                                                    1, 2, 3
#> 9                                                                         NA
#> 10                                                                   1, 2, 3
#> 11                                                                      0, 1
#> 12                     1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 97
#>    na_labels na_range n_labels n_valid_labels n_na_labels
#> 1                  NA        3              3           0
#> 2                  NA        2              2           0
#> 3                  NA       14             14           0
#> 4          9       NA        3              2           1
#> 5          3       NA        3              2           1
#> 6        999       NA        3              2           1
#> 7                  NA       21             21           0
#> 8          9       NA        4              3           1
#> 9         NA       NA        0              0           0
#> 10         8       NA        4              3           1
#> 11                 NA        2              2           0
#> 12                 NA       16             16           0
```

A quick glance at some metadata:

``` r

library(dplyr)
subset_example_metadata <- example_metadata %>%
  filter(grepl("trust", .data$var_label_orig)) %>%
  filter(grepl("european_parliament", .data$var_label_orig)) %>%
  select(all_of(c("filename", "var_label_orig", "var_name_orig", "valid_labels", "na_labels", "class_orig")))

subset_example_metadata
#>     filename            var_label_orig var_name_orig valid_labels na_labels
#> 1 ZA5913.rds european_parliament_trust        qa10_1         1, 2         3
#> 2 ZA6863.rds european_parliament_trust        qa14_1      1, 2, 3          
#> 3 ZA7576.rds european_parliament_trust        qa14_1      1, 2, 3         9
#>            class_orig
#> 1 haven_labelled_spss
#> 2      haven_labelled
#> 3 haven_labelled_spss
```

In `ZA5913.rds` the Trust in European Parliament variable is called
`qa10_1`, in the other surveys it is called `qa14_1`.

In the first survey, the variable has two values (coded as 1 and 2, and
labelled as `Tend to trust` and `Tend not to trust`. )

``` r

unlist(subset_example_metadata$valid_labels[1])
#>     Tend to trust Tend not to trust 
#>                 1                 2
```

In the first survey, the variable has two values (coded as 1 and 2, and
labelled as `Tend to trust` and `Tend not to trust`.) In the second
survey, we have three values, and non of them are marked as special,
missing values. This is not surprising, because they were not SPSS
files. They have related, but not exactly matching classes, too.
Therefore, these variables need to be harmonized.

``` r

unlist(subset_example_metadata$valid_labels[2])
#>     Tend to trust Tend not to trust                DK 
#>                 1                 2                 3
unlist(subset_example_metadata$na_labels[2])
#> numeric(0)
```

The metadata created by the
[`metadata_create()`](https://ropengov.github.io/retroharmonize/reference/metadata_create.md)
and its version for multiple surveys, `metadata_create`, gives a first
overview for the harmonization of concepts, the necessary harmonization
of variable names and variable labels. In this case:

- Variable name harmonization is required: For a successful join, you
  must use a common name for `qa10_1` and `qa14_1`, for example,
  `trust_european_parliament`, because the variable refers to the same
  concept.
- Variable label harmonization is required: You must make sure that the
  variable has three categories, even if one category, `Declined` (to
  answer) is missing from `ZA5913.rds`.
- Type harmonization is needed: For various statistical procedures you
  must convert the concatenated contents of `qa10_1` and `qa14_1` into a
  numerical variable or factor variable. It is practical to use *1=“Tend
  to Trust”*, *0=“Tend not to trust”* for calculating the percentage of
  people trusting the European Parliament, making sure that Decline will
  get a `NA_real_` value for averaging, or creating a factor variable
  with three levels, for example *trust*, *not_trust*, *declined*.
