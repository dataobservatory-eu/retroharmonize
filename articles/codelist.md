# Value Labels and Codelists

DDI uses the term codebook on the level of file (survey), and we use it
on the level of individual observations. Because normally we want to use
standardized codes, and we started to harmonize with the SDMX
statistical metadata standard, a good resolution seems to be to
differentiate between a Codebook (DDI term) and a Codelist (SDMX term,
but I am sure it has a more general RDF definition.)

``` r

library(retroharmonize)
#> Warning: S3 methods 'vec_cast.retroharmonize_labelled_spss_survey',
#> 'vec_ptype2.retroharmonize_labelled_spss_survey' were declared in NAMESPACE but
#> not found
library(statcodelists)
library(dplyr)
library(knitr)
```

The idea of value label or codelist harmonization is that for example
the Marital (Civil) status variable’s codes are always
`8="Single liv w partner: childr this/prev union"`. To recall
[Harmonizing Concepts, Questions and
Variables](https://retroharmonize.dataobservatory.eu/articles/concept.html).,
the variable harmonization makes sure that each survey has a
`marital status` variable.

DDI leaves it to the Question Banks to harmonize the questionnaire
items, and unfortunately this is a very bad idea. Eurobarometer, for
example, consistently uses obsolete region codes and labels. (See below
for example `FR23`=`Haute Normandie`). This creates a lot of tasks for
retroharmonize even in nominally ex ante harmonized survey programs like
Eurobarometer or Afrobarometer.

``` r

set.seed(12)
my_codebook <- create_codebook(
  survey = read_rds(
    system.file("examples", "ZA7576.rds",
      package = "retroharmonize"
    )
  )
)

sample_n(my_codebook, 12) %>%
  select(.data$filename,
    # Rename variables to DDI Codebook names
    Name = .data$var_name_orig,
    Label = .data$var_label_orig,
    .data$val_code_orig, .data$val_label_orig
  ) %>%
  kable()
#> Warning: Use of .data in tidyselect expressions was deprecated in tidyselect 1.2.0.
#> ℹ Please use `"filename"` instead of `.data$filename`
#> This warning is displayed once per session.
#> Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
#> generated.
#> Warning: Use of .data in tidyselect expressions was deprecated in tidyselect 1.2.0.
#> ℹ Please use `"var_name_orig"` instead of `.data$var_name_orig`
#> This warning is displayed once per session.
#> Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
#> generated.
#> Warning: Use of .data in tidyselect expressions was deprecated in tidyselect 1.2.0.
#> ℹ Please use `"var_label_orig"` instead of `.data$var_label_orig`
#> This warning is displayed once per session.
#> Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
#> generated.
#> Warning: Use of .data in tidyselect expressions was deprecated in tidyselect 1.2.0.
#> ℹ Please use `"val_code_orig"` instead of `.data$val_code_orig`
#> This warning is displayed once per session.
#> Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
#> generated.
#> Warning: Use of .data in tidyselect expressions was deprecated in tidyselect 1.2.0.
#> ℹ Please use `"val_label_orig"` instead of `.data$val_label_orig`
#> This warning is displayed once per session.
#> Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
#> generated.
```

| filename | Name | Label | val_code_orig | val_label_orig |
|:---|:---|:---|:---|:---|
| ZA7576.rds | qa6a_4 | trust_in_institutions_police | 1 | Tend to trust |
| ZA7576.rds | nuts | region_nuts_codes | TR82 | Kastamonu |
| ZA7576.rds | nuts | region_nuts_codes | TR41 | Bursa |
| ZA7576.rds | nuts | region_nuts_codes | LV005 | Latgale |
| ZA7576.rds | nuts | region_nuts_codes | FR23 | Haute Normandie |
| ZA7576.rds | qa6a_4 | trust_in_institutions_police | 9 | Inap. (CY-TCC in isocntry) |
| ZA7576.rds | nuts | region_nuts_codes | AL033 | Gjirokaster |
| ZA7576.rds | qa6b_3 | trust_in_institutions_united_nations_tcc | 3 | DK |
| ZA7576.rds | nuts | region_nuts_codes | EL13 | Ditiki Makedonia (not coded) |
| ZA7576.rds | nuts | region_nuts_codes | BE35 | Namur |
| ZA7576.rds | nuts | region_nuts_codes | BE21 | Antwerpen |
| ZA7576.rds | d7 | marital_status | 8 | Single liv w partner: childr this/prev union |

It is beyond the scope of the retroharmonize package to faciliate the
use of correct variable codes, however, this is so desirable that we
started new, CRAN-released packages. It would be desirable if the
regions are coded and labeled in a way that they can be matched with
regional data or placed on a map. While `BE21`=`Antwerpen` had been
rather stable in the last decades, the `FR23`=`Haute Normandie` not,
because France had a major regional reform in 2015. (Our regions package
only deals with this particular problem.)

## Use standard codelists

The use of standard codelists facilitates data interoperability and the
production of publication-ready statistical products. The
[statcodelists](https://statcodelists.dataobservatory.eu/) package
contains the SDMX \[published as an ISO International Standard (ISO
17369)\] codelist standards used by major statistical agencies.

``` r

library(statcodelists)
CL_SEX
#>   id           name
#> 1  F         Female
#> 2  M           Male
#> 3 _N   Non response
#> 4 _O          Other
#> 5 _T          Total
#> 6 _U        Unknown
#> 7 _Z Not applicable
#>                                                                                                                                                                                                                                                         description
#> 1                                                                                                                                                                                                                                                              <NA>
#> 2                                                                                                                                                                                                                                                              <NA>
#> 3                                                                                                                                                              Failure to obtain a measurement on one or more study variables for one or more elements in a survey.
#> 4                                            Used to cover residual information not contained in other categories of the code list (in some contexts, e.g. classifications, referred to as n.e.s., not elsewhere specified, n.e.c., not elsewhere classified, etc.)
#> 5                                                                                                                                                                                                                                       Used for expressing totals.
#> 6                                                                                                                                       Failure to obtain a measurement (e.g. non response, no data available, information not known by the respondent unit, etc.).
#> 7 Used in response to a question or a request for information that does not apply to the circumstances of the unit being surveyed. This concept is to be understood as meaning "statistically not applicable"; i.e. _Z is to be used only for statistical purposes.
#>   name_locale description_locale
#> 1          en               <NA>
#> 2          en               <NA>
#> 3          en                 en
#> 4          en                 en
#> 5          en                 en
#> 6          en                 en
#> 7          en                 en
```

We can generate further codes for non-binary people, using the [SDMX
Content-Oriented Guidelines (COG)](https://sdmx.org/sdmx_cdcl/) for the
creation of generic and new codelist items.

The problem with the SDMX Codelists is that they are designed for
already aggregated statistical data, and they character codelist `id`
variables. Survey software and question banks use integer ids for the
same answer options.

For example, the [D10
(GENDER)](https://www.icpsr.umich.edu/web/ICPSR/studies/35083/datasets/0001/variables/D10?archive=icpsr)
variable of Eurobarometer uses the following coding:

``` r

data.frame(
  Value = c(1, 2),
  Label = c("Male", "Female")
)
#>   Value  Label
#> 1     1   Male
#> 2     2 Female
```

Furthermore, Eurobarometer often uses characters in the Labels that
should be prohibited because most programming languages or software use
them with a particular meaning. A particularly bad habit is the use of ;
or , (which can be used as column delimiters in files), the \$ sign
which is an anchor in regex and a selector in R.

The current retroharmonize normalizes such characters early on, and this
should change. It is not desirable that final, harmonized codelists use
special characters, but for a faithful representation of the
pre-existing data we should keep them.

``` r

data.frame(
  Value = c(1, 2, 11),
  Label = c(
    "(Re-)Married: without children",
    "(Re-)Married: children this marriage",
    "Divorced/Separated: without children"
  ),
  Normalized = c(
    "Married or Remarried without children",
    "Married or Remarried with children this marriage",
    "Divorced or Separated without children"
  )
) %>% kable()
```

| Value | Label | Normalized |
|---:|:---|:---|
| 1 | (Re-)Married: without children | Married or Remarried without children |
| 2 | (Re-)Married: children this marriage | Married or Remarried with children this marriage |
| 11 | Divorced/Separated: without children | Divorced or Separated without children |

## Harmonize Labels

The actual harmonization has many potential solutions in retroharmonize.
See: [Harmonize Value
Labels](https://retroharmonize.dataobservatory.eu/articles/harmonize_labels.html).

One suggested workflow is the use of [Working with a Crosswalk
Table](https://retroharmonize.dataobservatory.eu/articles/crosswalk.html)

## Conceptual, Literature and Documentation tasks

- Literature review on codelist harmonization. While DDI does not seem
  to be focusing on it (maybe wrong), statistical agencies use
  standardized codelists, and I am sure they are standardizing the
  labels early on, on the questionnaire. Examples: EU-SILC (Panni),
  Eurobarometer, Afrobarometer, Arab Barometer (Daniel)

- What is the state of play in DDI about value label harmonization?
  Review particularly [Document and Manage Longitudinal
  Data](https://doi.org/10.5281/zenodo.5180624)

- General literature?

## Coding tasks

1.  We should encourage the use of our pre-existing codelist software,
    i.e. [regions](https://regions.dataobservatory.eu/) and
    [statcodelists](https://statcodelists.dataobservatory.eu/) with a
    new vignette and mentions in the documentation.
2.  [`create_codebook()`](https://ropengov.github.io/retroharmonize/reference/create_codebook.md)
    will be deprecated, luckily, it does not meet the rOpenSci
    object_verb suggestion. `codebook_create()` will create a
    DDI-Codebook compatible, partial codebook on survey level.
3.  `codelist_create()` should be a new function that creates a codelist
    which considers [SDMX Content-Oriented Guidelines
    (COG)](https://sdmx.org/sdmx_cdcl/) and any guidance from DDI on
    Question banks, and the DDI Question Construct. The empty function
    is now in the `codelist.R` file, develop the documentation and the
    code there.
4.  [`crosswalk_table_create()`](https://ropengov.github.io/retroharmonize/reference/crosswalk_table_create.md)
    should be modified in a way that it builds on
    [`create_codebook()`](https://ropengov.github.io/retroharmonize/reference/create_codebook.md)
    and `codelist_create()` components. Currently, it does both.
