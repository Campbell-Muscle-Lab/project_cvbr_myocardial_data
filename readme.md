# Project_cvbr_myocardial_data

This is a framework to organize data that relates to human myocardial specimens in the Gill Cardiovascular Biorepository.

This repo does not contain source code. All of the functionality is handed by [MATLAB_cardiac_biobank](https://github.com/kenatcampbellmusclelab/MATLAB_cardiac_biobank)

This document explains how:

+ to [upload new experimental data](docs/upload/upload.md)
+ the clinical results are [deidentified and merged](docs/deid_and_merge/deid_and_merge.md) with the experimental data
+ the [merged data are updated on OneDrive](docs/onedrive/onedrive.md)

## Organization


````mermaid

flowchart TD

    style new_expts fill:#990
    style figs fill:#990
    style onc_inv fill:#933
    style clin_db fill:#933
    style merge fill:#00f
    style dc fill:#00f
    style expt_db fill:#00f
    style od fill:#00f
    

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
    od_cd --> sb_pr
    sb_pr -->figs_make
        
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
        style lab fill:#990
        style megan fill:#933
        style ken fill:#00f
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

    subgraph od[Ken's PC]
        od_cd[Current data]
        od_lf[Legacy folder]
    end

    subgraph sb[SyncBack Pro]
        sb_pr[Profile\nruns on change\nupdates files on OneDrive]
    end

    subgraph figs[Figure creation]
    figs_make[Latest Data can be\ndownloaded from\nOneDrive to\nmake figures]
    end
````

