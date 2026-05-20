# Working with a Crosswalk Table

``` r

library(retroharmonize)
#> Warning: S3 methods 'vec_cast.retroharmonize_labelled_spss_survey',
#> 'vec_ptype2.retroharmonize_labelled_spss_survey' were declared in NAMESPACE but
#> not found
library(dplyr)
```

Let’s read in the package’s small examples, and create a metadata table
from them. These steps were explained in the vignette [Working With
Survey
Metadata](https://retroharmonize.dataobservatory.eu/articles/metadata.html).

From a technical perspective, the aim of the survey harmonization is to
create a single, tidy, joined table in the form of a data frame that
contains a row identifier, which is truly unique across all observations
and the concatenated and harmonized variables.

``` r

examples_dir <- system.file("examples", package = "retroharmonize")
survey_files <- dir(examples_dir)[grepl("\\.rds", dir(examples_dir))]
survey_files
#> [1] "ZA5913.rds" "ZA6863.rds" "ZA7576.rds"
```

``` r

survey_paths <- file.path(examples_dir, survey_files)
```

``` r

example_metadata <- metadata_create(survey_paths = survey_paths)
#> Read: /home/runner/work/_temp/Library/retroharmonize/examples/ZA5913.rds
#> Read: /home/runner/work/_temp/Library/retroharmonize/examples/ZA6863.rds
#> Read: /home/runner/work/_temp/Library/retroharmonize/examples/ZA7576.rds
```

## Crosswalk Table

A schema crosswalk, or a crosswalk table is a table that shows
equivalent elements (or “fields”) in more than one survey. In this
example, we will create a crosswalk table of a subset of the tree
example surveys. We will use three variables: the unique row identifier,
the Trust in the European Parliament concept, and the country code.

By filtering out the other variables, we have the basic information in
our metadata table.

``` r

subset_example_metadata <- example_metadata %>%
  filter(grepl("^unique_identifier_in|trust|country_code", var_label_orig)) %>%
  filter(grepl(
    "^unique_identifier_in|european_parliament|country_code",
    var_label_orig
  )) %>%
  filter(var_name_orig != "uniqid")

subset_example_metadata
#>     filename     id var_name_orig          class_orig
#> 1 ZA5913.rds ZA5913         rowid           character
#> 2 ZA5913.rds ZA5913      isocntry           character
#> 3 ZA5913.rds ZA5913        qa10_1 haven_labelled_spss
#> 4 ZA6863.rds ZA6863         rowid           character
#> 5 ZA6863.rds ZA6863      isocntry           character
#> 6 ZA6863.rds ZA6863        qa14_1      haven_labelled
#> 7 ZA7576.rds ZA7576         rowid           character
#> 8 ZA7576.rds ZA7576      isocntry           character
#> 9 ZA7576.rds ZA7576        qa14_1 haven_labelled_spss
#>                 var_label_orig     labels valid_labels na_labels na_range
#> 1 unique_identifier_in_za_5913         NA           NA        NA       NA
#> 2        country_code_iso_3166         NA           NA        NA       NA
#> 3    european_parliament_trust    1, 2, 3         1, 2         3       NA
#> 4 unique_identifier_in_za_6863         NA           NA        NA       NA
#> 5        country_code_iso_3166         NA           NA        NA       NA
#> 6    european_parliament_trust    1, 2, 3      1, 2, 3                 NA
#> 7 unique_identifier_in_za_7576         NA           NA        NA       NA
#> 8        country_code_iso_3166         NA           NA        NA       NA
#> 9    european_parliament_trust 1, 2, 3, 9      1, 2, 3         9       NA
#>   n_labels n_valid_labels n_na_labels
#> 1        0              0           0
#> 2        0              0           0
#> 3        3              2           1
#> 4        0              0           0
#> 5        0              0           0
#> 6        3              3           0
#> 7        0              0           0
#> 8        0              0           0
#> 9        4              3           1
```

### Create a crosswalk table

You can easily create a crosswalk table with
[`crosswalk_table_create()`](https://ropengov.github.io/retroharmonize/reference/crosswalk_table_create.md).
Crosswalk tables are validated with `is.crosswalk()`. You can create or
modify your own crosswalk table in any spreadsheet program. The
mandatory elements of a crosswalk table are

- `id`: a unique identifier for a survey
- `filename`: the original source data file
- `var_name_orig`: the original variable name at source
- `var_name_target`: the original variable name after using the
  crosswalk, by default, it equal to `var_name_orig`.

All other columns are optional because they are needed for specific
tasks, namely to change the numeric coding and labelling of valid and
special survey response values, or to harmonize the eventual R type
representation of the data.

``` r

ct <- crosswalk_table_create(subset_example_metadata)
ct
#> # A tibble: 16 × 16
#>    id     filename   var_name_orig var_name_target val_numeric_orig
#>    <chr>  <chr>      <chr>         <chr>                      <dbl>
#>  1 ZA5913 ZA5913.rds rowid         rowid                         NA
#>  2 ZA5913 ZA5913.rds isocntry      isocntry                      NA
#>  3 ZA5913 ZA5913.rds qa10_1        qa10_1                         1
#>  4 ZA5913 ZA5913.rds qa10_1        qa10_1                         2
#>  5 ZA5913 ZA5913.rds qa10_1        qa10_1                         3
#>  6 ZA6863 ZA6863.rds rowid         rowid                         NA
#>  7 ZA6863 ZA6863.rds isocntry      isocntry                      NA
#>  8 ZA6863 ZA6863.rds qa14_1        qa14_1                         1
#>  9 ZA6863 ZA6863.rds qa14_1        qa14_1                         2
#> 10 ZA6863 ZA6863.rds qa14_1        qa14_1                         3
#> 11 ZA7576 ZA7576.rds rowid         rowid                         NA
#> 12 ZA7576 ZA7576.rds isocntry      isocntry                      NA
#> 13 ZA7576 ZA7576.rds qa14_1        qa14_1                         1
#> 14 ZA7576 ZA7576.rds qa14_1        qa14_1                         2
#> 15 ZA7576 ZA7576.rds qa14_1        qa14_1                         3
#> 16 ZA7576 ZA7576.rds qa14_1        qa14_1                         9
#> # ℹ 11 more variables: val_numeric_target <dbl>, val_label_orig <chr>,
#> #   val_label_target <chr>, class_orig <chr>, class_target <chr>,
#> #   na_label_orig <chr>, na_label_target <chr>, na_numeric_orig <dbl>,
#> #   na_numeric_target <dbl>, var_label_orig <chr>, var_label_target <chr>
```

### Variable name harmonization

The harmonization of the variable names requires a single, unambiguous
name for the variables that represent the same concept:

``` r

ct %>%
  mutate(var_name_target = case_when(
    var_name_orig == "rowid" ~ .data$var_name_orig,
    var_name_orig == "isocntry" ~ "geo",
    TRUE ~ "trust_ep"
  )) %>%
  distinct(across(all_of(c("filename", "var_name_orig", "var_name_target"))))
#> # A tibble: 9 × 3
#>   filename   var_name_orig var_name_target
#>   <chr>      <chr>         <chr>          
#> 1 ZA5913.rds rowid         rowid          
#> 2 ZA5913.rds isocntry      geo            
#> 3 ZA5913.rds qa10_1        trust_ep       
#> 4 ZA6863.rds rowid         rowid          
#> 5 ZA6863.rds isocntry      geo            
#> 6 ZA6863.rds qa14_1        trust_ep       
#> 7 ZA7576.rds rowid         rowid          
#> 8 ZA7576.rds isocntry      geo            
#> 9 ZA7576.rds qa14_1        trust_ep
```

### Value numeric code and label harmonization

For code and label harmonization, the crosswalk table should optionally
contain instructions on harmonizing the numeric value codes and value
labels.

- The
  [`crosswalk_table_create()`](https://ropengov.github.io/retroharmonize/reference/crosswalk_table_create.md)
  will create identical source and target columns for labeling (and type
  setting.)
- You can save this table into `.csv` or `.xls` and edit it in a
  spreadsheet application if you want. If you do not change the default
  values (`source`=`target`) then the harmonization in those aspects
  will not take place.

In this example, for full reproducability, we do not work in a
spreadsheet program like Excel or Numbers or OpenOffice but we create
programatically an unambiguous coding. To be on the safe side, the
special missing value is placed far away from the normal values.

``` r

ct %>%
  mutate(val_numeric_target = case_when(
    val_numeric_orig == 1 ~ .data$val_numeric_orig,
    val_numeric_orig == 2 ~ 0,
    TRUE ~ 99999
  )) %>%
  mutate(val_label_target = case_when(
    val_numeric_orig == 1 ~ "trust",
    val_numeric_orig == 2 ~ "distrust",
    TRUE ~ "declined"
  )) %>%
  distinct(across(all_of(c(
    "filename",
    "val_numeric_orig", "val_numeric_target",
    "val_label_orig", "val_label_target"
  ))))
#> # A tibble: 13 × 5
#>    filename  val_numeric_orig val_numeric_target val_label_orig val_label_target
#>    <chr>                <dbl>              <dbl> <chr>          <chr>           
#>  1 ZA5913.r…               NA              99999 NA             declined        
#>  2 ZA5913.r…                1                  1 Tend to trust  trust           
#>  3 ZA5913.r…                2                  0 Tend not to t… distrust        
#>  4 ZA5913.r…                3              99999 DK             declined        
#>  5 ZA6863.r…               NA              99999 NA             declined        
#>  6 ZA6863.r…                1                  1 Tend to trust  trust           
#>  7 ZA6863.r…                2                  0 Tend not to t… distrust        
#>  8 ZA6863.r…                3              99999 DK             declined        
#>  9 ZA7576.r…               NA              99999 NA             declined        
#> 10 ZA7576.r…                1                  1 Tend to trust  trust           
#> 11 ZA7576.r…                2                  0 Tend not to t… distrust        
#> 12 ZA7576.r…                3              99999 DK             declined        
#> 13 ZA7576.r…                9              99999 Inap. (not CY… declined
```

And now let’s turn our attention to the special (missing) cases.
Sometimes there may be other special cases in the code range, but the
most likely suspects are values that represent some form of missing
answers to a question or a missing questionnaire item selection.

``` r

ct %>%
  mutate(na_numeric_target = case_when(
    na_numeric_orig == 3 ~ 99999,
    TRUE ~ NA_real_
  )) %>%
  mutate(na_label_target = case_when(
    na_numeric_target == 99999 ~ "declined",
    TRUE ~ NA_character_
  )) %>%
  distinct(across(all_of(c(
    "filename", "val_numeric_orig",
    "na_numeric_orig", "na_numeric_target",
    "na_label_orig", "na_label_target"
  ))))
#> # A tibble: 13 × 6
#>    filename   val_numeric_orig na_numeric_orig na_numeric_target na_label_orig  
#>    <chr>                 <dbl>           <dbl>             <dbl> <chr>          
#>  1 ZA5913.rds               NA              NA                NA NA             
#>  2 ZA5913.rds                1              NA                NA NA             
#>  3 ZA5913.rds                2              NA                NA NA             
#>  4 ZA5913.rds                3               3             99999 DK             
#>  5 ZA6863.rds               NA              NA                NA NA             
#>  6 ZA6863.rds                1              NA                NA NA             
#>  7 ZA6863.rds                2              NA                NA NA             
#>  8 ZA6863.rds                3              NA                NA NA             
#>  9 ZA7576.rds               NA              NA                NA NA             
#> 10 ZA7576.rds                1              NA                NA NA             
#> 11 ZA7576.rds                2              NA                NA NA             
#> 12 ZA7576.rds                3              NA                NA NA             
#> 13 ZA7576.rds                9               9                NA Inap. (not CY-…
#> # ℹ 1 more variable: na_label_target <chr>
```

### A reproducible recoding and relabelling

Let’s put the entire process into a tidyverse pipeline with
[dplyr](https://dplyr.tidyverse.org/):

``` r

example_crosswalk_table <- ct %>%
  mutate(var_name_target = case_when(
    var_name_orig == "rowid" ~ .data$var_name_orig,
    var_name_orig == "isocntry" ~ "geo",
    TRUE ~ "trust_ep"
  )) %>%
  mutate(val_numeric_target = case_when(
    val_numeric_orig == 1 ~ .data$val_numeric_orig,
    val_numeric_orig == 2 ~ 0,
    TRUE ~ 99999
  )) %>%
  mutate(val_label_target = case_when(
    val_numeric_orig == 1 ~ "trust",
    val_numeric_orig == 2 ~ "distrust",
    TRUE ~ "declined"
  )) %>%
  mutate(na_numeric_target = case_when(
    na_numeric_orig == 3 ~ 99999,
    TRUE ~ NA_real_
  )) %>%
  mutate(na_label_target = case_when(
    na_numeric_target == 99999 ~ "declined",
    TRUE ~ NA_character_
  ))

example_crosswalk_table
#> # A tibble: 16 × 16
#>    id     filename   var_name_orig var_name_target val_numeric_orig
#>    <chr>  <chr>      <chr>         <chr>                      <dbl>
#>  1 ZA5913 ZA5913.rds rowid         rowid                         NA
#>  2 ZA5913 ZA5913.rds isocntry      geo                           NA
#>  3 ZA5913 ZA5913.rds qa10_1        trust_ep                       1
#>  4 ZA5913 ZA5913.rds qa10_1        trust_ep                       2
#>  5 ZA5913 ZA5913.rds qa10_1        trust_ep                       3
#>  6 ZA6863 ZA6863.rds rowid         rowid                         NA
#>  7 ZA6863 ZA6863.rds isocntry      geo                           NA
#>  8 ZA6863 ZA6863.rds qa14_1        trust_ep                       1
#>  9 ZA6863 ZA6863.rds qa14_1        trust_ep                       2
#> 10 ZA6863 ZA6863.rds qa14_1        trust_ep                       3
#> 11 ZA7576 ZA7576.rds rowid         rowid                         NA
#> 12 ZA7576 ZA7576.rds isocntry      geo                           NA
#> 13 ZA7576 ZA7576.rds qa14_1        trust_ep                       1
#> 14 ZA7576 ZA7576.rds qa14_1        trust_ep                       2
#> 15 ZA7576 ZA7576.rds qa14_1        trust_ep                       3
#> 16 ZA7576 ZA7576.rds qa14_1        trust_ep                       9
#> # ℹ 11 more variables: val_numeric_target <dbl>, val_label_orig <chr>,
#> #   val_label_target <chr>, class_orig <chr>, class_target <chr>,
#> #   na_label_orig <chr>, na_label_target <chr>, na_numeric_orig <dbl>,
#> #   na_numeric_target <dbl>, var_label_orig <chr>, var_label_target <chr>
```

Needless to say that you do not need to work with *dplyr*.

Reading the crosswalk table is very simple, for example, the last two
(15-16) rows read like this:

- In `ZA6863.rds` rename the variable storing questionnaire item
  `qa14_1` to `trust_ep` (`Trust in European Parliament`).  
- Recode the numeric values from `2` to `0` and label them as
  `distrust`.
- Recode the special values from `3` to `99999` and label them as
  `declined`.

### Subsetting

From a technical perspective, the aim of the survey harmonization is to
create a single, tidy, joined table. For making joining possible (and to
reduce memory use), a first processing step is to remove irrelevant
variables that will not be harmonized.

There are several ways how the subsetting can be made. With smaller
tasks all the surveys can be stored in memory and the subsequent
processing made fast in memory. With many surveys, we provide a slower
but memory-saving way of importing and subsetting consecutive surveys
from files.

Recall from the vignette [Working With Survey
Metadata](https://retroharmonize.dataobservatory.eu/articles/metadata.html)
that you can read files into a list of surveys:

``` r

example_surveys <- read_surveys(survey_paths, .f = "read_rds")
```

Now let’s focus of our attention to a small subset of the variables.

``` r

subset_survey_list_1 <- subset_surveys(
  survey_list = example_surveys,
  subset_vars = c("rowid", "isocntry", "qa10_1", "qa14_1"),
  subset_name = "subset_example"
)
```

We still have the three surveys in a list:

``` r

vapply(subset_survey_list_1, function(x) attr(x, "id"), character(1))
#> [1] "ZA5913" "ZA6863" "ZA7576"
```

The top few rows of the first subsetted survey to see if the subsetting
took place:

``` r

head(subset_survey_list_1[[1]])
#> Unknown (2026): Untitled Dataset [dataset]
#>   rowid    isocntry qa10_1                
#>   <chr>    <chr>    <dbl+lbl>            
#> 1 ZA5913_1 NL       2 [Tend not to trust]
#> 2 ZA5913_2 NL       2 [Tend not to trust]
#> 3 ZA5913_3 NL       3 (NA) [DK]          
#> 4 ZA5913_4 NL       1 [Tend to trust]    
#> 5 ZA5913_5 NL       1 [Tend to trust]    
#> 6 ZA5913_6 NL       1 [Tend to trust]
```

While `qa10_1` and `qa14_1` refer to trust in the European Parliament,
they cannot be joined because they have dissimilar names. These names
are not too easy to remember, either.

``` r

lapply(subset_survey_list_1, names)
#> [[1]]
#> [1] "rowid"    "isocntry" "qa10_1"  
#> 
#> [[2]]
#> [1] "rowid"    "isocntry" "qa14_1"  
#> 
#> [[3]]
#> [1] "rowid"    "isocntry" "qa14_1"
```

The next step is to harmonize the names of those variables that
represent the same concept, in this case, *Trust in the European
Parliament*. The next steps, i.e. the harmonization of the numerical
codes of answers and their labels will be discussed in the [Harmonize
Value
Labels](https://retroharmonize.dataobservatory.eu/articles/harmonize_labels.html)
vignette.

## Variable Name Harmonization

It is very practical to do the subsetting and the variable name
harmonization in one step. The
[`subset_save_surveys()`](https://ropengov.github.io/retroharmonize/reference/subset_surveys.md)
function will do this optionally, and a wrapper function
`harmonize_surveys()` will validate that all metadata (i.e. the
original, source variable names and the new, target variable names) are
present.

``` r

subset_survey_list_2 <- subset_surveys(
  crosswalk_table = example_crosswalk_table,
  survey_list = example_surveys,
  subset_name = "trust_ep"
)
```

We have again the three surveys in a list:

``` r

vapply(subset_survey_list_2, function(x) attr(x, "id"), character(1))
#> [1] "ZA5913" "ZA6863" "ZA7576"
```

The top few rows of the first subsetted survey now show that we have
new, harmonized names.

``` r

head(subset_survey_list_2[[1]])
#> Unknown (2026): Untitled Dataset [dataset]
#>   rowid    isocntry qa10_1                
#>   <chr>    <chr>    <dbl+lbl>            
#> 1 ZA5913_1 NL       2 [Tend not to trust]
#> 2 ZA5913_2 NL       2 [Tend not to trust]
#> 3 ZA5913_3 NL       3 (NA) [DK]          
#> 4 ZA5913_4 NL       1 [Tend to trust]    
#> 5 ZA5913_5 NL       1 [Tend to trust]    
#> 6 ZA5913_6 NL       1 [Tend to trust]
```

Our variable names are harmonized:

``` r

lapply(subset_survey_list_2, names)
#> [[1]]
#> [1] "rowid"    "isocntry" "qa10_1"  
#> 
#> [[2]]
#> [1] "rowid"    "isocntry" "qa14_1"  
#> 
#> [[3]]
#> [1] "rowid"    "isocntry" "qa14_1"
```

While this example easily fits in the memory, when working with several
dozens of SPSS files, it is better to sequentially import the surveys
from file, and save the output to files. By default, the parameters
`import_path` and `export_path` are set to `NULL`. If you enter a valid
path to a directory, the function will look for the files specified in
the `crosswalk_table$filename` on this path.

- If you do not specify the `export_path`, a list of surveys will be
  returned.
- If you specify the `export_path`, a vector of the saved file names
  (with full path) will be returned.

The
[`subset_surveys()`](https://ropengov.github.io/retroharmonize/reference/subset_surveys.md)
is a versatile function that fits with several workflows. It works in
memory or with larger tasks, with sequentially read survey files; it for
simple tasks it can use a simple vector for names to keep, or it can use
an entire crosswalk table. You can read more about it with
[`?subset_surveys`](https://ropengov.github.io/retroharmonize/reference/subset_surveys.md).

``` r

subset_surveys(
  survey_list = example_surveys,
  crosswalk_table = example_crosswalk_table,
  subset_name = "trust_ep",
  import_path = examples_dir,
  export_path = tempdir()
)
#> Saving ZA5913_trust_ep.rds
#> Saving ZA6863_trust_ep.rds
#> Saving ZA7576_trust_ep.rds
#> [1] "ZA5913_trust_ep.rds" "ZA6863_trust_ep.rds" "ZA7576_trust_ep.rds"
```

The subsetted surveys are saved with a common name element, `trust_ep`
to the export file location, in this case a temporary directory created
with [`tempdir()`](https://rdrr.io/r/base/tempfile.html).

``` r

readRDS(file.path(tempdir(), "ZA5913_trust_ep.rds")) %>%
  head()
#> Unknown (2026): Untitled Dataset [dataset]
#>   rowid    isocntry qa10_1                
#>   <chr>    <chr>    <dbl+lbl>            
#> 1 ZA5913_1 NL       2 [Tend not to trust]
#> 2 ZA5913_2 NL       2 [Tend not to trust]
#> 3 ZA5913_3 NL       3 (NA) [DK]          
#> 4 ZA5913_4 NL       1 [Tend to trust]    
#> 5 ZA5913_5 NL       1 [Tend to trust]    
#> 6 ZA5913_6 NL       1 [Tend to trust]
```

## Further Steps

Having a subsetted list of surveys with harmonized variable names is
usually not yet an output that is ready for statistical analysis. In the
next step, the numerical codes, the variable labels need to be made
consistent, with a special attention given to special values,
particularly to missing values.

At last, if the statistical analysis will take place in R, a conversion
to basic R classes is necessary to rely on the vast arsenal of R’s
statistical packages. This means that the survey data must be brought to
a consistent numeric or a consistent factor format (and in some cases,
for visualization, to a character format).

We created a special s3 class (see
[`?labelled_spss_survey`](https://ropengov.github.io/retroharmonize/reference/labelled_spss_survey.md)),
which retains the metadata about coding and special values, and created
three methods that take into consideration the retained metadata. For
example, if 999 is the code for declined answers, then the base are
[`as.numeric()`](https://rdrr.io/r/base/numeric.html) will coerce
observations (survey responses) with a value `999` to a numerical value
of `999`, but the
[`as_numeric()`](https://ropengov.github.io/retroharmonize/reference/labelled_spss_survey_coercion.md)
method will give a `NA_real_` representation to this observation.
Averaging numerical, coded values will give a logically wrong result
with the basic as.numeric, but a correct with the
[`as_numeric()`](https://ropengov.github.io/retroharmonize/reference/labelled_spss_survey_coercion.md)
method.

The crosswalk table is a map for value code and label harmonization, and
for type conversion, too. This is the topic of the [Harmonize Value
Labels](https://retroharmonize.dataobservatory.eu/articles/harmonize_labels.html)
vignette.
