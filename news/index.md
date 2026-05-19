# Changelog

## retroharmonize 0.2.7

CRAN release: 2026-01-14

- Due to an archived dependency, the package was temporary archived on
  CRAN, this is a candidate to bring it back.
- Dependencies were modernised.
- Unit test were updated, extended, and some small (earlier not flagged)
  edge cases better handled.
- No change in the function API.

## retroharmonize 0.2.6

- Various improvements due to extensive testing and feedback. No change
  in the API.

## retroharmonize 0.2.5

- Unified function interface and parameter names.
- This development version has a few known
  [issues](https://github.com/dataobservatory-eu/retroharmonize/issues).

## retroharmonize 0.2.3

- New long form documentation.
- `metadata_surveys_create()` will take now either a list of surveys, or
  file names of saved surveys.

## retroharmonize 0.2.2

- All functions containing ‘wave’ in the name are deprecated. Survey
  ‘waves’ are renamed to ‘survey_list’, because ‘waves’ is used in
  Eurobarometer and a more generic and standardized interface was built.

## retroharmonize 0.2.0

CRAN release: 2021-11-02

- Several documentation good practices. (Thanks for the contribution
  from [@dieghernan](https://github.com/dieghernan)).
- The former *create_codebook()* function is now
  [`create_codebook()`](https://ropengov.github.io/retroharmonize/reference/create_codebook.md)
  for naming consistency.

## retroharmonize 0.1.9

- New function
  [`read_dta()`](https://ropengov.github.io/retroharmonize/reference/read_dta.md)
  for importing STATA files.

## retroharmonize 0.1.13

CRAN release: 2020-09-21

- In the examples that use file operations, dontrun{} replaced by
  donttest{}.
- This is the first released version on CRAN.

## retroharmonize 0.1.12

retroharmonize 0.1.6-0.1.12 are making the package ready for CRAN
release.

## retroharmonize 0.1.5

- retroharmonize 0.1.1-0.1.5 are not intended for release, they contain
  numerous development stages of a new package.

## retroharmonize 0.1.0

- Added a `NEWS.md` file to track changes to the package.
- Class definition and description.
