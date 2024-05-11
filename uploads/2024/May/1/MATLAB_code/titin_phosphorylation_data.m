function titin_phosphorylation_upload

titin_phosp_data_file = '../expt_data/phospho_titin_raw_data_5may24_vetted.xlsx';
output_file = '../upload/titin_phosph_upload.csv';
lab_archives_url = 'https://mynotebook.labarchives.com/share/Campbell%2520Lab/MTA3My44fDY3MzMyMS84MjYtMzIxNC9UcmVlTm9kZS8yNDcyMDg5NDQ3fDI3MjUuNzk5OTk5OTk5OTk5Nw==';
date_string = '2024-05-11';

% Code

% Start with titin proportion data
d = readtable(titin_phosp_data_file);
dn = d.Properties.VariableNames'

% Create the upload file
up.record_id = d.hash_code
up.redcap_repeat_instrument = repmat({'gel_phosphorylation'}, [size(d,1), 1]);
up.redcap_repeat_instance = repmat({'new'}, [size(d,1), 1]);
up.gel_phosp_data_url = repmat({lab_archives_url}, [size(d,1), 1]);
up.gel_phoph_titin_n2ba_rel = d.Rel_pN2BA;
up.gel_phoph_titin_n2b_rel = d.Rel_pN2B;

% Tidy the hashcodes
x = 0;
for i = 1 : size(d,1)
    if strfind(up.record_id{i}, 'O')
        x = x + 1;
        up.record_id{i} = strrep(up.record_id{i}, 'O', '0');
    end
end

% Load the gel_prop_spec_number
for i = 1 : size(d,1)
    sp = d.SpecimenNo_(i);
    if (isnan(sp))
        up.gel_prop_spec_number{i} = '';
    else
        up.gel_prop_spec_number{i} = sprintf('%.1f', sp);
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

% Set the date
for i = 1 : size(d,1)
    up.gel_prop_expt_date{i} = date_string;
end

up = columnize_structure(up)
up = struct2table(up)

return


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
