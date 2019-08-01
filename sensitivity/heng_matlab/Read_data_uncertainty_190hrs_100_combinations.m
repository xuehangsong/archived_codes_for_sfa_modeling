nsim = 100;
for i = 2:2:6
    for j = 1:10
        disp(i);
        disp(j);
        clear Time;
        clear Head_1;
        clear fluxavc1;
        clear wellname;
        clear wellnamegroup;
        openfolder = cd;
        openfolder1 = strcat(openfolder,sprintf('/BC_%d_MID_%d',i,j));
        [Time,Head_1,wellname,wellnamegroup] = Read_observation_well_data_uncertainty_190_hrs(openfolder);
        for k = 1:nsim
            Timet{i,j,k} = Time{k};
            Headt{i,j,k} = Head_1{k};
            fluxavc1t{i,j,k} = fluxavc1{k};
        end
        wellnamet{i,j} = wellname;
        wellnamegroupt{i,j} = wellnamegroup;
    end
end
save('H_obs.mat','Headt');
save('Time_obs.mat','Timet');
save('Wellname_obs.mat','wellnamet');
save('Wellnamegroup_obs.mat','wellnamegroupt');