# Subset and optionally harmonize surveys

Subset one or more surveys by retaining a specified set of variables.
Subsetting can be performed either on surveys already loaded in memory
or directly from survey files on disk.

If a crosswalk table is supplied, variables are selected based on the
variables listed for each survey in the crosswalk, and variable names
can optionally be harmonized using \`var_name_target\`.

This function replaces the deprecated helpers \[subset_waves()\] and
\[subset_save_surveys()\].

## Usage

``` r
subset_surveys(
  survey_list,
  survey_paths = NULL,
  rowid = "rowid",
  subset_name = "subset",
  subset_vars = NULL,
  crosswalk_table = NULL,
  import_path = NULL,
  export_path = NULL
)

subset_waves(waves, subset_vars = NULL)

subset_save_surveys(
  crosswalk_table,
  subset_name = "subset",
  survey_list = NULL,
  subset_vars = NULL,
  survey_paths = NULL,
  import_path = NULL,
  export_path = NULL
)
```

## Arguments

- survey_list:

  A list of survey objects created by \[read_surveys()\]. If \`NULL\`,
  surveys are read from disk.

- survey_paths:

  A character vector of full file paths to survey files. Used when
  \`survey_list\` is \`NULL\`.

- rowid:

  Name of the unique observation identifier column. Defaults to
  \`"rowid"\`.

- subset_name:

  Character string appended to filenames of subsetted surveys. Defaults
  to \`"subset"\`.

- subset_vars:

  Character vector of variable names to retain. If \`NULL\`, all
  variables are retained.

- crosswalk_table:

  Optional crosswalk table created with \[crosswalk_table_create()\]. If
  supplied, variables are selected per survey based on
  \`var_name_orig\`, and variable names may be harmonized using
  \`var_name_target\`.

- import_path:

  Optional directory containing survey files. Used to resolve filenames
  when subsetting from disk.

- export_path:

  Optional directory where subsetted surveys are saved as \`.rds\`
  files. If \`NULL\`, surveys are returned in memory.

- waves:

  A list of surveys imported with \[read_surveys()\].

## Value

Either: \* a list of subsetted survey objects (if \`export_path =
NULL\`), or \* a character vector of filenames written to
\`export_path\`.

## Details

The function supports multiple workflows:

\* \*\*In-memory subsetting\*\* using \`survey_list\` \* \*\*File-based
subsetting\*\* using \`survey_paths\` or \`import_path\` \*
\*\*Crosswalk-driven subsetting\*\*, where variables are selected per
survey using a crosswalk table created by \[crosswalk_table_create()\]

If \`export_path\` is provided, subsetted surveys are written to disk as
\`.rds\` files. Otherwise, subsetted surveys are returned in memory.

## See also

\[crosswalk_table_create()\], \[harmonize_survey_variables()\],
\[read_surveys()\]

## Examples

``` r
examples_dir <- system.file("examples", package = "retroharmonize")
survey_files <- dir(examples_dir, pattern = "\\.rds$")

surveys <- read_surveys(
  file.path(examples_dir, survey_files),
  export_path = NULL
)

subset_surveys(
  survey_list = surveys,
  subset_vars = c("rowid", "isocntry", "qa10_1", "qa14_1"),
  subset_name = "example_subset"
)
#> [[1]]
#> Unknown (2026): Untitled Dataset [dataset]
#>    rowid     isocntry qa10_1                
#>    <chr>     <chr>    <dbl+lbl>            
#>  1 ZA5913_1  NL       2 [Tend not to trust]
#>  2 ZA5913_2  NL       2 [Tend not to trust]
#>  3 ZA5913_3  NL       3 (NA) [DK]          
#>  4 ZA5913_4  NL       1 [Tend to trust]    
#>  5 ZA5913_5  NL       1 [Tend to trust]    
#>  6 ZA5913_6  NL       1 [Tend to trust]    
#>  7 ZA5913_7  NL       1 [Tend to trust]    
#>  8 ZA5913_8  NL       1 [Tend to trust]    
#>  9 ZA5913_9  NL       2 [Tend not to trust]
#> 10 ZA5913_10 NL       2 [Tend not to trust]
#> # ℹ 25 more rows 
#> 
#> [[2]]
#> Unknown (2026): Untitled Dataset [dataset]
#>    rowid     isocntry qa14_1                
#>    <chr>     <chr>    <dbl+lbl>            
#>  1 ZA6863_1  NL       3 [DK]               
#>  2 ZA6863_2  NL       1 [Tend to trust]    
#>  3 ZA6863_3  NL       3 [DK]               
#>  4 ZA6863_4  NL       1 [Tend to trust]    
#>  5 ZA6863_5  NL       1 [Tend to trust]    
#>  6 ZA6863_6  NL       2 [Tend not to trust]
#>  7 ZA6863_7  NL       1 [Tend to trust]    
#>  8 ZA6863_8  NL       3 [DK]               
#>  9 ZA6863_9  NL       1 [Tend to trust]    
#> 10 ZA6863_10 NL       1 [Tend to trust]    
#> # ℹ 40 more rows 
#> 
#> [[3]]
#> Unknown (2026): Untitled Dataset [dataset]
#>    rowid     isocntry qa14_1                
#>    <chr>     <chr>    <dbl+lbl>            
#>  1 ZA7576_1  ES       2 [Tend not to trust]
#>  2 ZA7576_2  NL       1 [Tend to trust]    
#>  3 ZA7576_3  NL       1 [Tend to trust]    
#>  4 ZA7576_4  NL       2 [Tend not to trust]
#>  5 ZA7576_5  NL       1 [Tend to trust]    
#>  6 ZA7576_6  NL       1 [Tend to trust]    
#>  7 ZA7576_7  NL       1 [Tend to trust]    
#>  8 ZA7576_8  NL       3 [DK]               
#>  9 ZA7576_9  NL       2 [Tend not to trust]
#> 10 ZA7576_10 NL       2 [Tend not to trust]
#> # ℹ 35 more rows 
#> 
```
