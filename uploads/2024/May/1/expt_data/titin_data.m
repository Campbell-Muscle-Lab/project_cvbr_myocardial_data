function generate_titin_upload

titin_prop_data_file = '../expt_data/titin_isoform_raw_data_5May24_vetted.xlsx';

% Code

% Start with titin proportion data
d = readtable(titin_prop_data_file);
dn = d.Properties.VariableNames'

% Create the upload file
up_prop.record_id = char(d.hash_code)
up_prop.redcap_repeat_instrument = repmat('gel_proportion', [size(d,1), 1]);
up_prop.redcap_repeat_instance = repmat('new', [size(d,1), 1]);
up_prop.gel_prop_spec_number = d.specimen_no;
up_prop.gel_prop_data_url = char(d.lab_archives_link);
up_prop.gel_prop_titin_n2ba = 0.01 * d.Rel_N2BA;

up_prop = columnize_structure(up_prop);
up_prop = struct2table(up_prop)




