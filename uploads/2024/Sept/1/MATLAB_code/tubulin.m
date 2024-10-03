function generate_upload

% Fix path
addpath('C:\ken\GitHub\CampbellMuscleLab\MATLAB\MATLAB_utilities');
addpath('C:\ken\GitHub\CampbellMuscleLab\MATLAB\MATLAB_cardiac_biobank');

% Variables
expt_data_file = '../expt_data/tubulin_collated_september24.xlsx';
output_file = '../upload/tubulin_upload.csv';

% Code

% Start by reading the experimental data
d = readtable(expt_data_file);
dn = d.Properties.VariableNames'

% Create the upload file
up.record_id = d.Hashcode;
up.redcap_repeat_instrument = repmat({'gel_proportion'}, [size(d,1), 1]);
up.redcap_repeat_instance = repmat({'new'}, [size(d,1), 1]);
up.gel_prop_data_url = d.lab_archives_link;
up.gel_prop_expt_date = datetime(d.Experiment_Date);
up.gel_prop_alpha_tubulin_to_actin = d.normalized_Tubulin_band_area;

% Set the spec_number
for i = 1 : size(d,1)
    sp = d.Specimen_No(i);
    if (isnumeric(sp))
        up.gel_prop_spec_number{i} = sprintf('%.1f', sp);
    else
        error('ken')
    end
end

% Set the region codes
for i = 1 : size(d,1)
    rc = return_region_index(d.Region{i});
    if (~isnan(rc))
        up.gel_prop_region{i} = sprintf('%i', rc);
    else
        up.gel_prop_region{i} = '';
    end
end


up = columnize_structure(up);
up = struct2table(up)

up.gel_prop_expt_date.Format = 'yyyy-MM-dd';

% Write out
try
    delete(output_file);
end
writetable(up, output_file, delim=',')
