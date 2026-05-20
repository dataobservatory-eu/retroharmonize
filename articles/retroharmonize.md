# Getting Started

The retroharmonize package arrives with small subsamples of three
Eurobarometer surveys with a few variables and a limited set of
responses. They are not as interesting as the full datasets – they serve
testing and illustration purposes.

``` r

library(retroharmonize)
#> Warning: S3 methods 'vec_cast.retroharmonize_labelled_spss_survey',
#> 'vec_ptype2.retroharmonize_labelled_spss_survey' were declared in NAMESPACE but
#> not found
```

## Importing data

Survey data, i.e., data derived from questionnaires or systematic data
collection, such as inspecting objects in nature, recording prices at
shops are usually stored databases, and converted to complex files
retaining at least coding, labelling metadata together with the data.
This must be imported to R so that the appropriate harmonization tasks
can be carried out with the appropriate R types.

The survey harmonization almost always requires the work of several
source files. The harmonization of their contents is important because
there the contents of these files do not match, they cannot be joined,
integrated, binded together.

Our importing functions, read_csv, read_rda, read_spss, read_dta are
slightly modify the read.csv, readRDS, and the haven::read_spss,
haven::read_data importing functions. Instead of importing into a
data.frame or a tibble, they import to an inherited data frame called
survey. The survey class works as a data frame, but tries to retain as
much metadata as possible for future harmonization steps and resources
planning—for example, original source file names.

You can find the package illustration files with system.file().

``` r

examples_dir <- system.file("examples", package = "retroharmonize")
survey_files <- dir(examples_dir)[grepl("\\.rds", dir(examples_dir))]
survey_files
#> [1] "ZA5913.rds" "ZA6863.rds" "ZA7576.rds"
```

The read_survey() function calls the appropriate importing function
(based on the file extension of the survey files) and reads the surveys
into list (in memory.) If you work with many files, and you want to keep
working sequentially with survey files, it is a good idea to convert
them to R objects. This is how you would do it with large SPSS or STATA
files.

``` r

example_surveys <- read_surveys(
  file.path(examples_dir, survey_files),
  export_path = tempdir()
)
```

Our example surveys are small and easily fit into the memory.

``` r

example_surveys <- read_surveys(
  survey_paths = file.path(examples_dir, survey_files),
  export_path = NULL
)
```

``` r

ZA5913_survey <- example_surveys[[1]]
# A small subset of this survey
head(ZA5913_survey[, c(1, 4, 5, 34)])
#> Unknown (2026): Untitled Dataset [dataset]
#>   rowid      uniqid isocntry qd3_13            
#>   <chr>       <dbl> <chr>    <dbl+lbl>        
#> 1 ZA5913_1 11339367 NL       0 [Not mentioned]
#> 2 ZA5913_2 11339664 NL       0 [Not mentioned]
#> 3 ZA5913_3 11339746 NL       0 [Not mentioned]
#> 4 ZA5913_4 11339759 NL       0 [Not mentioned]
#> 5 ZA5913_5 11339885 NL       0 [Not mentioned]
#> 6 ZA5913_6 11340290 NL       0 [Not mentioned]
```

If you look at the metadata attributes of the ZA5913_survey, you find
more information than in the case of a data.frame or its modernized
version, the tibble. Crucially, it records the source file and creates a
unique table identifier. A further addition is that the first column of
the data.frame is a truly unique observation identifier, rowid. The
rowid is not only unique in this survey, but it is unique in all surveys
that you import in one workflow. For example, if the original surveys
were just simply using an integer id, like uniqid 1….1000, you will run
into problems after joining several surveys.

