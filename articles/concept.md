# Harmonizing Concepts, Questions, and Variables

``` r

library(retroharmonize)
library(dplyr)
```

The first step of retrospective harmonization is finding the relevant
concepts, operationalized in questions that need to be harmonized among
two or more surveys.

## Concept

## Questions

``` r

examples_dir <- system.file("examples", package = "retroharmonize")
survey_files <- dir(examples_dir)[grepl("\\.rds", dir(examples_dir))]
survey_files
#> [1] "ZA5913.rds" "ZA6863.rds" "ZA7576.rds"
```

``` r

survey_paths <- file.path(examples_dir, survey_files)
```

With smaller data frames representing your surveys, the most efficient
way to work with the information is to read them into a list of surveys.

Read the surveys into a list object in the memory:

``` r

example_surveys <- read_surveys(survey_paths, .f = "read_rds")
```

If you may ran out of memory, you can work with files. The advantage of
keeping the surveys in memory is that later it will be much faster to
continue working with them, but from the metadata point of view, the
returned object is the same either way.

``` r

# not evaluated
example_metadata <- metadata_create(survey_paths = survey_paths, .f = "read_rds")
#> Read: /home/runner/work/_temp/Library/retroharmonize/examples/ZA5913.rds
#> Read: /home/runner/work/_temp/Library/retroharmonize/examples/ZA6863.rds
#> Read: /home/runner/work/_temp/Library/retroharmonize/examples/ZA7576.rds
```

Let’s work in the memory now. Map the metadata contents of the files:

``` r

set.seed(2022)
metadata_create(survey_list = example_surveys) %>%
  dplyr::sample_n(12)
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

The current retroharmonize uses the metadata_create() function to
restore the encoded metadata into a tidy table that can be the start of
further steps. This function should be revised after much use, and
brought to a simpler format, and renamed, preferably choosing a DDI
Glossary term. (Ingest? Or just mapping? Should not contain any
tidyverse verbs.) C2: The selected variables from the metadata table
(which needs a better word) we subset the surveys either in memory or,
in case of many files, sequentially from file. This the subset_survey()
function. It will need a thorough upgrade to correctly retain the
attributes of the datacube-inheritted new survey class, but it functions
well.

This stage should be harmonized with the [DDI
Codebook](https://zenodo.org/records/14447460). One problem appears to
me is that DDI calls a “codebook” differently than we do. DDI uses the
term codebook on the level of file (survey), and we use it on the level
of individual observations.

> Codebook: A document that provides information on the structure,
> contents, and layout of a data file. Source: [DDI
> Glossary](https://docs.ddialliance.org/DDI-Codebook/2.5/xmlschema/schemas/codebook_xsd/elements/codeBook.html).

Here is a DDI Codebook example in
[PDF](https://ddialliance.org/hubfs/sites/default/files/National%20Household%20Survey,%202011%20%5BCanada%5D%20Public%20Use%20Microdata%20File%20(PUMF)-%20Individuals%20File.pdf).

Because normally we want to use standardized codes, and we started to
harmonize with the SDMX statistical metadata standard, a good resolution
seems to be to differentiate between a Codebook (DDI term) and a
Codelist (SDMX term, but I am sure it has a more general RDF
definition.)

We roughly have a DDI Codebook regarding the concepts and question
items, but the number of Valid and Invalid responses were not collected
at ingestion:

``` r

set.seed(12)
example_metadata %>%
  select(
    Filename = .data$filename,
    Name = .data$var_name_orig,
    Label = .data$var_label_orig,
    Type = .data$class_orig,
    Format = .data$labels
  ) %>%
  mutate(
    Valid = NA_real_,
    Invalid = NA_real_,
    Question = NA_character_
  ) %>%
  sample_n(12)
