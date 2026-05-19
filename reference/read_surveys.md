# Read survey files into memory or save as \`.rds\`

Import one or more survey files into R using a consistent survey import
workflow. The function supports SPSS (\`.sav\`, \`.por\`), Stata
(\`.dta\`), R (\`.rds\`), and CSV files.

## Usage

``` r
read_surveys(
  survey_paths,
  .f = NULL,
  export_path = NULL,
  ids = NULL,
  dois = NULL,
  ...
)

read_survey(
  file_path,
  .f = NULL,
  export_path = NULL,
  doi = NULL,
  id = NULL,
  ...
)
```

## Arguments

- survey_paths:

  A character vector containing full or relative paths to survey files.

- .f:

  Import function to use. When \`NULL\`, the appropriate import function
  is selected automatically from the file extension.

  Supported formats are:

  \`.sav\`, \`.por\`

  :   \[read_spss()\]

  \`.dta\`

  :   \[read_dta()\]

  \`.rds\`

  :   \[read_rds()\]

  \`.csv\`

  :   \[read_csv()\]

- export_path:

  Optional path where imported surveys should be saved as \`.rds\`
  files. Defaults to \`NULL\`.

- ids:

  Optional survey identifiers.

- dois:

  Optional DOI identifiers for the imported surveys.

- ...:

  Additional arguments passed to the import function.

## Value

If \`export_path = NULL\`, a list of imported survey objects.

If \`export_path\` is provided, a character vector containing exported
\`.rds\` file names.

Imported surveys are returned as data frame-like \[survey()\] objects
with metadata attributes retained for reproducible workflows.

## Details

Use \[read_survey()\] to import a single survey file and
\`read_surveys()\` to import multiple files in a loop.

When \`export_path\` is \`NULL\`, imported surveys are returned as a
list in memory. When \`export_path\` is a valid directory, imported
surveys are saved as \`.rds\` files with \[base::saveRDS()\].

Files that cannot be imported are skipped gracefully. A message is
printed and \`NULL\` is returned for the affected file.

## See also

\[read_survey()\], \[survey()\]

Other import functions:
[`harmonize_survey_variables()`](https://ropengov.github.io/retroharmonize/reference/harmonize_survey_variables.md),
[`pull_survey()`](https://ropengov.github.io/retroharmonize/reference/pull_survey.md),
[`read_csv()`](https://ropengov.github.io/retroharmonize/reference/read_csv.md),
[`read_dta()`](https://ropengov.github.io/retroharmonize/reference/read_dta.md),
[`read_rds()`](https://ropengov.github.io/retroharmonize/reference/read_rds.md),
[`read_spss()`](https://ropengov.github.io/retroharmonize/reference/read_spss.md)

## Examples

``` r
file1 <- system.file(
  "examples",
  "ZA7576.rds",
  package = "retroharmonize"
)

file2 <- system.file(
  "examples",
  "ZA5913.rds",
  package = "retroharmonize"
)

surveys <- read_surveys(
  c(file1, file2),
  .f = "read_rds"
)
```
