function generate_collagen_upload

tubulin_prop_data_file = '../expt_data/master_hyp_3groups_assay.xlsx';
output_file = '../upload/hydroxyproline_prop_upload.csv';
lab_archives_url = 'https://mynotebook.labarchives.com/share/Campbell%2520Lab/MTA3Ni40fDY3MzMyMS84MjgtMzIxMi9UcmVlTm9kZS8yODY4NDAxMzE5fDI3MzIuMzk5OTk5OTk5OTk5Ng==';
date_string = '2024-05-11';

% Codea

% Start with titin proportion data
d = readtable(tubulin_prop_data_file);
dn = d.Properties.VariableNames'

% Create the upload file
up_prop.record_id = d.Hashcode
up_prop.redcap_repeat_instrument = repmat({'biochemistry'}, [size(d,1), 1]);
up_prop.redcap_repeat_instance = repmat({'new'}, [size(d,1), 1]);
up_prop.biochem_data_url = repmat({lab_archives_url}, [size(d,1), 1]);
up_prop.biochem_collagen_hydroxy_ug_to_mg = d.collagen_per_tissue_mass;

% Tidy the hashcodes
for i = 1 : size(d,1)
    if strfind(up_prop.record_id{i}, 'O')
        x = x + 1
        up_prop.record_id{i} = strrep(up_prop.record_id{i}, 'O', '0');
    end
end

% Load the gel_prop_spec_number
for i = 1 : size(d,1)
    sp = d.Specimen_(i);
    if (isnan(sp))
        up_prop.biochem_spec_number{i} = '';
    else
        up_prop.biochem_spec_number{i} = sprintf('%.1f', sp);
    end
end

% Set the region codes
for i = 1 : size(d,1)
    rc = return_region_index(d.Region{i});
    if (~isnan(rc))
        up_prop.biochem_region{i} = sprintf('%i', rc);
    else
        up_prop.biochem_region{i} = '';
    end
end

% Set the date
for i = 1 : size(d,1)
    up_prop.biochem_expt_date{i} = date_string;
end

up_prop = columnize_structure(up_prop)
up_prop = struct2table(up_prop)

dr = unique(d.Region)
ur = unique(up_prop.biochem_region)

% Check fields
un = up_prop.Properties.VariableNames'

% Output
try
    delete(output_file);
end
writetable(up_prop, output_file)
