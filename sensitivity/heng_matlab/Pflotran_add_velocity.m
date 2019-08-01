for j = 1:100
    openfolder = sprintf('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Multiple simulations results material ID/Input_deck/pflotran%d.in',j);
    fid = fopen(openfolder,'r');
    i = 1;
    tline = fgetl(fid);
    A{i} = tline;
    %B{i} = tline;
    while ischar(tline)
        i = i+1;
        tline = fgetl(fid);
        A{i} = tline;
        %  B{i} = tline;
    end
    fclose(fid);
    C = cell(1960,1);
    for i = 1:163
        C{i} = A{i};
    end
    C{164} = '  VELOCITY_AT_CENTER';
    for i = 0:1795
        C{165+i} = A{164+i};
    end
    fid = fopen(sprintf('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Multiple simulations results material ID/Input_deck_add_velocity/pflotran%d.in',j), 'w');
    for i = 1:numel(C)
        if C{i+1} == -1
            fprintf(fid,'%s', C{i});
            break
        else
            fprintf(fid,'%s\n', C{i});
        end
    end
    fclose(fid);
end