# Deprecated wrapper for \`merge_surveys()\`

\`merge_waves()\` has been renamed to \[merge_surveys()\] for more
general survey harmonization workflows.

## Usage

``` r
merge_waves(waves, var_harmonization)
```

## Arguments

- waves:

  Deprecated alias for \`survey_list\`.

- var_harmonization:

  A metadata table describing the harmonization rules. The table must
  contain at least:

  \- \`filename\` - \`var_name_orig\` - \`var_name_target\` -
  \`var_label\`

## Value

A list of harmonized survey objects.

## See also

\[merge_surveys()\]

Other survey harmonization functions:
[`merge_surveys()`](https://ropengov.github.io/retroharmonize/reference/merge_surveys.md)
