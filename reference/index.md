# Package index

## Importing

Survey data, i.e., data derived from questionnaires or systematic data
collection, such as inspecting objects in nature, recording prices at
shops are usually stored databases, and converted to complex files
retaining at least coding, labelling metadata together with the data.
This must be imported to R so that the appropriate harmonization tasks
can be carried out with the appropriate R types.

- [`read_surveys()`](https://ropengov.github.io/retroharmonize/reference/read_surveys.md)
  [`read_survey()`](https://ropengov.github.io/retroharmonize/reference/read_surveys.md)
  : Read survey files into memory or save as \`.rds\`
- [`read_rds()`](https://ropengov.github.io/retroharmonize/reference/read_rds.md)
  : Read a survey from an \`.rds\` file
- [`read_spss()`](https://ropengov.github.io/retroharmonize/reference/read_spss.md)
  : Read SPSS survey files
- [`read_dta()`](https://ropengov.github.io/retroharmonize/reference/read_dta.md)
  : Read a Stata \`.dta\` survey file
- [`read_csv()`](https://ropengov.github.io/retroharmonize/reference/read_csv.md)
  : Read a survey dataset from a CSV file
- [`pull_survey()`](https://ropengov.github.io/retroharmonize/reference/pull_survey.md)
  : Retrieve a survey from a survey list

## Harmonizing concepts with metadata

After importing data with some **descriptive metadata** such as
**numerical coding** and **labelling**, we need to create a map of the
information that is in our R session to prepare a harmonization plan. We
must find information related to sufficiently similar concepts that can
be harmonized to be successfully joined into a single variable, and
eventually a table of similar variables must be joined.

- [`metadata_create()`](https://ropengov.github.io/retroharmonize/reference/metadata_create.md)
  [`metadata_waves_create()`](https://ropengov.github.io/retroharmonize/reference/metadata_create.md)
  : Create metadata tables from survey datasets
- [`metadata_survey_create()`](https://ropengov.github.io/retroharmonize/reference/metadata_survey_create.md)
  : Create variable-level metadata from a survey dataset
- [`retroharmonize`](https://ropengov.github.io/retroharmonize/reference/retroharmonize.md)
  : retroharmonize: Retrospective harmonization of survey data files

## Codebooks

The new functions will follow the DDI and SDMX terminology. See vignette
[Harmonizing Concepts, Questions, and
Variables](https://retroharmonize.dataobservatory.eu/articles/concept.html)

- [`create_codebook()`](https://ropengov.github.io/retroharmonize/reference/create_codebook.md)
  [`codebook_waves_create()`](https://ropengov.github.io/retroharmonize/reference/create_codebook.md)
  [`codebook_surveys_create()`](https://ropengov.github.io/retroharmonize/reference/create_codebook.md)
  : Create a survey codebook

## Harmonize variable names

Before joining variables containing responses about the same concept,
make sure that they have **identical names** in the re-processed
surveys. See the vignette [Working with a Crosswalk
Table](https://retroharmonize.dataobservatory.eu/articles/crosswalk.html)
for examples and further clarification.

- [`harmonize_var_names()`](https://ropengov.github.io/retroharmonize/reference/harmonize_var_names.md)
  : Harmonize variable names across surveys
- [`label_normalize()`](https://ropengov.github.io/retroharmonize/reference/label_normalize.md)
  [`var_label_normalize()`](https://ropengov.github.io/retroharmonize/reference/label_normalize.md)
  [`val_label_normalize()`](https://ropengov.github.io/retroharmonize/reference/label_normalize.md)
  : Normalize value and variable labels
- [`harmonize_survey_variables()`](https://ropengov.github.io/retroharmonize/reference/harmonize_survey_variables.md)
  : Read a survey from a CSV file

## Harmonize numerical codes and labels

To merge variables from different surveys into a single variable, you
must make sure that the numerical codes and labels, for example *0=‘no’*
and *1=‘yes’* are processed identically. See the vignette [Harmonize
Value
Labels](https://retroharmonize.dataobservatory.eu/articles/harmonize_labels.html)
for examples and further clarification.

- [`collect_val_labels()`](https://ropengov.github.io/retroharmonize/reference/collect_val_labels.md)
  [`collect_na_labels()`](https://ropengov.github.io/retroharmonize/reference/collect_val_labels.md)
  : Collect labels from metadata file
- [`harmonize_values()`](https://ropengov.github.io/retroharmonize/reference/harmonize_values.md)
  : Harmonize values and labels of labelled vectors
- [`harmonize_survey_values()`](https://ropengov.github.io/retroharmonize/reference/harmonize_survey_values.md)
  [`harmonize_waves()`](https://ropengov.github.io/retroharmonize/reference/harmonize_survey_values.md)
  : Harmonize values in surveys
- [`merge_surveys()`](https://ropengov.github.io/retroharmonize/reference/merge_surveys.md)
  : Merge and harmonize surveys
- [`merge_waves()`](https://ropengov.github.io/retroharmonize/reference/merge_waves.md)
  : Deprecated wrapper for \`merge_surveys()\`

## Harmonize missing and special cases

Some variable codes have a special meaning, such as a various labels of
**missing values** which need to be converted differently to numeric,
factor or character representation. See the vignette [Harmonize Value
Labels](https://retroharmonize.dataobservatory.eu/articles/harmonize_labels.html)
for examples and further clarification.

- [`collect_val_labels()`](https://ropengov.github.io/retroharmonize/reference/collect_val_labels.md)
  [`collect_na_labels()`](https://ropengov.github.io/retroharmonize/reference/collect_val_labels.md)
  : Collect labels from metadata file
- [`na_range_to_values()`](https://ropengov.github.io/retroharmonize/reference/na_range_to_values.md)
  : Harmonize SPSS-style missing value ranges
- [`harmonize_na_values()`](https://ropengov.github.io/retroharmonize/reference/harmonize_na_values.md)
  : Harmonize na_values in haven_labelled_spss

## Crosswalk

Laying out the harmonization **crosswalk scheme** (unifying variable
names, codes, labels.) See the vignette [Working with a Crosswalk
Table](https://retroharmonize.dataobservatory.eu/articles/crosswalk.html)
for examples and further clarification.

- [`is.crosswalk_table()`](https://ropengov.github.io/retroharmonize/reference/crosswalk_table_create.md)
  [`crosswalk_table_create()`](https://ropengov.github.io/retroharmonize/reference/crosswalk_table_create.md)
  : Validate a crosswalk table
- [`crosswalk_surveys()`](https://ropengov.github.io/retroharmonize/reference/crosswalk_surveys.md)
  [`crosswalk()`](https://ropengov.github.io/retroharmonize/reference/crosswalk_surveys.md)
  : Crosswalk and harmonize surveys

## Subsetting

Remove variables that **cannot be harmonized** in your workflow either
in memory (faster for smaller tasks) or sequentially from files. See the
vignette [Working with a Crosswalk
Table](https://retroharmonize.dataobservatory.eu/articles/crosswalk.html)
for examples and further clarification.

- [`subset_surveys()`](https://ropengov.github.io/retroharmonize/reference/subset_surveys.md)
  [`subset_waves()`](https://ropengov.github.io/retroharmonize/reference/subset_surveys.md)
  [`subset_save_surveys()`](https://ropengov.github.io/retroharmonize/reference/subset_surveys.md)
  : Subset and optionally harmonize surveys

## Documentation functions

These functionality requires a thorough review.

- [`document_survey_item()`](https://ropengov.github.io/retroharmonize/reference/document_survey_item.md)
  : Document survey item provenance
- [`document_surveys()`](https://ropengov.github.io/retroharmonize/reference/document_surveys.md)
  [`document_waves()`](https://ropengov.github.io/retroharmonize/reference/document_surveys.md)
  : Document survey lists
- [`create_codebook()`](https://ropengov.github.io/retroharmonize/reference/create_codebook.md)
  [`codebook_waves_create()`](https://ropengov.github.io/retroharmonize/reference/create_codebook.md)
  [`codebook_surveys_create()`](https://ropengov.github.io/retroharmonize/reference/create_codebook.md)
  : Create a survey codebook

## Type conversion

Consistently treat labels, missing value ranges, missing value labels
imported from SPSS, STATA or other source to use R language statistical
functions, which mainly work with the base class of **numeric** or
**factor**. For data visualization, the base class **character** may be
preferred. See vignette [The labelled_spss_survey
class](https://retroharmonize.dataobservatory.eu/articles/labelled_spss_survey.html)
for further information.

- [`survey()`](https://ropengov.github.io/retroharmonize/reference/survey.md)
  [`is.survey()`](https://ropengov.github.io/retroharmonize/reference/survey.md)
  [`summary(`*`<survey>`*`)`](https://ropengov.github.io/retroharmonize/reference/survey.md)
  : Create a survey data frame
- [`is.survey_df()`](https://ropengov.github.io/retroharmonize/reference/survey_df.md)
  [`survey_df()`](https://ropengov.github.io/retroharmonize/reference/survey_df.md)
  [`print(`*`<survey_df>`*`)`](https://ropengov.github.io/retroharmonize/reference/survey_df.md)
  : Create a survey object
- [`labelled_spss_survey()`](https://ropengov.github.io/retroharmonize/reference/labelled_spss_survey.md)
  [`` `[`( ``*`<retroharmonize_labelled_spss_survey>`*`)`](https://ropengov.github.io/retroharmonize/reference/labelled_spss_survey.md)
  [`print(`*`<retroharmonize_labelled_spss_survey>`*`)`](https://ropengov.github.io/retroharmonize/reference/labelled_spss_survey.md)
  [`summary(`*`<retroharmonize_labelled_spss_survey>`*`)`](https://ropengov.github.io/retroharmonize/reference/labelled_spss_survey.md)
  [`is.na(`*`<retroharmonize_labelled_spss_survey>`*`)`](https://ropengov.github.io/retroharmonize/reference/labelled_spss_survey.md)
  [`levels(`*`<retroharmonize_labelled_spss_survey>`*`)`](https://ropengov.github.io/retroharmonize/reference/labelled_spss_survey.md)
  [`` `names<-`( ``*`<retroharmonize_labelled_spss_survey>`*`)`](https://ropengov.github.io/retroharmonize/reference/labelled_spss_survey.md)
  [`format(`*`<retroharmonize_labelled_spss_survey>`*`)`](https://ropengov.github.io/retroharmonize/reference/labelled_spss_survey.md)
  [`is.labelled_spss_survey()`](https://ropengov.github.io/retroharmonize/reference/labelled_spss_survey.md)
  [`median(`*`<retroharmonize_labelled_spss_survey>`*`)`](https://ropengov.github.io/retroharmonize/reference/labelled_spss_survey.md)
  [`quantile(`*`<retroharmonize_labelled_spss_survey>`*`)`](https://ropengov.github.io/retroharmonize/reference/labelled_spss_survey.md)
  [`weighted.mean(`*`<retroharmonize_labelled_spss_survey>`*`)`](https://ropengov.github.io/retroharmonize/reference/labelled_spss_survey.md)
  [`mean(`*`<retroharmonize_labelled_spss_survey>`*`)`](https://ropengov.github.io/retroharmonize/reference/labelled_spss_survey.md)
  [`sum(`*`<retroharmonize_labelled_spss_survey>`*`)`](https://ropengov.github.io/retroharmonize/reference/labelled_spss_survey.md)
  : Labelled SPSS-style vectors with survey provenance
- [`as_labelled_spss_survey()`](https://ropengov.github.io/retroharmonize/reference/as_labelled_spss_survey.md)
  : Labelled to labelled_spss_survey
- [`concatenate()`](https://ropengov.github.io/retroharmonize/reference/concatenate.md)
  : Concatenate haven_labelled_spss vectors
- [`as_numeric()`](https://ropengov.github.io/retroharmonize/reference/labelled_spss_survey_coercion.md)
  [`as_character()`](https://ropengov.github.io/retroharmonize/reference/labelled_spss_survey_coercion.md)
  [`as_factor()`](https://ropengov.github.io/retroharmonize/reference/labelled_spss_survey_coercion.md)
  : Coercion methods for labelled survey vectors
