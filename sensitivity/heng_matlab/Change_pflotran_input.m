openfolder = 'C:/Users/daih524/Desktop/2015_Spring/Sensitivity_Analysis/Test_Case/input_deck/pflotran.in';
fid = fopen(openfolder,'r');
i = 1;
tline = fgetl(fid);
A{i} = tline;
while ischar(tline)
    i = i+1;
    tline = fgetl(fid);
    A{i} = tline;
end
fclose(fid);
for j = 1:100
    A{60} = sprintf('  FILENAME ../BC_sim%d.h5',j);
    A{66} = sprintf('  FILENAME ../BC_sim%d.h5',j);
    A{72} = sprintf('  FILENAME ../BC_sim%d.h5',j);
    A{78} = sprintf('  FILENAME ../BC_sim%d.h5',j);
    fid = fopen(sprintf('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Input_deck/pflotran%d.in',j), 'w');
    for i = 1:numel(A)
        if A{i+1} == -1
            fprintf(fid,'%s', A{i});
            break
        else
            fprintf(fid,'%s\n', A{i});
        end
    end
    fclose(fid);
end
