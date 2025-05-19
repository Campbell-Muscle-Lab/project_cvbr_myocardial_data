function generate_upload

% Fix patha
addpath('C:\ken\GitHub\CampbellMuscleLab\MATLAB\MATLAB_utilities');
addpath('C:\ken\GitHub\CampbellMuscleLab\MATLAB\MATLAB_cardiac_biobank');

% Variables
expt_data_files = {
    '../expt_data/hyp_collated_May25.xlsx'};

output_files = { ...
    '../upload/hyp.csv'};

expt_data_field_strings = { ...
    'HYP_per_tissue_mass'};

redcap_field_strings = { ...
    'biochem_hydroxy_ug_to_mg'};

% Code

for fc = 1 : 1
    
    % Start by reading the experimental data
    d = readtable(expt_data_files{fc});
    dn = d.Properties.VariableNames'
    
    % Create the upload file
    up = [];
    up.record_id = d.Hashcode;
    up.redcap_repeat_instrument = repmat({'biochemistry'}, [size(d,1), 1]);
    up.redcap_repeat_instance = repmat({'new'}, [size(d,1), 1]);
    up.biochem_data_url = d.lab_archives_link;
    up.biochem_expt_date = datetime(d.Experiment_Date);
    up.(redcap_field_strings{fc}) = d.(expt_data_field_strings{fc});
    
    % Set the spec_number
    for i = 1 : size(d,1)
        sp = d.Specimen_No(i);
        if (isnumeric(sp))
            up.biochem_spec_number{i} = sprintf('%.1f', sp);
        else
            error('ken')
        end
    end
    
    % Set the region codes
    for i = 1 : size(d,1)
        rc = return_region_index(d.Region{i});
        if (~isnan(rc))
            up.biochem_region{i} = sprintf('%i', rc);
        else
            up.biochem_region{i} = '';
        end
    end
    
    
    up = columnize_structure(up);
    up = struct2table(up)
    
    up.biochem_expt_date.Format = 'yyyy-MM-dd';
    
    % Write out
    try
        delete(output_files{fc});
    end
    writetable(up, output_files{fc}, delim=',')

end