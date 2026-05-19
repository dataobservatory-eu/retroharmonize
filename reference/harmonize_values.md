# Harmonize values and labels of labelled vectors

\`harmonize_values()\` converts heterogeneous labelled survey vectors
into a harmonized representation suitable for cross-survey integration.

The function:

\- harmonizes value labels using regex-based matching; - assigns
harmonized numeric codes; - preserves original coding metadata; -
standardizes user-defined missing values; - preserves SPSS-style
labelled metadata; - and records provenance attributes.

## Usage

``` r
harmonize_values(
  x,
  harmonize_label = NULL,
  harmonize_labels = NULL,
  na_values = c(do_not_know = 99997, declined = 99998, inap = 99999),
  na_range = NULL,
  id = "survey_id",
  name_orig = NULL,
  remove = NULL,
  perl = FALSE
)
```

## Arguments

- x:

  A labelled vector, typically of class \`"haven_labelled"\` or
  \`"haven_labelled_spss"\`.

- harmonize_label:

  Optional harmonized variable label. Defaults to the original variable
  label.

- harmonize_labels:

  A list describing harmonization rules. Must contain the elements:

  \- \`from\` - \`to\` - \`numeric_values\`

- na_values:

  Named numeric vector defining harmonized missing value codes.

- na_range:

  Optional SPSS-style missing value range. Usually left \`NULL\`.

- id:

  Survey identifier. Defaults to \`"survey_id"\`.

- name_orig:

  Optional original variable name. Defaults to the object name supplied
  to \`x\`.

- remove:

  Optional regex pattern removed from original labels before
  harmonization.

- perl:

  Logical. Use Perl-compatible regular expressions? Defaults to
  \`FALSE\`.

## Value

A harmonized \`haven_labelled_spss\` vector.

The returned vector preserves:

\- harmonized value labels; - harmonized numeric coding; - SPSS missing
value metadata; - original coding metadata; - survey provenance
metadata.

## Details

Create a harmonized labelled vector with standardized value labels,
numeric coding, and missing value definitions.

Harmonization is performed using a harmonization table supplied via
\`harmonize_labels\`.

The harmonization table must contain:

\- \`from\`: regex patterns matching original labels; - \`to\`:
harmonized labels; - \`numeric_values\`: harmonized numeric codes.

Original labels and numeric codes are preserved in attributes attached
to the returned vector.

If no harmonization table is supplied, the function still attempts to
normalize common missing value labels such as:

\- \`"inap"\` - \`"declined"\` - \`"do_not_know"\`

## See also

\[harmonize_var_names()\]

Other harmonization functions:
[`collect_val_labels()`](https://ropengov.github.io/retroharmonize/reference/collect_val_labels.md),
[`crosswalk_surveys()`](https://ropengov.github.io/retroharmonize/reference/crosswalk_surveys.md),
[`harmonize_na_values()`](https://ropengov.github.io/retroharmonize/reference/harmonize_na_values.md),
[`harmonize_survey_values()`](https://ropengov.github.io/retroharmonize/reference/harmonize_survey_values.md),
[`harmonize_var_names()`](https://ropengov.github.io/retroharmonize/reference/harmonize_var_names.md),
[`is.crosswalk_table()`](https://ropengov.github.io/retroharmonize/reference/crosswalk_table_create.md),
[`label_normalize()`](https://ropengov.github.io/retroharmonize/reference/label_normalize.md)

## Examples

``` r
var1 <- labelled::labelled_spss(
  x = c(1, 0, 1, 1, 0, 8, 9),
  labels = c(
    "TRUST" = 1,
    "NOT TRUST" = 0,
    "DON'T KNOW" = 8,
    "INAP. HERE" = 9
  ),
  na_values = c(8, 9)
)

harmonize_values(
  var1,
  harmonize_labels = list(
    from = c(
      "^tend\\sto|^trust",
      "^tend\\snot|not\\strust",
      "^dk|^don",
      "^inap"
    ),
    to = c(
      "trust",
      "not_trust",
      "do_not_know",
      "inap"
    ),
    numeric_values = c(
      1,
      0,
      99997,
      99999
    )
  ),
  na_values = c(
    "do_not_know" = 99997,
    "inap" = 99999
  ),
  id = "survey_id"
)
#> <labelled_spss_survey<double>[7]>: var1
#> 1 0 1 1 0 99997 99999
#> Missing values: 99997, 99999
#> See all attributes survey_id_name, survey_id_values, survey_id_label [...], survey_id_na_values with attributes(x)
```
