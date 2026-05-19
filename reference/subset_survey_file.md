# Subset surveys from files

Subset surveys from files

## Usage

``` r
subset_survey_file(
  file_path,
  subset_vars,
  subset_name = "subset",
  id = NULL,
  export_path = NULL
)
```

## Arguments

- file_path:

  A single survey files.

- subset_vars:

  Character vector of variable names to retain. If \`NULL\`, all
  variables are retained.

- subset_name:

  Character string appended to filenames of subsetted surveys. Defaults
  to \`"subset"\`.

- export_path:

  Optional directory where subsetted surveys are saved as \`.rds\`
  files. If \`NULL\`, surveys are returned in memory.
