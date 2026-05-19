# Harmonize SPSS-style missing value ranges

Ensure consistency between SPSS-style missing value ranges
(\`na_range\`) and explicit missing values (\`na_values\`) for labelled
survey vectors.

## Usage

``` r
na_range_to_values(x)
```

## Arguments

- x:

  A labelled vector created with \[haven::labelled_spss()\] or
  \`retroharmonize_labelled_spss_survey\`.

## Value

The input vector with harmonized \`na_values\` and \`na_range\`
attributes. If no harmonization is needed, \`x\` is returned unchanged.

## Details

When both attributes are present, this function:

- adjusts the missing range if it conflicts with existing missing
  values,

- derives missing values from the range when necessary,

- leaves non-SPSS-labelled vectors unchanged.

This harmonization is important before joining, binding, or summarizing
survey data.

## See also

\[labelled::na_range()\], \[labelled::na_values()\], \[as_numeric()\]

Other variable label harmonization functions:
[`label_normalize()`](https://ropengov.github.io/retroharmonize/reference/label_normalize.md)
