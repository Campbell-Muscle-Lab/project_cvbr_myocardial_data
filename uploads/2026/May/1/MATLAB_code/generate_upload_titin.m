function generate_upload_titin

% Fix path
addpath('d:\ken\GitHub\CampbellMuscleLab\MATLAB\MATLAB_cardiac_biobank');

% Variables
expt_data_file = '../expt_data/titin_collated_May26.xlsx';
output_file = '../upload/titin_upload.csv';

% Code

% Start by reading the experimental dataa
d = readtable(expt_data_file);
dn = d.Properties.VariableNames'
size_d = size(d)

n_unique_hashcode = numel(unique(d.Hashcode))

% Create the upload file
up.record_id = d.Hashcode;
up.redcap_repeat_instrument = repmat({'gel_proportion'}, [size(d,1), 1]);
up.redcap_repeat_instance = repmat({'new'}, [size(d,1), 1]);
up.gel_prop_data_url = d.lab_archives_link;
up.gel_prop_expt_date = datetime(d.Experiment_Date);
up.gel_prop_titin_n2ba = 0.01 * d.rel_N2BA;

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
