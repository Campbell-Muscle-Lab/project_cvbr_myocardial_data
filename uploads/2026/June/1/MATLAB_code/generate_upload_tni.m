function generate_upload_tni

% Fix path
addpath('d:\ken\GitHub\CampbellMuscleLab\MATLAB\MATLAB_cardiac_biobank');

% Variables
expt_data_files = ["../expt_data/HFpEF_grant_TnI_gel_1.xlsx", ...
                    "../expt_data/HFpEF_grant_TnI_gel_2.xlsx"];
output_file = '../upload/tni_phosph_upload.csv';
% 
% oncore_report_file = "../expt_data/oncore_report.xlsx";

% Code

% Start by reading the experimental data
d = [];
for i = 1 : numel(expt_data_files)
    d_temp = readtable(expt_data_files(i));
    d = [d ; d_temp];
end
dn = d.Properties.VariableNames'
size_d = size(d)

% Create the upload file
up.record_id = d.Hashcode;
up.redcap_repeat_instrument = repmat({'gel_phosphorylation'}, [size(d,1), 1]);
up.redcap_repeat_instance = repmat({'new'}, [size(d,1), 1]);
up.gel_phos_data_url = d.lab_archives_link;
up.gel_phos_expt_date = datetime(d.Experiment_Date);
up.gel_phos_tni_phostag_moles = d.mol_pi_per_mol_tni;

% Set the specimen number
up.gel_phos_spec_number = string(d.Specimen_No);

% Set the region codes
for i = 1 : size(d,1)
    rc = return_region_index(d.Region{i});
    if (~isnan(rc))
        up.gel_phos_region{i} = sprintf('%i', rc);
    else
        up.gel_phos_region{i} = '';
    end
end


up = columnize_structure(up);
up = struct2table(up)

up.gel_phos_expt_date.Format = 'yyyy-MM-dd';

% Write out
try
    delete(output_file);
end
writetable(up, output_file, delim=',')
