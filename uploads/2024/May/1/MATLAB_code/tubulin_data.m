function generate_tubulin_upload

tubulin_prop_data_file = '../expt_data/tubulin_raw_data_5May24_vetted.xlsx';
output_file = '../upload/tubulin_prop_upload.csv';
lab_archives_url = 'https://mynotebook.labarchives.com/share/Campbell%2520Lab/MTA3NS4xMDAwMDAwMDAwMDAxfDY3MzMyMS84MjctMzIxMS9UcmVlTm9kZS8zNTk1MDMyNzYwfDI3MjkuMQ==';
date_string = '2024-05-11';

% Code

% Start with titin proportion data
d = readtable(tubulin_prop_data_file);
dn = d.Properties.VariableNames'

% Create the upload file
up_prop.record_id = d.hash_code
up_prop.redcap_repeat_instrument = repmat({'gel_proportion'}, [size(d,1), 1]);
up_prop.redcap_repeat_instance = repmat({'new'}, [size(d,1), 1]);
up_prop.gel_prop_data_url = repmat({lab_archives_url}, [size(d,1), 1]);
up_prop.gel_prop_alpha_tubulin_to_actin = d.Norm_Alpha_Tubulin_band_area;

% Tidy the hashcodes
for i = 1 : size(d,1)
    if strfind(up_prop.record_id{i}, 'O')
        up_prop.record_id{i} = strrep(up_prop.record_id{i}, 'O', '0');
    end
end

% Load the gel_prop_spec_number
for i = 1 : size(d,1)
    sp = d.SpecimenNo_(i);
    if (isnan(sp))
        up_prop.gel_prop_spec_number{i} = '';
    else
        up_prop.gel_prop_spec_number{i} = sprintf('%.1f', sp);
    end
end

% Set the region codes
for i = 1 : size(d,1)
    rc = return_region_index(d.Region{i});
    if (~isnan(rc))
        up_prop.gel_prop_region{i} = sprintf('%i', rc);
    else
        up_prop.gel_prop_region{i} = '';
    end
end

% Set the date
for i = 1 : size(d,1)
    up_prop.gel_prop_expt_date{i} = date_string;
end

up_prop = columnize_structure(up_prop)
up_prop = struct2table(up_prop)

% Filter out loading controls
bi = find(isnan(up_prop.gel_prop_alpha_tubulin_to_actin));
up_prop(bi,:) = [];

dr = unique(d.Region)
ur = unique(up_prop.gel_prop_region)

% Check fields
un = up_prop.Properties.VariableNames'

% Output
try
    delete(output_file);
end
writetable(up_prop, output_file)
