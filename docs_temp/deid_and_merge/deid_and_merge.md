# Project_cvbr_myocardial_data

## Deidentification and merging

+ Identified clinical data are stored in a REDCap database
+ Experimental data (no PHI) are stored in a separate REDCap database
+ To deidentify and merge the data:
  + Open MATLAB
  + Switch the working directory to the repo for [MATLAB_cardiac_biobank](https://github.com/kenatcampbellmusclelab/MATLAB_cardiac_biobank)
  + Run `update_deidentified_data.m` which
    + pulls the latest version of the clinical data from REDCap
    + deidentifies the data using `deidentify_clinical_data_table.m` from the repo
    + pulls the latest version of the experimental data from REDCap
    + merges the data tables as an outerjoin
    + saves the updated deidentified data to Ken's 36-thread PC at `c:/ken/gill_cvbr_myocardium/merged`
    + moves any older versions of the data to a sub-folder called `old`