#> Warning: Use of .data in tidyselect expressions was deprecated in tidyselect 1.2.0.
#> ℹ Please use `"filename"` instead of `.data$filename`
#> This warning is displayed once per session.
#> Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
#> generated.
#> Warning: Use of .data in tidyselect expressions was deprecated in tidyselect 1.2.0.
#> ℹ Please use `"var_name_orig"` instead of `.data$var_name_orig`
#> This warning is displayed once per session.
#> Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
#> generated.
#> Warning: Use of .data in tidyselect expressions was deprecated in tidyselect 1.2.0.
#> ℹ Please use `"var_label_orig"` instead of `.data$var_label_orig`
#> This warning is displayed once per session.
#> Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
#> generated.
#> Warning: Use of .data in tidyselect expressions was deprecated in tidyselect 1.2.0.
#> ℹ Please use `"class_orig"` instead of `.data$class_orig`
#> This warning is displayed once per session.
#> Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
#> generated.
#> Warning: Use of .data in tidyselect expressions was deprecated in tidyselect 1.2.0.
#> ℹ Please use `"labels"` instead of `.data$labels`
#> This warning is displayed once per session.
#> Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
#> generated.
#>      Filename     Name                                      Label
#> 1  ZA7576.rds   caseid            kantar_case_id_country_specific
#> 2  ZA6863.rds   qd7.12 important_values_pers_respect_for_cultures
#> 3  ZA7576.rds serialid         serial_case_id_appointed_by_kantar
#> 4  ZA6863.rds    qd7.1          important_values_pers_rule_of_law
#> 5  ZA5913.rds   qd3_13           important_values_pers_none_spont
#> 6  ZA7576.rds       w1      weight_result_from_target_redressment
#> 7  ZA6863.rds   qd7.14                   important_values_pers_dk
#> 8  ZA7576.rds    qd6.4   important_values_pers_individual_freedom
#> 9  ZA7576.rds   qa6b_3   trust_in_institutions_united_nations_tcc
#> 10 ZA6863.rds    rowid               unique_identifier_in_za_6863
#> 11 ZA7576.rds  qa6a_10       trust_in_institutions_european_union
#> 12 ZA7576.rds   qa14_1                  european_parliament_trust
#>                   Type     Format Valid Invalid Question
#> 1              numeric         NA    NA      NA     <NA>
#> 2       haven_labelled       0, 1    NA      NA     <NA>
#> 3              numeric         NA    NA      NA     <NA>
#> 4       haven_labelled       0, 1    NA      NA     <NA>
#> 5       haven_labelled       0, 1    NA      NA     <NA>
#> 6              numeric         NA    NA      NA     <NA>
#> 7       haven_labelled       0, 1    NA      NA     <NA>
#> 8  haven_labelled_spss    0, 1, 9    NA      NA     <NA>
#> 9  haven_labelled_spss 1, 2, 3, 9    NA      NA     <NA>
#> 10           character         NA    NA      NA     <NA>
#> 11 haven_labelled_spss 1, 2, 3, 9    NA      NA     <NA>
#> 12 haven_labelled_spss 1, 2, 3, 9    NA      NA     <NA>
```

The DDI Codebook is however, a lot more, because it contains
survey-level metadata that we did not use in retroharmonize so far. We
assumed that the user (researcher) did a comparison of sampling methods,
collection modes, etc, which are all part of the DDI Codebook standard.

It would be very easy to write a codebook_create() function that would
create a partial DDI codebook as a component of a future DDI Codebook
function codebook_create_ddi() and keep working with this.

However, we have a problem, the current, released retroharmonize has a
more complex
[`create_codebook()`](https://ropengov.github.io/retroharmonize/reference/create_codebook.md)
function. This should be depracted.

``` r

set.seed(12)
my_codebook <- create_codebook(
  survey = read_rds(
    system.file("examples", "ZA7576.rds",
      package = "retroharmonize"
    )
  )
)

sample_n(my_codebook, 12)
#> # A tibble: 12 × 12
#>    entry id     filename   var_name_orig var_label_orig            val_code_orig
#>    <int> <chr>  <chr>      <chr>         <chr>                     <chr>        
#>  1    30 ZA7576 ZA7576.rds qa6a_4        trust_in_institutions_po… 1            
#>  2    12 ZA7576 ZA7576.rds nuts          region_nuts_codes         TR82         
#>  3    12 ZA7576 ZA7576.rds nuts          region_nuts_codes         TR41         
#>  4    12 ZA7576 ZA7576.rds nuts          region_nuts_codes         LV005        
#>  5    12 ZA7576 ZA7576.rds nuts          region_nuts_codes         FR23         
#>  6    30 ZA7576 ZA7576.rds qa6a_4        trust_in_institutions_po… 9            
#>  7    12 ZA7576 ZA7576.rds nuts          region_nuts_codes         AL033        
#>  8    36 ZA7576 ZA7576.rds qa6b_3        trust_in_institutions_un… 3            
#>  9    12 ZA7576 ZA7576.rds nuts          region_nuts_codes         EL13         
#> 10    12 ZA7576 ZA7576.rds nuts          region_nuts_codes         BE35         
#> 11    12 ZA7576 ZA7576.rds nuts          region_nuts_codes         BE21         
#> 12    13 ZA7576 ZA7576.rds d7            marital_status            8            
#> # ℹ 6 more variables: val_label_orig <chr>, label_range <chr>,
#> #   na_range <named list>, n_labels <dbl>, n_valid_labels <dbl>,
#> #   n_na_labels <dbl>
```

## Reproducible research tasks

The tasks that we do with this information is variable name and variable
label harmonization.

``` r

