function comparison

expt_data_file = '../expt_data/TnI_phostag_collated_september24.xlsx';

d = readtable(expt_data_file);
dn = d.Properties.VariableNames'

hc = unique(d.Hashcode);

figure(1);
clf
hold on;

counter = 0;

for i = 1 : numel(hc)

    vi = find(strcmp(d.Hashcode, hc{i}));

    if (numel(vi) == 2)
        counter = counter + 1;
        x(counter) = d.mol_pi_per_mol_tni(vi(1));
        y(counter) = d.mol_pi_per_mol_tni(vi(2));
    end
end

fit_linear_model(x, y, 'figure_handle', 1)


