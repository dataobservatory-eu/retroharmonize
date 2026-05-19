# Validate a crosswalk table

Create a crosswalk table with the source variable names and variable
labels.

## Usage

``` r
is.crosswalk_table(ctable)

crosswalk_table_create(metadata)
```

## Arguments

- ctable:

  A table to validate if it is a crosswalk table.

- metadata:

  A metadata table created by \[metadata_create()\].

## Value

A tibble with raw crosswalk table. It contains all harmonization tasks,
but the target values need to be set by further manipulations.

## Details

The table contains a `var_name_target` and `val_label_target` column,
but these values need to be set by further manual or reproducible
harmonization steps.

## See also

Other metadata functions:
[`create_codebook()`](https://ropengov.github.io/retroharmonize/reference/create_codebook.md),
[`metadata_create()`](https://ropengov.github.io/retroharmonize/reference/metadata_create.md),
[`metadata_survey_create()`](https://ropengov.github.io/retroharmonize/reference/metadata_survey_create.md)

Other harmonization functions:
[`collect_val_labels()`](https://ropengov.github.io/retroharmonize/reference/collect_val_labels.md),
[`crosswalk_surveys()`](https://ropengov.github.io/retroharmonize/reference/crosswalk_surveys.md),
[`harmonize_na_values()`](https://ropengov.github.io/retroharmonize/reference/harmonize_na_values.md),
[`harmonize_survey_values()`](https://ropengov.github.io/retroharmonize/reference/harmonize_survey_values.md),
[`harmonize_values()`](https://ropengov.github.io/retroharmonize/reference/harmonize_values.md),
[`harmonize_var_names()`](https://ropengov.github.io/retroharmonize/reference/harmonize_var_names.md),
[`label_normalize()`](https://ropengov.github.io/retroharmonize/reference/label_normalize.md)