metadata <- metadata_create(example_surveys)
metadata$var_name_suggested <- label_normalize(metadata$var_name)
metadata$var_name_suggested[metadata$label_orig == "age_education"] <- "age_education"

harmonized_example_surveys <- harmonize_var_names(
  survey_list = example_surveys,
  metadata = metadata
)

lapply(harmonized_example_surveys, names)
#> [[1]]
#>  [1] "rowid"    "doi"      "version"  "uniqid"   "isocntry" "p1"      
#>  [7] "p3"       "p4"       "nuts"     "d7"       "d8"       "d25"     
#> [13] "d60"      "qa10_3"   "qa10_2"   "qa10_1"   "qa7_4"    "qa7_2"   
#> [19] "qa7_3"    "qa7_1"    "qa7_5"    "qd3_1"    "qd3_2"    "qd3_3"   
#> [25] "qd3_4"    "qd3_5"    "qd3_6"    "qd3_7"    "qd3_8"    "qd3_9"   
#> [31] "qd3_10"   "qd3_11"   "qd3_12"   "qd3_13"   "qd3_14"   "w1"      
#> [37] "w3"      
#> 
#> [[2]]
#>  [1] "rowid"    "doi"      "version"  "uniqid"   "serialid" "isocntry"
#>  [7] "p1"       "p2"       "p3"       "p4"       "nuts"     "d7"      
#> [13] "d8"       "d25"      "d60"      "qa14_3"   "qa14_2"   "qa14_1"  
#> [19] "qa8a_3"   "qa8a_9"   "qa8b_2"   "qa8a_1"   "qa8a_7"   "qa8a_8"  
#> [25] "qa8a_2"   "qa8a_5"   "qa8b_1"   "qa8a_4"   "qa8a_6"   "qa8a_10" 
#> [31] "qa8b_3"   "qd7 1"    "qd7 2"    "qd7 3"    "qd7 4"    "qd7 5"   
#> [37] "qd7 6"    "qd7 7"    "qd7 8"    "qd7 9"    "qd7 10"   "qd7 11"  
#> [43] "qd7 12"   "qd7 13"   "qd7 14"   "w1"       "w3"       "wex"     
#> 
#> [[3]]
#>  [1] "rowid"    "doi"      "version"  "uniqid"   "caseid"   "serialid"
#>  [7] "isocntry" "p1"       "p2"       "p3"       "p4"       "nuts"    
#> [13] "d7"       "d8"       "d25"      "d60"      "qa14_5"   "qa14_3"  
#> [19] "qa14_2"   "qa14_4"   "qa14_1"   "qa6a_5"   "qa6a_10"  "qa6b_2"  
#> [25] "qa6a_3"   "qa6a_1"   "qa6b_4"   "qa6a_8"   "qa6a_9"   "qa6a_4"  
#> [31] "qa6a_2"   "qa6b_1"   "qa6a_6"   "qa6a_7"   "qa6a_11"  "qa6b_3"  
#> [37] "qd6 1"    "qd6 2"    "qd6 3"    "qd6 4"    "qd6 5"    "qd6 6"   
#> [43] "qd6 7"    "qd6 8"    "qd6 9"    "qd6 10"   "qd6 11"   "qd6 12"  
#> [49] "qd6 13"   "qd6 14"   "qg1b"     "qg8"      "w1"       "w3"      
#> [55] "wex"
```

There is, however, an important extra step, what the DDI codebook calls
Type and Format matching. This is software/computer language dependent,
but our codebook could easily accommodate this with containing the
generic DDI Codebook

``` r

data.frame(
  Type = rep("discrete", 3),
  Format = c("numeric-1.0", "numeric-2.0", "numeric-6.0"),
  r_type = rep("integer", 3),
  range = c("0..9", "10..99", "100000..999999")
) %>% knitr::kable()
```

| Type     | Format      | r_type  | range          |
|:---------|:------------|:--------|:---------------|
| discrete | numeric-1.0 | integer | 0..9           |
| discrete | numeric-2.0 | integer | 10..99         |
| discrete | numeric-6.0 | integer | 100000..999999 |

These variables can be mapped either to our
[labelled_spss_survey](https://retroharmonize.dataobservatory.eu/articles/labelled_spss_survey.html)
class or Adrian Dusa’s
[declared](https://github.com/dusadrian/declared).

Considerations: - The *labelled_spss_survey* or *declared* is necessary
because R does not have a missing case identifier that can distinguish
declined answers or answers that were not collected. - There must be a
clear coercion (without “lazy” and ambiguous coercion) to at least R
integer, numeric, character or factor classes for further use in R’s
statistical functions or visualization functions. - Integers can easily
be coerced into characters, but this is not necessarily a good idea,
because some functions anyway want a numeric input, and characters
require a lot more space to be stored in memory or in a file.

``` r

