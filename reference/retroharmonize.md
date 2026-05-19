# retroharmonize: Retrospective harmonization of survey data files

The goal of `retroharmonize` is to facilitate retrospective (ex-post)
harmonization of data, particularly survey data, in a reproducible
manner. The package provides tools for organizing the metadata,
standardizing the coding of variables, variable names and value labels,
including missing values, and for documenting all transformations, with
the help of comprehensive S3 classes.

## import functions

Read data stored in formats with rich metadata, such as SPSS (.sav)
files, and make them usable in a programmatic context.  
[`read_spss`](https://ropengov.github.io/retroharmonize/reference/read_spss.md):
read an SPSS file and record metadata for reproducibility  
[`read_rds`](https://ropengov.github.io/retroharmonize/reference/read_rds.md):
read an rds file and record metadata for reproducibility  
[`read_surveys`](https://ropengov.github.io/retroharmonize/reference/read_surveys.md):
programmatically read a list of surveys  
[`pull_survey`](https://ropengov.github.io/retroharmonize/reference/pull_survey.md):
pull a single survey from a survey list.  

## subsetting functions

[`subset_surveys`](https://ropengov.github.io/retroharmonize/reference/subset_surveys.md):
remove variables from surveys that cannot be harmonized.

## variable name harmonization functions

[`harmonize_survey_variables`](https://ropengov.github.io/retroharmonize/reference/harmonize_survey_variables.md):
Create a list of surveys with harmonized variable names.  

## variable label harmonization functions

Create consistent coding and labelling.  
[`harmonize_values`](https://ropengov.github.io/retroharmonize/reference/harmonize_values.md):
Harmonize the label list across surveys.  
[`harmonize_survey_values`](https://ropengov.github.io/retroharmonize/reference/harmonize_survey_values.md):
Create a list of surveys with harmonized value labels.  
[`na_range_to_values`](https://ropengov.github.io/retroharmonize/reference/na_range_to_values.md):
Make the `na_range` attributes, as imported from SPSS, consistent with
the `na_values` attributes.  
[`label_normalize`](https://ropengov.github.io/retroharmonize/reference/label_normalize.md)
removes special characters, whitespace, and other typical typing errors
and helps the uniformization of labels and variable names.  

## survey harmonization functions

[`merge_surveys`](https://ropengov.github.io/retroharmonize/reference/merge_surveys.md):
Create a list of surveys with harmonized names and variable labels.  
[`crosswalk_surveys`](https://ropengov.github.io/retroharmonize/reference/crosswalk_surveys.md):
Create a list of surveys with harmonized variable names, harmonized
value labels and harmonize R classes.  
[`crosswalk`](https://ropengov.github.io/retroharmonize/reference/crosswalk_surveys.md):
Create a joined data frame of surveys with harmonized variable names,
harmonized value labels and harmonize R classes.  

## metadata functions

[`metadata_create`](https://ropengov.github.io/retroharmonize/reference/metadata_create.md):
Createa metadata dataa from one or more
[`survey`](https://ropengov.github.io/retroharmonize/reference/survey.md).  
[`metadata_survey_create`](https://ropengov.github.io/retroharmonize/reference/metadata_survey_create.md):
Create a joined metadata data frame from one survey.  
[`create_codebook`](https://ropengov.github.io/retroharmonize/reference/create_codebook.md)
and
[`codebook_waves_create`](https://ropengov.github.io/retroharmonize/reference/create_codebook.md)
[`crosswalk_table_create`](https://ropengov.github.io/retroharmonize/reference/crosswalk_table_create.md):
Create an initial crosswalk table from a metadata data frame.  

## documentation functions

Make the workflow reproducible by recording the harmonization process.
[`document_survey_item`](https://ropengov.github.io/retroharmonize/reference/document_survey_item.md):
Returns a list of the current and historic coding, labelling of the
valid range and missing values or range, the history of the variable
names and the history of the survey IDs.
[`document_surveys`](https://ropengov.github.io/retroharmonize/reference/document_surveys.md):
Document the key attributes surveys in a survey list.

## type conversion functions

Consistently treat labels and SPSS-style user-defined missing values in
the R language.
[`survey`](https://ropengov.github.io/retroharmonize/reference/survey.md)
helps constructing a valid survey data frame, and
[`labelled_spss_survey`](https://ropengov.github.io/retroharmonize/reference/labelled_spss_survey.md)
helps creating a vector for a questionnaire item.
[`as_numeric`](https://ropengov.github.io/retroharmonize/reference/labelled_spss_survey_coercion.md):
convert to numeric values.  
[`as_factor`](https://ropengov.github.io/retroharmonize/reference/labelled_spss_survey_coercion.md):
convert to labels to factor levels.  
[`as_character`](https://ropengov.github.io/retroharmonize/reference/labelled_spss_survey_coercion.md):
convert to labels to characters.  
[`as_labelled_spss_survey`](https://ropengov.github.io/retroharmonize/reference/as_labelled_spss_survey.md):
convert labelled and labelled_spss vectors to labelled_spss_survey
vectors.  

## See also

Useful links:

- <https://retroharmonize.dataobservatory.eu/>

- Report bugs at
  <https://github.com/dataobservatory-eu/retroharmonize/issues>

## Author

**Maintainer**: Daniel Antal <daniel.antal@dataobservatory.eu>
([ORCID](https://orcid.org/0000-0001-7513-6760))

Authors:

- Daniel Antal <daniel.antal@dataobservatory.eu>
  ([ORCID](https://orcid.org/0000-0001-7513-6760))

Other contributors:

- Marta Kolczynska <mkolczynska@gmail.com>
  ([ORCID](https://orcid.org/0000-0003-4981-0437)) \[contributor\]
