function titin_phosphorylation_upload

titin_phosp_data_file = '../expt_data/phospho_titin_raw_data_14may24.xlsx';
output_file = '../upload/titin_phosph_upload.csv';
lab_archives_url = 'https://mynotebook.labarchives.com/share/Campbell%2520Lab/MTA3My44fDY3MzMyMS84MjYtMzIxNC9UcmVlTm9kZS8yNDcyMDg5NDQ3fDI3MjUuNzk5OTk5OTk5OTk5Nw==';

% Code

% Start with titin proportion data
d = readtable(titin_phosp_data_file);
dn = d.Properties.VariableNames'

d.norm_N2B = d.N2B_Area ./ d.Control_N2B_Area;
d.norm_N2BA = d.N2BA_Area ./ d.Control_N2BA_Area;

d.norm_pN2B = d.pN2B_Area ./ d.Control_pN2B_Area;
d.norm_pN2BA = d.pN2BA_Area ./ d.Control_pN2BA_Area;

d.rel_pN2B = d.norm_pN2B ./ d.norm_N2B;
d.rel_pN2BA = d.norm_pN2BA ./ d.norm_N2BA;


% Create the upload file
up.record_id = d.Hashcode;
up.redcap_repeat_instrument = repmat({'gel_phosphorylation'}, [size(d,1), 1]);
up.redcap_repeat_instance = repmat({'new'}, [size(d,1), 1]);
up.gel_phos_data_url = repmat({lab_archives_url}, [size(d,1), 1]);
up.gel_phos_titin_n2ba_rel = d.rel_pN2BA;
up.gel_phos_titin_n2b_rel = d.rel_pN2B;

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
    sp = d.Specimen_no(i);
    if (isnan(sp))
        up.gel_phos_spec_number{i} = '';
    else
        up.gel_phos_spec_number{i} = sprintf('%.1f', sp);
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

% Set the date
for i = 1 : size(d,1)
    ds = d.Experiment_Date(i);
    up.gel_phos_expt_date{i} = datestr(ds, 'YYYY-mm-dd');
end

up = columnize_structure(up)
up = struct2table(up)

dr = unique(d.Region)
ur = unique(up.gel_phos_region)

% Check fields
un = up.Properties.VariableNames'

% Output
try
    delete(output_file);
end
writetable(up, output_file)