as.integer(1982)
#> [1] 1982
as.character(as.integer(1982))
#> [1] "1982"
```

we can assume that we only use integer representation for coded
questionnaire items, but we still may have open text responses or
observation identifiers that are character vectors. It is likely that
the use of character-represented identifiers is a better idea in later
stages. So we must work with a class that can be converted (coerced)
into both integer (numeric) and character formats.

The choice has profound consequences for variable label harmonization
and the harmonization of codelists, but not at the level of concepts,
questions and codebooks.

``` r

data.frame(
  Type = rep("discrete", 3),
  Format = c("numeric-1.0", "numeric-2.0", "numeric-6.0"),
  r_type = rep("declared", 3),
  range = c("Male|Female|DK", "10..99", "100000..999999")
) %>% knitr::kable()
```

| Type     | Format      | r_type   | range            |
|:---------|:------------|:---------|:-----------------|
| discrete | numeric-1.0 | declared | Male\|Female\|DK |
| discrete | numeric-2.0 | declared | 10..99           |
| discrete | numeric-6.0 | declared | 100000..999999   |

## Question Banks

Question banks contain information about questions asked about the same
concepts in different surveys.

“Using DDI as a foundation for a question bank enables you to reuse
metadata and to find identical and similar questions and or response
sets across surveys for purposes of data comparison, harmonization, or
new questionnaire development.”

[Create a Question Bank](https://ddialliance.org/create-a-codebook)

**Social Science Variables Database**: (located at ICPSR) Search over 4
million variables. Also able to compare questions across studies and
series. <https://www.icpsr.umich.edu/sites/icpsr/find-data>

**UK Data Service Variable and Question Bank**: Search hundreds of
surveys.
<https://datacatalogue.ukdataservice.ac.uk/searchresults?sort=2&tab=3>

**Survey Data Netherlands**: Over 36,000 questions to search.
<https://surveydata.nl>

Obviously we should facilitate the use of existing question banks, and
create question banks that interoperable with existing ones.

Let’s take a look at concerts in the Eurobarometer series.
<https://www.icpsr.umich.edu/web/ICPSR/series/26/variables?q=concert>
Here is the variable that we use in our use case:
<https://www.icpsr.umich.edu/web/ICPSR/studies/35505/datasets/0001/variables/QB1_4?archive=icpsr>

A short caveat: the questionnaire item may or may not be copyright
protected. The reuse of the questionnaire requires further research.

Here we have Values (1…5) and their labels (Not in the last 12 months,
1-2 times, etc)

- We must clarify with Eurobarometer, Afrobarometer, etc, if we can
  reuse their questions in question banks, and are researchers to use it
  in harmonized surveys?

The question bank information already contains information for the next
step, the harmonization of value labels and codelists not covered in
this vignette.

## Literature review

- Standard view in the literature on concept and question harmonization.
  Any difference with ex ante and ex post harmonization?
- Comparison of the DDI Constructs: Concept, Question — correctly
  representing this in our function descriptions and vignettes.

## Coding tasks {#concept=coding}

We should follow the [rOpenSci Packages: Development, Maintenance, and
Peer Review](https://devguide.ropensci.org/) for future changes. In
designing and deprecating functions, the relevant parts are

- [1.3.1 Function and argument
  naming](https://devguide.ropensci.org/building.html#function-and-argument-naming)
- [15 Package evolution - changing stuff in your
  package](https://devguide.ropensci.org/evolution.html)

1.  [`create_codebook()`](https://ropengov.github.io/retroharmonize/reference/create_codebook.md)
    will be deprecated, luckily, it does not meet the rOpenSci
    object_verb suggestion.
2.  `codebook_create()` will create a DDI-Codebook compatible, partial
    codebook, only covering tasks that are relevant for retroharmonize.
    The core of the codebook will be compatible with DDI-Codebook, but
    further information about the R specific implementation of the
    codebook will be added.
3.  `codebook_export_ddi()` will add further data (whatever we have but
    do not use) to make a more complete, but not necessarily complete
    DDI Codebook object. \[Not a high priority now.\]
