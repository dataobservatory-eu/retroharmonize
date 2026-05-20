# Survey Harmonization

``` r

library(retroharmonize)
#> Warning: S3 methods 'vec_cast.retroharmonize_labelled_spss_survey',
#> 'vec_ptype2.retroharmonize_labelled_spss_survey' were declared in NAMESPACE but
#> not found
```

Survey data harmonization refers to procedures that improve the data
comparability or the inferential capacity of multiple surveys. *Ex ante*
survey harmonization refers to planning and design steps to make sure
that not yet answered questionnaires can be better compared, or data
derived from them joined, integrated. Such procedures include the
harmonization of the questionnaire, the harmonization of the sample
design, and other aspects of carrying out multiple surveys. *Ex post* or
*retrospective harmonization* refers to procedures to data that has been
derived from surveys—i.e., survey that have been carried out.

Naturally, better *ex ante* harmonization makes eventual data
integration or data comparison easier; yet often we can still harmonize
retrospectively survey data that has not been carefully pre-harmonized
before respondents have answered the questionnaire items.

Our aim with the `retroharmonize` R package is to provide assistance to
a reproducible research workflow in carrying out important computational
aspects of retrospective survey harmonization.

Let’s start with a very simple example.

``` r

library(labelled)
survey_1 <- data.frame(
  sex = labelled(c(1, 1, 0, NA_real_), c(Male = 1, Female = 0))
)
attr(survey_1, "id") <- "Survey 1"

survey_2 <- data.frame(
  gender = labelled(c(1, 3, 9, 1, 2), c(male = 1, female = 2, other = 3, declined = 9))
)
attr(survey_2, "id") <- "Survey 2"
```

``` r

library(dplyr, quietly = TRUE)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
survey_1 %>%
  mutate(
    sex_numeric = as_numeric(.data$sex),
    sex_factor = as_factor(.data$sex)
  )
#>   sex sex_numeric sex_factor
#> 1   1           1       Male
#> 2   1           1       Male
#> 3   0           0     Female
#> 4  NA          NA       <NA>
```

## Tasks in the harmonization workflow

The ordering of the survey harmonization workflow is flexible, and it is
likely that even the same researcher would choose a different workflow
in the case of smaller, simpler harmonization tasks and more complex
harmonization tasks.

The data science aspect of a successful survey harmonization task is the
creation of a consistent data frame that contains harmonized information
from multiple surveys. It practically means that questionnaire items are
mapped into variables with a consistent numerical coding, descriptive
metadata (variable and value labels) and a consistent handling of
missing and special values. This may be very laborous task when surveys
are conducted in different years, saved in different file formats with a
different metadata structure, missing and special values are handled
differently, and the metadata contains potentially different natural
language descriptions or spelling.

`Survey 1` labels the sex of respondents as `Male` and `Female`, and has
cases that are neither `Male` or `Female`, but we do not know why.

``` r

survey_2 %>%
  mutate(
    gender_numeric = as_numeric(.data$gender),
    gender_factor = as_factor(.data$gender)
  )
#>   gender gender_numeric gender_factor
#> 1      1              1          male
#> 2      3              3         other
#> 3      9              9      declined
#> 4      1              1          male
#> 5      2              2        female
```

`Survey 2` records gender, which contains the same information as sex in
`Survey 1` (`Male` and `Female`), but allows people to identify as
`Other`, and labels cases when people decline to identify with any of
these three categories.

In practice, you want to end up with the following joined representation
of your survey:

``` r

survey_joined <- data.frame(
  id = c(1, 2, 3, 4, 1, 2, 3, 4, 5),
  survey = c(rep(1, 4), rep(2, 5)),
  gender = labelled(c(1, 1, 0, 9, 1, 3, 9, 1, 0), c(male = 1, female = 0, other = 3, declined = 9))
)

survey_joined %>%
  mutate(
    id = paste0("survey_", .data$survey, "_", .data$id),
    gender_numeric = c(1, 1, 0, NA_real_, 1, 3, NA_real_, 1, 0),
    gender_factor = as_factor(.data$gender),
    is_female = ifelse(.data$gender_numeric == 0, 1, 0)
  )
#>           id survey gender gender_numeric gender_factor is_female
#> 1 survey_1_1      1      1              1          male         0
#> 2 survey_1_2      1      1              1          male         0
#> 3 survey_1_3      1      0              0        female         1
#> 4 survey_1_4      1      9             NA      declined        NA
#> 5 survey_2_1      2      1              1          male         0
#> 6 survey_2_2      2      3              3         other         0
#> 7 survey_2_3      2      9             NA      declined        NA
#> 8 survey_2_4      2      1              1          male         0
#> 9 survey_2_5      2      0              0        female         1
```

