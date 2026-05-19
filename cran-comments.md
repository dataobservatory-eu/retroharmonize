## Test environments

Local:
* Windows10 x86_64-w64-mingw32 (64-bit), R version 4.5.0, locally.

r_hub:
* various platforms, mac, Windows, Ubuntu, Fedora.

0 errors ✔ | 0 warnings ✔ | 0 notes ✔
There are two NOTES:

## resubmission 

- The 0.2.8 is a resubmission of 0.2.7 that was offered out of the time
window to retain the package on CRAN due to an archived dependency.

- Dependencies were modernised. Unit test were updated, extended, and some small 
(earlier not flagged) edge cases better handled.

- No change in the function API.

## NOTE 1
lines wider than 90 characters:
The >90 character usage line is auto-generated for an exported S3 method with 
a long class name and cannot be shortened without breaking the public API; 
a shorter class name would hide the inheritance of this class.
`retroharmonize_labelled_spss_survey.retroharmonize_labelled_spss_survey` 

## NOTE 2

installed size is  5.7Mb
     sub-directories of 1Mb or more:
       doc        1.1Mb
       examples   1.9Mb

The size of the package did not increse since the last release on CRAN. 
Because of the nature of the package (harmonizing real-life surveys) the
examples are relatively great in size (with permission, we use small subsets of 
actual Eurobarometer surveys.) This makes unit-testing and documenting with 
vignettes much easier and more realistic for the user.


