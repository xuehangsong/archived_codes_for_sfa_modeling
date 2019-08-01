nsim = 100;
openfolder1 = 'C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Uncertainty_output/BC_1_MID_1/New_results_all_wells';
openfolder2 = 'C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Uncertainty_output/BC_1_MID_2/New_results_all_wells';
openfolder3 = 'C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Uncertainty_output/BC_1_MID_Base/New_results_all_wells';
openfolder4 = 'C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Uncertainty_output/BC_1_MID_Kriging/New_results_all_wells';
openfolder5 = 'C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Uncertainty_output/BC_2_MID_1/New_results_all_wells';
openfolder6 = 'C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Uncertainty_output/BC_2_MID_2/New_results_all_wells';
openfolder7 = 'C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Uncertainty_output/BC_2_MID_Base/New_results_all_wells';
openfolder8 = 'C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Uncertainty_output/BC_2_MID_Kriging/New_results_all_wells';
openfolder9 = 'C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Uncertainty_output/BC_3_MID_1/New_results_all_wells';
openfolder10 = 'C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Uncertainty_output/BC_3_MID_2/New_results_all_wells';
openfolder11 = 'C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Uncertainty_output/BC_3_MID_Base/New_results_all_wells';
openfolder12 = 'C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Uncertainty_output/BC_3_MID_Kriging/New_results_all_wells';
openfolder13 = 'C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Uncertainty_output/BC_Kriging_MID_1/New_results_all_wells';
openfolder14 = 'C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Uncertainty_output/BC_Kriging_MID_2/New_results_all_wells';
openfolder15 = 'C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Uncertainty_output/BC_Kriging_MID_Base/New_results_all_wells';
openfolder16 = 'C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Uncertainty_output/BC_Kriging_MID_Kriging/New_results_all_wells';
[Time,Head_1,fluxavc1,fluxavc2,wellname1,wellnamegroup1] = Read_observation_well_data_uncertainty(openfolder1);
for i = 1:nsim
    Timet{1,1,i} = Time{i};
    Headt{1,1,i} = Head_1{i};
    fluxavc1t{1,1,i} = fluxavc1{i};
    fluxavc2t{1,1,i} = fluxavc2{i};
%    fluxavc3t{1,1,i} = fluxavc3{i};
end
disp('1 has finished');
[Time,Head_1,fluxavc1,fluxavc2,wellname2,wellnamegroup2] = Read_observation_well_data_uncertainty(openfolder2);
for i = 1:nsim
    Timet{1,2,i} = Time{i};
    Headt{1,2,i} = Head_1{i};
    fluxavc1t{1,2,i} = fluxavc1{i};
    fluxavc2t{1,2,i} = fluxavc2{i};
%    fluxavc3t{1,2,i} = fluxavc3{i};
end
disp('2 has finished');
[Time,Head_1,fluxavc1,fluxavc2,wellname3,wellnamegroup3] = Read_observation_well_data_uncertainty(openfolder3);
for i = 1:nsim
    Timet{1,3,i} = Time{i};
    Headt{1,3,i} = Head_1{i};
    fluxavc1t{1,3,i} = fluxavc1{i};
    fluxavc2t{1,3,i} = fluxavc2{i};
%    fluxavc3t{1,3,i} = fluxavc3{i};
end
disp('3 has finished');
[Time,Head_1,fluxavc1,fluxavc2,wellname4,wellnamegroup4] = Read_observation_well_data_uncertainty(openfolder4);
for i = 1:nsim
    Timet{1,4,i} = Time{i};
    Headt{1,4,i} = Head_1{i};
    fluxavc1t{1,4,i} = fluxavc1{i};
    fluxavc2t{1,4,i} = fluxavc2{i};
%    fluxavc3t{1,4,i} = fluxavc3{i};
end
disp('4 has finished');
[Time,Head_1,fluxavc1,fluxavc2,wellname5,wellnamegroup5] = Read_observation_well_data_uncertainty(openfolder5);
for i = 1:nsim
    Timet{2,1,i} = Time{i};
    Headt{2,1,i} = Head_1{i};
    fluxavc1t{2,1,i} = fluxavc1{i};
    fluxavc2t{2,1,i} = fluxavc2{i};
%    fluxavc3t{2,1,i} = fluxavc3{i};
end
disp('5 has finished');
[Time,Head_1,fluxavc1,fluxavc2,wellname6,wellnamegroup6] = Read_observation_well_data_uncertainty(openfolder6);
for i = 1:nsim
    Timet{2,2,i} = Time{i};
    Headt{2,2,i} = Head_1{i};
    fluxavc1t{2,2,i} = fluxavc1{i};
    fluxavc2t{2,2,i} = fluxavc2{i};
