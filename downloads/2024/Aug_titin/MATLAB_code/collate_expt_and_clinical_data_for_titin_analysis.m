function collate_expt_and_clinical_data_for_titin_analysis

% Variables
data_file_string = '../downloaded_data/merged_deidentified_data_18-Aug-2024_17_56_00.xlsx';
output_file_string = '../output/collated_data.xlsx';

% Load data
d = readtable(data_file_string);
d.record_id = correct_hashcodes(d.record_id);

dn = d.Properties.VariableNames'

% Cut some field names
bi = find( ...
        startsWith(dn, 'mech') | ...
        contains(dn, 'complete'));

d = removevars(d, dn(bi));

sd = size(d)

% Now find rows that contain data

dn = d.Properties.VariableNames;
gi = find( ...
        startsWith(dn, 'gel') | ...
        startsWith(dn, 'hist')| ...
        startsWith(dn, 'biochm'));

gn = dn(gi);

bi = []
for ri = 1 : size(d, 1)
    keep = 0;
    for gi = 1 : numel(gn)
        y = d.(gn{gi})(ri);
        if (isnumeric(y))
            if (~isnan(y))
                keep = keep + 1;
            end
        else
            if (~strcmp(y, ''))
                keep = keep + 1;
            end
        end
    end
    
    if (keep == 0)
        bi = [bi ri];
    end
end

d(bi, :) = [];

% Write to disk
try
    delete(output_file_string);
end
writetable(d, output_file_string);
