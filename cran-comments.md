## Test environments

Local:
* Windows10 x86_64-w64-mingw32 (64-bit), R version 4.5.0, locally.

r_hub:
* various platforms, mac, Windows, Ubuntu, Fedora.

0 errors ✔ | 0 warnings ✔ | 1 note

## Resubmission

Version 0.2.8 is a resubmission of 0.2.7. 

The package had previously been archived because dependency dataset
was temporarily archived from CRAN:

- X-CRAN-Comment: Archived on 2026-01-30 as requires archived package
'dataset'.

The dependency dataset has since returned to CRAN and all checks now pass.

## Notes
- Installed size is 5.7 MB. Subdirectories larger than 1 MB: 
   doc 1.1 MB examples 1.9 MB

The package contains small, permission-cleared subsets of real survey
datasets used for examples, testing, and vignettes. These datasets are
necessary to demonstrate realistic harmonization workflows, and had been 
on CRAN for 6 years.


- Automatically generated Rd usage lines for certain vctrs
double-dispatch S3 methods results in long lines. This is due to
standard vctrs method naming conventions and does not affect
package functionality.