# vctrs type and casting methods for labelled survey vectors

These methods define how `retroharmonize_labelled_spss_survey` objects
interact with base vectors and with each other in vctrs-based operations
such as concatenation, binding, and coercion.

These methods define how `retroharmonize_labelled_spss_survey` objects
interact with base vectors and with each other in vctrs-based operations
such as concatenation, binding, and coercion.

## Usage

``` r
# S3 method for class 'retroharmonize_labelled_spss_survey.double'
vec_ptype2(x, y, ...)

# S3 method for class 'double.retroharmonize_labelled_spss_survey'
vec_ptype2(x, y, ...)

# S3 method for class 'integer.retroharmonize_labelled_spss_survey'
vec_ptype2(x, y, ...)

# S3 method for class 'retroharmonize_labelled_spss_survey.integer'
vec_ptype2(x, y, ...)

# S3 method for class 'double.retroharmonize_labelled_spss_survey'
vec_cast(x, to, ...)

# S3 method for class 'integer.retroharmonize_labelled_spss_survey'
vec_cast(x, to, ...)

# S3 method for class 'character.retroharmonize_labelled_spss_survey'
vec_cast(x, to, ...)

# S3 method for class 'retroharmonize_labelled_spss_survey.retroharmonize_labelled_spss_survey'
vec_ptype2(x, y, ..., x_arg = "", y_arg = "")

# S3 method for class 'retroharmonize_labelled_spss_survey.double'
vec_ptype2(x, y, ...)

# S3 method for class 'double.retroharmonize_labelled_spss_survey'
vec_ptype2(x, y, ...)

# S3 method for class 'integer.retroharmonize_labelled_spss_survey'
vec_ptype2(x, y, ...)

# S3 method for class 'retroharmonize_labelled_spss_survey.integer'
vec_ptype2(x, y, ...)

# S3 method for class 'double.retroharmonize_labelled_spss_survey'
vec_cast(x, to, ...)

# S3 method for class 'integer.retroharmonize_labelled_spss_survey'
vec_cast(x, to, ...)

# S3 method for class 'character.retroharmonize_labelled_spss_survey'
vec_cast(x, to, ...)

# S3 method for class 'retroharmonize_labelled_spss_survey'
vec_ptype2(x, y, ..., x_arg = "", y_arg = "")

# S3 method for class 'retroharmonize_labelled_spss_survey'
vec_cast(x, to, ..., x_arg = "", to_arg = "")
```

## Details

They ensure that labelled survey vectors:

- combine safely with numeric vectors,

- cast consistently to base types,

- error on incompatible coercions.

These functions are part of the internal type system and are not
intended to be called directly by users.

They ensure that labelled survey vectors:

- combine safely with numeric vectors,

- cast consistently to base types,

- error on incompatible coercions.

These functions are part of the internal type system and are not
intended to be called directly by users.
