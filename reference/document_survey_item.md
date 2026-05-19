# Document survey item provenance

Document the current and historical coding, labels, missing values, and
survey provenance of a harmonized survey variable.

## Usage

``` r
document_survey_item(x)
```

## Arguments

- x:

  A \`labelled_spss_survey\` vector originating from a single survey or
  concatenated from multiple surveys.

## Value

A named list containing:

- current and historical value coding,

- variable labels,

- valid and missing value definitions,

- original variable names,

- survey identifiers.

## See also

Other documentation functions:
[`document_surveys()`](https://ropengov.github.io/retroharmonize/reference/document_surveys.md)

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

var2 <- labelled::labelled_spss(
  x = c(2, 2, 8, 9, 1, 1),
  labels = c(
    "Tend to trust" = 1,
    "Tend not to trust" = 2,
    "DK" = 8,
    "Inap" = 9
  ),
  na_values = c(8, 9)
)

harmonization <- list(
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
  numeric_values = c(1, 0, 99997, 99999)
)

missing_values <- c(
  "do_not_know" = 99997,
  "inap" = 99999
)

h1 <- harmonize_values(
  x = var1,
  harmonize_label = "Do you trust the European Union?",
  harmonize_labels = harmonization,
  na_values = missing_values,
  id = "survey1"
)

h2 <- harmonize_values(
  x = var2,
  harmonize_label = "Do you trust the European Union?",
  harmonize_labels = harmonization,
  na_values = missing_values,
  id = "survey2"
)

h3 <- concatenate(h1, h2)

document_survey_item(h3)
#> $code_table
#> # A tibble: 4 × 7
#>   values survey1_values survey2_values labels      survey1_labels survey2_labels
#>    <dbl>          <dbl>          <dbl> <chr>       <chr>          <chr>         
#> 1      0              1              1 not_trust   TRUST          Tend to trust 
#> 2      1              0              2 trust       NOT TRUST      Tend not to t…
#> 3  99997              8              8 do_not_know DON'T KNOW     DK            
#> 4  99999              9              9 inap        INAP. HERE     Inap          
#> # ℹ 1 more variable: missing <lgl>
#> 
#> $history_var_name
#>         name survey1_name survey2_name 
#>         "h3"       "var1"       "var2" 
#> 
#> $history_var_label
#>                              label                      survey1_label 
#> "Do you trust the European Union?" "Do you trust the European Union?" 
#>                      survey2_label 
#> "Do you trust the European Union?" 
#> 
#> $history_na_range
#> character(0)
#> 
#> $history_id
#> [1] "survey1" "survey2"
#> 
```