1.  Harmonization of concepts
    - Create a mental map of the measured concepts that needs to be
      harmonized. Which variables contain sufficiently similar
      information that can be harmonized? In our simple example, we want
      to harmonize a binary sex with missing cases and a four-level
      categorical variable on gender identification, and concatenate the
      harmonized vectors by binding or joining the Survey 1 and Survey 2
      data frames.
    - Our metadata function help mapping the information stored in the
      file representations of multiple surveys. We want to create a
      simple inventory of numerical codes, value ranges, missing cases
      and variable labels.
2.  Variable names
    - Data measuring sufficiently similar concepts, i.e. data that can
      be harmonized, is stored in variables that have the same name in
      different data frames representing the survey, therefore they can
      be bind or joined together. We want to join or bind by rows
      `survey_1` with `survey_2`, or, we want to concatenate
      `survey_1$sex` with `survey_2$gender`.
    - Descriptive metadata about the variable, such as “variable labels”
      in SPSS files, is recorded for documentation, and if needed,
      harmonized across surveys. In SPSSS, `survey_1$sex` may come with
      a variable label something like *SEX OF RESPONDENT*, and
      `survey_2$gender` may be labelled as *GENDER IDENTIFICATION*. This
      label should be harmonized to *Sex or gender or the respondent*.
3.  Variable coding and labels
    - Variables recording or measuring the same concept, such as the
      gender of the respondent, are coded exactly the same way, for
      example, females with 0, males with 1, non-binary respondents with
      3, and people declining to reveal their gender with 9. This means
      that observations in `survey_2$gender` coded with a numeric 2 must
      be changed to a numeric 0.
    - Variable labels are used consistently and in exactly the same way,
      i.e. `survey_1$sex` *Female* respondents and `survey_2$gender`
      *female* respondents will be consistently labelled as *female*.
