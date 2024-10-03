function generate_upload

% Fix path
addpath('C:\ken\GitHub\CampbellMuscleLab\MATLAB\MATLAB_utilities');
addpath('C:\ken\GitHub\CampbellMuscleLab\MATLAB\MATLAB_cardiac_biobank');

% Variables
expt_data_files = {
    '../expt_data/mybpc_ser273_collated_september24.xlsx', ...
    '../expt_data/mybpc_ser282_collated_september24.xlsx', ...
    '../expt_data/mybpc_ser302_collated_september24.xlsx'};

output_files = { ...
    '../upload/mybpc_ser273.csv', ...
    '../upload/mybpc_ser282.csv', ...
    '../upload/mybpc_ser302.csv'};

expt_data_field_strings = { ...
    'norm_MyBPC_phos_Ser273', ...
    'norm_MyBPC_phos_Ser282', ...
    'norm_MyBPC_phos_Ser302'};

redcap_field_strings = { ...
    'gel_phos_mybpc_s273_rel', ...
    'gel_phos_mybpc_s282_rel', ...
    'gel_phos_mybpc_s302_rel'};

% Code

for fc = 1 : numel(expt_data_files)
    
    % Start by reading the experimental data
    d = readtable(expt_data_files{fc});
    dn = d.Properties.VariableNames'
    
    % Create the upload file
    up = [];
    up.record_id = d.Hashcode;
    up.redcap_repeat_instrument = repmat({'gel_phosphorylation'}, [size(d,1), 1]);
    up.redcap_repeat_instance = repmat({'new'}, [size(d,1), 1]);
    up.gel_phos_data_url = d.lab_archives_link;
    up.gel_phos_expt_date = datetime(d.Experiment_Date);
    up.(redcap_field_strings{fc}) = d.(expt_data_field_strings{fc});
    
    % Set the spec_number
    for i = 1 : size(d,1)
        sp = d.Specimen_No(i);
        if (isnumeric(sp))
            up.gel_phos_spec_number{i} = sprintf('%.1f', sp);
        else
            error('ken')
        end
    end
    
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
        delete(output_files{fc});
    end
    writetable(up, output_files{fc}, delim=',')

end