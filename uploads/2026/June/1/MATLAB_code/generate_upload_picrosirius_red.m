function generate_upload_picrosirius_red

% Variables
expt_data_files = ["../expt_data/relative_collagen_content_for_database_upload_19June26.xlsx"];
output_file = '../upload/picro_sirius_upload.csv';
 
% Code

% Start by reading the experimental data
d = [];
for i = 1 : numel(expt_data_files)
    d_temp = readtable(expt_data_files(i));
    d = [d ; d_temp];
end
dn = d.Properties.VariableNames'
size_d = size(d);

% Create the upload file
up.record_id = d.hashcode;
up.redcap_repeat_instrument = repmat({'histology'}, [size(d,1), 1]);
up.redcap_repeat_instance = repmat({'new'}, [size(d,1), 1]);
up.hist_data_url = d.lab_archives_link;
up.hist_expt_date = datetime(d.experiment_date);
up.hist_picro_prop_collagen = d.relative_collagen_content_psr;

% Set the region codes
d.region = strrep(d.region, "LV", "LV ");
d.region = strrep(d.region, "LA", "Left atrium");
d.region = strrep(d.region, "RA", "Right atrium");

for i = 1 : size(d,1)
    rc = return_region_index(d.region{i});
    if (~isnan(rc))
        up.hist_region{i} = sprintf('%i', rc);
    else
        up.hist_region{i} = '';
    end
end

up = columnize_structure(up);
up = struct2table(up)

up.hist_expt_date.Format = 'yyyy-MM-dd';

% Write out
try
    delete(output_file);
end
writetable(up, output_file, delim=',')
