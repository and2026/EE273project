

s = readtable('outputs_13_14');

time = table2array(s(3:end, 1));

fext_diff = [table2array(s(3:end, 2)), table2array(s(3:end, 3)), table2array(s(3:end, 4)), table2array(s(3:end, 5)), table2array(s(3:end, 6))];
next_diff = [table2array(s(3:end, 7)), table2array(s(3:end, 8)), table2array(s(3:end, 9)), table2array(s(3:end, 10)), table2array(s(3:end, 11))];

fmax = zeros(1,5);
nmax = zeros(1,5);
for i = 1:5
    index = find(abs(fext_diff(:,i))==max(abs(fext_diff(:,i))), 1);
    fmax(i) = fext_diff(index,i);
    index = find(abs(next_diff(:,i))==max(abs(next_diff(:,i))), 1);
    nmax(i) = next_diff(index,i);
end