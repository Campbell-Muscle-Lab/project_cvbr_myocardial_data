# Project_cvbr_myocardial_data

This is a framework to organize data that relates to human myocardial specimens in the Gill Cardiovascular Biorepository.

This repo does not contain source code. All of the functionality is handed by [MATLAB_cardiac_biobank](https://github.com/kenatcampbellmusclelab/MATLAB_cardiac_biobank)

This document explains how to:

+ [upload new experimental data](upload/upload.md)
+ merge the experimental data with clinical results
+ deidentify the merged data and share with others

## Organization


````mermaid

flowchart TD

    style new_expts fill:#f90
    style figs fill:#f90
    style onc_inv fill:#f9f
    style clin_db fill:#f9f
    style merge fill:#0ff
    style dc fill:#0ff
    style expt_db fill:#0ff
    style od fill:#0ff
    

    pqd --> a_ef
    a_ef -->dc_in
    oi --> oi_process
    oi_process --> b_ef
    b_ef --> dc_in
    dc_in --> dc_MATLAB
    dc_MATLAB --> c_cvs
    c_cvs --> c_process
    c_process --> expt_db_cd
    expt_db_cd --> expt_db_api
    expt_db_api --> d_ef
    d_ef --> merge_in
    clin_db_db --> clin_db_ef
    clin_db_ef --> e_ef
    e_ef --> merge_in
    merge_in --> merge_MATLAB
    merge_MATLAB --> f_ef
    f_ef --> od_cd
    od_cd --> |Outdated data\nmoved to legacy folder\nwith MATLAB|od_lf
    od_cd -->figs_make
    
    subgraph new_expts[New experiments]
    pqd[Publication quality data]
    end

    subgraph onc_inv[Sample inventory in Oncore]
    oi[Information about\nsamples]
    oi_process[Manual pull]
    end

    subgraph a[ ]
        a_ef[Excel file]
        a_notes[Contains:\ndata\nspecimen number\nexperiment date\nurl to data source]
    end

    subgraph b[ ]
        b_ef[Excel file]
        b_notes[Contains:\nspecimen number\nhashcode\nsample region]
    end

    subgraph resp[Responsibilities]
        lab[Lab]
        ken[Ken]
        megan[Megan]
        style lab fill:#f90
        style megan fill:#f9f
        style ken fill:#0ff
    end

    subgraph merge[Merge databases]
        merge_in[Input]
        merge_MATLAB[MATLAB]
    end

    subgraph c[ ]
        c_cvs[CVS file]
        c_process[Manual upload]
        c_notes[Specially formatted for REDCap]
    end

    subgraph expt_db[Experimental data in REDCap]
        expt_db_cd[Collated data]
        expt_db_api[REDCap API]
    end

    subgraph d[ ]
        d_ef[Excel file]
        d_notes[Contains:\nspecimen number\nhashcode\nspecimen region\nexperiment date\nexperimental data\nurl to data source]
    end

    subgraph e[ ]
        e_ef[Excel file]
        e_notes[Contains:\nhashcode\nclinical data]
    end
    
    subgraph clin_db[Clinical data in REDCap]
        clin_db_db[Clinical data]
        clin_db_ef[RECap API]
    end

    subgraph f[ ]
        f_ef[Excel file]
        f_notes[Contains:\nspecimen number\nhashcode\nspecimen region\nexperiment date\nexperimental data\nurl to data\nclinical data]
    end


    subgraph dc[Data cleaning]
        dc_in[Input]
        dc_MATLAB[MATLAB]
    end

    subgraph od[OneDrive]
    od_cd[Current data]
    od_lf[Legacy folder]
    end

    subgraph figs[Figure creation]
    figs_make[Latest Data can be\ndownloaded from\nOneDrive to\nmake figures]
    end
````