``` r

attributes(ZA5913_survey)
#> $names
#>  [1] "rowid"    "doi"      "version"  "uniqid"   "isocntry" "p1"      
#>  [7] "p3"       "p4"       "nuts"     "d7"       "d8"       "d25"     
#> [13] "d60"      "qa10_3"   "qa10_2"   "qa10_1"   "qa7_4"    "qa7_2"   
#> [19] "qa7_3"    "qa7_1"    "qa7_5"    "qd3_1"    "qd3_2"    "qd3_3"   
#> [25] "qd3_4"    "qd3_5"    "qd3_6"    "qd3_7"    "qd3_8"    "qd3_9"   
#> [31] "qd3_10"   "qd3_11"   "qd3_12"   "qd3_13"   "qd3_14"   "w1"      
#> [37] "w3"      
#> 
#> $row.names
#>  [1]  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25
#> [26] 26 27 28 29 30 31 32 33 34 35
#> 
#> $dataset_bibentry
#> DataCite Metadata Record
#> --------------------------
#> Title:       Untitled Dataset
#> Creator(s):  Author Unknown
#> Subject(s):  Data sets [http://id.loc.gov/authorities/subjects]
#> Year:        2026
#> Description: :tba
#> 
#> $prov
#> [1] "<http://example.com/dataset_prov.nt> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.w3.org/ns/prov#Bundle> ."                  
#> [2] "<http://example.com/dataset#> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.w3.org/ns/prov#Entity> ."                         
#> [3] "<http://example.com/dataset#> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://purl.org/linked-data/cube#DataSet> ."                 
#> [4] "_:unknownauthor <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.w3.org/ns/prov#Agent> ."                                        
#> [5] "<https://doi.org/10.32614/CRAN.package.dataset> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.w3.org/ns/prov#SoftwareAgent> ."
#> [6] "<http://example.com/creation> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.w3.org/ns/prov#Activity> ."                       
#> [7] "<http://example.com/creation> <http://www.w3.org/ns/prov#generatedAtTime> \"2026-05-20T18:18:49Z\"^^<xsd:dateTime> ."                         
#> 
#> $subject
#> $term
#> [1] "Data sets"
#> 
#> $subjectScheme
#> [1] "LCSH"
#> 
#> $schemeURI
#> [1] "http://id.loc.gov/authorities/subjects"
#> 
#> $valueURI
#> [1] "http://id.loc.gov/authorities/subjects/sh2018002256"
#> 
#> $classificationCode
#> NULL
#> 
#> $prefix
#> [1] "lcsh:"
#> 
#> attr(,"class")
#> [1] "subject" "list"   
#> 
#> $class
#> [1] "survey"     "dataset_df" "tbl_df"     "tbl"        "data.frame"
#> 
#> $id
#> [1] "ZA5913"
#> 
#> $filename
#> [1] "ZA5913.rds"
#> 
#> $doi
#> [1] "doi:10.4232/1.12884"
#> 
#> $object_size
#> [1] 116992
#> 
#> $source_file_size
#> [1] 6507
```

Our example files are lightweight, because they come installed with the
R package. If you work with real-life survey data, and many of them, you
will likely run out of memory soon. Therefore, the critical functions or
retroharmonize are versatile: they either work with a list of surveys,
or with a vector of files. Of course, subsetting or renaming work much
faster in memory, so if your resources are sufficient, you should work
with the survey_list format, like in this importing example. Otherwise,
you can work sequentially with the files, which is a far slower
procedure.

## Mapping information, harmonizing concepts

First, let us check our inventory of surveys.

``` r

document_surveys(survey_paths = file.path(examples_dir, survey_files))
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

This will easily fit into the memory, so let us explore a bit further.

``` r

metadata_create(example_surveys) %>% head()
#>     filename     id var_name_orig     class_orig
#> 1 ZA5913.rds ZA5913         rowid      character
#> 2 ZA5913.rds ZA5913           doi      character
#> 3 ZA5913.rds ZA5913       version      character
#> 4 ZA5913.rds ZA5913        uniqid        numeric
#> 5 ZA5913.rds ZA5913      isocntry      character
#> 6 ZA5913.rds ZA5913            p1 haven_labelled
#>                                    var_label_orig
#> 1                    unique_identifier_in_za_5913
#> 2                       digital_object_identifier
#> 3                  gesis_archive_version_and_date
#> 4 unique_respondent_id_caseid_by_tns_country_code
#> 5                           country_code_iso_3166
#> 6                               date_of_interview
#>                                          labels
#> 1                                            NA
#> 2                                            NA
#> 3                                            NA
#> 4                                            NA
#> 5                                            NA
#> 6 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
#>                                    valid_labels na_labels na_range n_labels
#> 1                                            NA        NA       NA        0
#> 2                                            NA        NA       NA        0
#> 3                                            NA        NA       NA        0
#> 4                                            NA        NA       NA        0
#> 5                                            NA        NA       NA        0
#> 6 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14                 NA       14
#>   n_valid_labels n_na_labels
#> 1              0           0
#> 2              0           0
#> 3              0           0
#> 4              0           0
#> 5              0           0
#> 6             14           0
```

## Crosswalk table