%    fluxavc3t{2,2,i} = fluxavc3{i};
end
disp('6 has finished');
[Time,Head_1,fluxavc1,fluxavc2,wellname7,wellnamegroup7] = Read_observation_well_data_uncertainty(openfolder7);
for i = 1:nsim
    Timet{2,3,i} = Time{i};
    Headt{2,3,i} = Head_1{i};
    fluxavc1t{2,3,i} = fluxavc1{i};
    fluxavc2t{2,3,i} = fluxavc2{i};
%    fluxavc3t{2,3,i} = fluxavc3{i};
end
disp('7 has finished');
[Time,Head_1,fluxavc1,fluxavc2,wellname8,wellnamegroup8] = Read_observation_well_data_uncertainty(openfolder8);
for i = 1:nsim
    Timet{2,4,i} = Time{i};
    Headt{2,4,i} = Head_1{i};
    fluxavc1t{2,4,i} = fluxavc1{i};
    fluxavc2t{2,4,i} = fluxavc2{i};
 %   fluxavc3t{2,4,i} = fluxavc3{i};
end
disp('8 has finished');
[Time,Head_1,fluxavc1,fluxavc2,wellname9,wellnamegroup9] = Read_observation_well_data_uncertainty(openfolder9);
for i = 1:nsim
    Timet{3,1,i} = Time{i};
    Headt{3,1,i} = Head_1{i};
    fluxavc1t{3,1,i} = fluxavc1{i};
    fluxavc2t{3,1,i} = fluxavc2{i};
%    fluxavc3t{3,1,i} = fluxavc3{i};
end
disp('9 has finished');
[Time,Head_1,fluxavc1,fluxavc2,wellname10,wellnamegroup10] = Read_observation_well_data_uncertainty(openfolder10);
for i = 1:nsim
    Timet{3,2,i} = Time{i};
    Headt{3,2,i} = Head_1{i};
    fluxavc1t{3,2,i} = fluxavc1{i};
    fluxavc2t{3,2,i} = fluxavc2{i};
 %   fluxavc3t{3,2,i} = fluxavc3{i};
end
disp('10 has finished');
[Time,Head_1,fluxavc1,fluxavc2,wellname11,wellnamegroup11] = Read_observation_well_data_uncertainty(openfolder11);
for i = 1:nsim
    Timet{3,3,i} = Time{i};
    Headt{3,3,i} = Head_1{i};
    fluxavc1t{3,3,i} = fluxavc1{i};
    fluxavc2t{3,3,i} = fluxavc2{i};
 %   fluxavc3t{3,3,i} = fluxavc3{i};
end
disp('11 has finished');
[Time,Head_1,fluxavc1,fluxavc2,wellname12,wellnamegroup12] = Read_observation_well_data_uncertainty(openfolder12);
for i = 1:nsim
    Timet{3,4,i} = Time{i};
    Headt{3,4,i} = Head_1{i};
    fluxavc1t{3,4,i} = fluxavc1{i};
    fluxavc2t{3,4,i} = fluxavc2{i};
 %   fluxavc3t{3,4,i} = fluxavc3{i};
end
disp('12 has finished');
[Time,Head_1,fluxavc1,fluxavc2,wellname13,wellnamegroup13] = Read_observation_well_data_uncertainty(openfolder13);
for i = 1:nsim
    Timet{4,1,i} = Time{i};
    Headt{4,1,i} = Head_1{i};
    fluxavc1t{4,1,i} = fluxavc1{i};
    fluxavc2t{4,1,i} = fluxavc2{i};
 %   fluxavc3t{4,1,i} = fluxavc3{i};
end
disp('13 has finished');
[Time,Head_1,fluxavc1,fluxavc2,wellname14,wellnamegroup14] = Read_observation_well_data_uncertainty(openfolder14);
for i = 1:nsim
    Timet{4,2,i} = Time{i};
    Headt{4,2,i} = Head_1{i};
    fluxavc1t{4,2,i} = fluxavc1{i};
    fluxavc2t{4,2,i} = fluxavc2{i};
 %   fluxavc3t{4,2,i} = fluxavc3{i};
end
disp('14 has finished');
[Time,Head_1,fluxavc1,fluxavc2,wellname15,wellnamegroup15] = Read_observation_well_data_uncertainty(openfolder15);
for i = 1:nsim
    Timet{4,3,i} = Time{i};
    Headt{4,3,i} = Head_1{i};
    fluxavc1t{4,3,i} = fluxavc1{i};
    fluxavc2t{4,3,i} = fluxavc2{i};
 %   fluxavc3t{4,3,i} = fluxavc3{i};
end
disp('15 has finished');
[Time,Head_1,fluxavc1,fluxavc2,wellname16,wellnamegroup16] = Read_observation_well_data_uncertainty(openfolder16);
for i = 1:nsim
    Timet{4,4,i} = Time{i};
    Headt{4,4,i} = Head_1{i};
    fluxavc1t{4,4,i} = fluxavc1{i};
    fluxavc2t{4,4,i} = fluxavc2{i};
 %   fluxavc3t{4,4,i} = fluxavc3{i};
end
disp('16 has finished');