4.  Variable types
    - Variables recording or measuring the same concept are stored in
      exactly the same R type, and they can be consistently concatenated
      across surveys, or they can be subsetted, cross-cutting surveys,
      for example, all female respondents from Survey 1 and Survey 2 can
      be subsetted into a female vector.
    - The labelled class of
      [labelled](https://larmarange.github.io/labelled/articles/labelled.html)
      is not sufficiently strict, because it allows inconsistent special
      (missing) values. Our inherited
      [labelled_spss_survey](https://retroharmonize.dataobservatory.eu/reference/labelled_spss_survey.html)
      consistently contains codes, labels, missing ranges and missing
      values, and therefore it can be concatenated.
    - The numeric or factor representation of `survey_1$sex` and
      `survey_2$gender` can be technically concatenated, but before
      harmonization this will create logical errors, because females
      will be either coded with 0 or with 2. The
      [`as_numeric()`](https://ropengov.github.io/retroharmonize/reference/labelled_spss_survey_coercion.md)
      and
      [`as_factor()`](https://ropengov.github.io/retroharmonize/reference/labelled_spss_survey_coercion.md)
      methods of our
      [labelled_spss_survey](https://retroharmonize.dataobservatory.eu/reference/labelled_spss_survey.html)
      class handle consistency issues.
5.  Reproducibility
    - The revision, checking, external review and audit of the data
      requires that the steps can be replicated by a third party. This
      requires a documentation of the harmonization steps, i.e., 1=Women
      in Survey 1, and 0=female in Survey 2 became 0=females in the
      harmonized dataset.
    - Our
      [survey](https://retroharmonize.dataobservatory.eu/reference/survey.html)
      class is derived from [tibble](https://tibble.tidyverse.org/), the
      modernized version of the base
      [`data.frame()`](https://rdrr.io/r/base/data.frame.html). It
      contains various descriptive metadata about the survey among
      attributes.

The joining of the not harmonized datasets results in the following data
frame.

``` r

library(dplyr)

survey_1 %>%
  mutate(
    survey = 1,
    sex_numeric = as_numeric(.data$sex),
    sex_factor = as_factor(.data$sex)
  ) %>%
  full_join(
    survey_2 %>%
      mutate(
        survey = 2,
        gender_numeric = as_numeric(.data$gender),
        gender_factor = as_factor(.data$gender)
      )
  )
#> Joining with `by = join_by(survey)`
#>   sex survey sex_numeric sex_factor gender gender_numeric gender_factor
#> 1   1      1           1       Male     NA             NA          <NA>
#> 2   1      1           1       Male     NA             NA          <NA>
#> 3   0      1           0     Female     NA             NA          <NA>
#> 4  NA      1          NA       <NA>     NA             NA          <NA>
#> 5  NA      2          NA       <NA>      1              1          male
#> 6  NA      2          NA       <NA>      3              3         other
#> 7  NA      2          NA       <NA>      9              9      declined
#> 8  NA      2          NA       <NA>      1              1          male
#> 9  NA      2          NA       <NA>      2              2        female
```

Performing only variable harmonization yields to a data frame that has
the correct dimensions, but it is not usable for statistical analysis.

``` r

library(dplyr)

survey_var_harmonized <- survey_1 %>%
  rename(gender = .data$sex) %>%
  mutate(
    survey = 1,
    gender_numeric = as_numeric(.data$gender),
    gender_factor = as_factor(.data$gender)
  ) %>%
  full_join(
    survey_2 %>%
      mutate(
        survey = 2,
        gender_numeric = as_numeric(.data$gender),
        gender_factor = as_factor(.data$gender)
      ),
    by = c("gender", "survey", "gender_numeric", "gender_factor")
  )
#> Warning: Use of .data in tidyselect expressions was deprecated in tidyselect 1.2.0.
#> ℹ Please use `"sex"` instead of `.data$sex`
#> This warning is displayed once per session.
#> Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
#> generated.
#> Warning: `gender` and `gender` have conflicting value labels.
#> ℹ Labels for these values will be taken from `gender`.
#> ✖ Values: 1
```

Apart from the simple, descriptive variable of the survey
identification, non of the descriptive statistics are meaningful.

``` r

summary(survey_var_harmonized)
#>      gender         survey      gender_numeric  gender_factor
#>  Min.   :0.00   Min.   :1.000   Min.   :0.00   Female  :1    
#>  1st Qu.:1.00   1st Qu.:1.000   1st Qu.:1.00   Male    :2    
#>  Median :1.00   Median :2.000   Median :1.00   male    :2    
#>  Mean   :2.25   Mean   :1.556   Mean   :2.25   female  :1    
#>  3rd Qu.:2.25   3rd Qu.:2.000   3rd Qu.:2.25   other   :1    
#>  Max.   :9.00   Max.   :2.000   Max.   :9.00   declined:1    
#>  NAs    :1                      NAs    :1      NAs     :1
```

The variable labels must be harmonized for a successful factor
representation. The numerical coding must be harmonized, and the missing
cases must be consistently handled to achieve any useful numerical
representation.

``` r

survey_joined %>%
  mutate(
    id = paste0("survey_", .data$survey, "_", .data$id),
    gender_numeric = c(1, 1, 0, NA_real_, 1, 3, NA_real_, 1, 0),
    gender_factor = as_factor(.data$gender),
    female_ratio = ifelse(.data$gender_numeric == 0, 1, 0)
  ) %>%
  summary()
#>          id         survey          gender      gender_numeric  gender_factor
#>  Length   : 9   Min.   :1.000   Min.   :0.000   Min.   :0.0    female  :2    
#>  N.unique : 9   1st Qu.:1.000   1st Qu.:1.000   1st Qu.:0.5    male    :4    
#>  N.blank  : 0   Median :2.000   Median :1.000   Median :1.0    other   :1    
#>  Min.nchar:10   Mean   :1.556   Mean   :2.778   Mean   :1.0    declined:2    
#>  Max.nchar:10   3rd Qu.:2.000   3rd Qu.:3.000   3rd Qu.:1.0                  
#>                 Max.   :2.000   Max.   :9.000   Max.   :3.0                  
#>                                                 NAs    :2                    
#>   female_ratio   
#>  Min.   :0.0000  
#>  1st Qu.:0.0000  
#>  Median :0.0000  
#>  Mean   :0.2857  
#>  3rd Qu.:0.5000  
#>  Max.   :1.0000  
#>  NAs    :2
```

## How we help harmonization

1.  The *data importing* functions make sure that survey data and
    metadata are carefully translated to R data classes and variable
    types.

2.  The *metadata functions* help the analysis, normalization and
    joining of the metadata aspects (variable and value labels, original
    variable names, unique identifiers) across surveys.

3.  *Harmonization functions* help the harmonization of responses to
    questionnaire items, i.e. making sure that coded values, the
    labelling of values, and missing data are handled consistently
    across multiple surveys.

Our package was tested on multiple, international, harmonized surveys,
particularly the Eurobarometer, the Afrobarometer and the Arab Barometer
survey programs. Different users, and different task call for different
workflows. We created a number of helper functions to assist various
workflows.
