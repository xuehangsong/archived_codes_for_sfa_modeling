% fid1 = fopen('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/well_data_with_sensitivity/well_sensitivity_h_st_100.txt','w+');
% fid2 = fopen('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/well_data_with_sensitivity/well_sensitivity_h_sm_100.txt','w+');
% fid3 = fopen('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/well_data_with_sensitivity/well_sensitivity_h_ss_100.txt','w+');
Well_82 = [6.81 119.90
55.00 85.91
65.12 85.93
60.07 88.75
60.21 94.47
50.13 77.11
70.00 77.26
45.19 68.49
55.06 68.39
64.97 68.59
75.11 68.69
50.06 59.83
59.99 60.00
70.24 59.70
80.05 60.00
65.06 51.29
85.06 51.29
69.94 42.61
80.09 42.46
60.19 78.06
58.67 75.60
61.60 75.79
74.80 52.08
73.59 49.73
76.55 49.76
113.31 119.90
40.14 59.97
35.07 51.17
54.99 51.18
40.30 42.70
50.03 42.38
60.16 42.60
45.10 52.38
43.67 49.63
46.61 49.74
6.81 13.39
45.27 55.89
113.32 13.40
60.11 83.76
75.31 55.99
45.21 94.47
40.00 85.91
35.13 77.11
30.19 68.49
25.14 59.97
20.07 51.17
15.26 42.54
80.12 85.93
85.00 77.26
90.11 68.69
95.05 60.00
100.06 51.29
104.04 42.92
30.26 32.54
40.30 32.70
50.03 32.38
60.16 32.60
69.94 32.61
80.09 32.46
89.04 32.92
30.26 22.54
40.30 22.70
50.03 22.38
60.16 22.60
69.94 22.61
80.09 22.46
89.04 22.92
30.26 12.54
40.30 12.70
50.03 12.38
60.16 12.60
69.94 12.61
80.09 12.46
89.04 12.92
30.26 109.47
40.30 109.47
50.03 109.47
60.16 109.47
69.94 109.47
80.09 109.47
89.04 109.47
75.21 94.47
];
N = 39;
M = 39;
% well_82_st(1:82,1:3,1:N) = 0;
% well_82_sm(1:82,1:3,1:N) = 0;
% well_82_ss(1:82,1:3,1:N) = 0;
% well_82_test(1:82,1:3) = 0;
% well_82_st_c1(1:82,1:3,1:20) = 0;
% well_82_sm_c1(1:82,1:3,1:20) = 0;
% well_82_ss_c1(1:82,1:3,1:20) = 0;
% well_82_st_c2(1:82,1:3,1:40) = 0;
% well_82_sm_c2(1:82,1:3,1:40) = 0;
% well_82_ss_c2(1:82,1:3,1:40) = 0;
% for i = 1:10
%     well_82_st(1:82,1:2,i) = Well_82;
%     well_82_sm(1:82,1:2,i) = Well_82;
%     well_82_ss(1:82,1:2,i) = Well_82;
% end
% for i = 1:10
%     well_82_st_c1(1:82,1:2,i) = Well_82;
%     well_82_sm_c1(1:82,1:2,i) = Well_82;
%     well_82_ss_c1(1:82,1:2,i) = Well_82;
% end
well_82_st_c1_real(1:15,1:3,1:N) = 0;
well_82_ss_c1_real(1:15,1:3,1:N) = 0;
well_82_sm_c1_real(1:15,1:3,1:N) = 0;
for i = 1:N
    m = 0;
    for j = 1:max(size(wellnamegroup))
        if cbreak1(wellindex(j),i) == 1
%             if i == 4
%                 disp(j);
%                 disp(wellindex(j));
%             end
            m = m + 1;
            well_82_st_c1_real(m,1:2,i) = Well_82(j,1:2);
            well_82_st_c1_real(m,3,i) = S_T_c1(wellindex(j),i);
            well_82_sm_c1_real(m,1:2,i) = Well_82(j,1:2);
            well_82_sm_c1_real(m,3,i) = S_M_c1(wellindex(j),i);
            well_82_ss_c1_real(m,1:2,i) = Well_82(j,1:2);
            well_82_ss_c1_real(m,3,i) = S_S_c1(wellindex(j),i);
        end
    end
end
% for i = 1:40
%     well_82_st_c2(1:82,1:2,i) = Well_82;
%     well_82_sm_c2(1:82,1:2,i) = Well_82;
%     well_82_ss_c2(1:82,1:2,i) = Well_82;
% end
% well_82_test(1:82,1:2) = Well_82;
% well_82_test(1:82,3) = S_T(wellh(1:82),1);
% well_82_test(39,3) = 2;
% well_82_st_100(1:82,3) = S_T(wellh(1:82),2);
% well_82_ss_100(1:82,3) = S_S(wellh(1:82),2);
% % well_82_sm_100(1:82,3) = S_M(wellh(1:82),2);
% for i = 1:10
%     well_82_st(1:82,3,i) = S_T(wellh(1:82),i);
%     well_82_sm(1:82,3,i) = S_M(wellh(1:82),i);
%     well_82_ss(1:82,3,i) = S_S(wellh(1:82),i);
% end
% for i = 1:10
%     well_82_st_c1(1:82,3,i) = S_T_c1(wellindex(1:82),i);
%     well_82_sm_c1(1:82,3,i) = S_M_c1(wellindex(1:82),i);
%     well_82_ss_c1(1:82,3,i) = S_S_c1(wellindex(1:82),i);
% end
% for i = 1:40
%     well_82_st_c2(1:82,3,i) = S_T_c2(wellindex(1:82),i);
%     well_82_sm_c2(1:82,3,i) = S_M_c2(wellindex(1:82),i);
%     well_82_ss_c2(1:82,3,i) = S_S_c2(wellindex(1:82),i);
% end
% for i = 1:82
%     fprintf(fid1,'%d %d %d\n', well_82_st_100(i,:));
% end
% fclose(fid1);
% for i = 1:82
%     fprintf(fid2,'%d %d %d\n', well_82_sm_100(i,:));
% end
% fclose(fid2);
% for i = 1:82
%     fprintf(fid3,'%d %d %d\n', well_82_ss_100(i,:));
% end
% fclose(fid3);
% for i = 1:10
%     fid1 = fopen(sprintf(['C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/well_data_with_sensitivity/well_sensitivity_h_ss_%d.txt'],100*i),'w+');
%     fid2 = fopen(sprintf(['C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/well_data_with_sensitivity/well_sensitivity_h_sm_%d.txt'],100*i),'w+');
%     fid3 = fopen(sprintf(['C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/well_data_with_sensitivity/well_sensitivity_h_st_%d.txt'],100*i),'w+');
%     for j = 1:82
%         fprintf(fid1,'%d %d %d\n', well_82_ss(j,:,i));
%     end
%     for j = 1:82
%         fprintf(fid2,'%d %d %d\n', well_82_sm(j,:,i));
%     end 
%     for j = 1:82
%         fprintf(fid3,'%d %d %d\n', well_82_st(j,:,i));
%     end 
%     fclose(fid1);
%     fclose(fid2);
%     fclose(fid3);
% end
% for i = 1:39
%     fid1 = fopen(sprintf(['C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/well_data_with_sensitivity/well_sensitivity_c1_ss_%d.txt'],5*(i-1)),'w+');
%     fid2 = fopen(sprintf(['C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/well_data_with_sensitivity/well_sensitivity_c1_sm_%d.txt'],5*(i-1)),'w+');
%     fid3 = fopen(sprintf(['C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/well_data_with_sensitivity/well_sensitivity_c1_st_%d.txt'],5*(i-1)),'w+');
%     for j = 1:11
%         fprintf(fid1,'%d %d %d\n', well_82_ss_c1(j,:,i));
%     end
%     for j = 13:82
%         fprintf(fid1,'%d %d %d\n', well_82_ss_c1(j,:,i));
%     end
%     for j = 1:11
%         fprintf(fid2,'%d %d %d\n', well_82_sm_c1(j,:,i));
%     end 
%     for j = 13:82
%         fprintf(fid2,'%d %d %d\n', well_82_sm_c1(j,:,i));
%     end 
%     for j = 1:11
%         fprintf(fid3,'%d %d %d\n', well_82_st_c1(j,:,i));
%     end 
%     for j = 13:82
%         fprintf(fid3,'%d %d %d\n', well_82_st_c1(j,:,i));
%     end 
%     fclose(fid1);
%     fclose(fid2);
%     fclose(fid3);
% end

for i = 1:N
    fid1 = fopen(sprintf(['C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/well_data_with_sensitivity/well_sensitivity_c1_ss_real_%d.txt'],5*(i-1)),'w+');
    fid2 = fopen(sprintf(['C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/well_data_with_sensitivity/well_sensitivity_c1_sm_real_%d.txt'],5*(i-1)),'w+');
    fid3 = fopen(sprintf(['C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/well_data_with_sensitivity/well_sensitivity_c1_st_real_%d.txt'],5*(i-1)),'w+');
    for j = 1:max(size(well_82_ss_c1_real(:,1,i)));
        if well_82_ss_c1_real(j,1,i)~= 0
            fprintf(fid1,'%d %d %d\n', well_82_ss_c1_real(j,:,i));
        end
    end
    for j = 1:max(size(well_82_sm_c1_real(:,1,i)));
        if well_82_sm_c1_real(j,1,i)~= 0
            fprintf(fid2,'%d %d %d\n', well_82_sm_c1_real(j,:,i));
        end
    end
    for j = 1:max(size(well_82_st_c1_real(:,1,i)));
        if well_82_st_c1_real(j,1,i)~= 0
            fprintf(fid3,'%d %d %d\n', well_82_st_c1_real(j,:,i));
        end
    end
    fclose(fid1);
    fclose(fid2);
    fclose(fid3);
end

% for i = 1:10
%     fid1 = fopen(sprintf(['C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/well_data_with_sensitivity/well_sensitivity_c2_ss_%d.txt'],20*i),'w+');
%     fid2 = fopen(sprintf(['C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/well_data_with_sensitivity/well_sensitivity_c2_sm_%d.txt'],20*i),'w+');
%     fid3 = fopen(sprintf(['C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/well_data_with_sensitivity/well_sensitivity_c2_st_%d.txt'],20*i),'w+');
%     for j = 1:11
%         fprintf(fid1,'%d %d %d\n', well_82_ss_c2(j,:,i));
%     end
%     for j = 13:82
%         fprintf(fid1,'%d %d %d\n', well_82_ss_c2(j,:,i));
%     end
%     for j = 1:11
%         fprintf(fid2,'%d %d %d\n', well_82_sm_c2(j,:,i));
%     end 
%     for j = 13:82
%         fprintf(fid2,'%d %d %d\n', well_82_sm_c2(j,:,i));
%     end 
%     for j = 1:11
%         fprintf(fid3,'%d %d %d\n', well_82_st_c2(j,:,i));
%     end 
%     for j = 13:82
%         fprintf(fid3,'%d %d %d\n', well_82_st_c2(j,:,i));
%     end 
%     fclose(fid1);
%     fclose(fid2);
%     fclose(fid3);
% end
% fid1 = fopen(sprintf(['C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/well_data_with_sensitivity/well_sensitivity_h_st_test.txt']),'w+');
% for j = 1:82
%     fprintf(fid1,'%d %d %d\n', well_82_test(j,:));
% end
% fclose(fid1);
% well_36_st(1:36,1:3) = 0;
% well_36_st(1:36,1:2) = Well_36;
% well_36_st(1:36,3) = S_T_c1(:,102);
% well_36_sm(1:36,1:3) = 0;
% well_36_sm(1:36,1:2) = Well_36;
% well_36_sm(1:36,3) = S_M_c1(:,102);
% well_36_ss(1:36,1:3) = 0;
% well_36_ss(1:36,1:2) = Well_36;
% well_36_ss(1:36,3) = S_S_c1(:,102);
% 
% well_36_st2(1:36,1:3) = 0;
% well_36_st2(1:36,1:2) = Well_36;
% well_36_st2(1:36,3) = S_T_c2(:,252);
% well_36_sm2(1:36,1:3) = 0;
% well_36_sm2(1:36,1:2) = Well_36;
% well_36_sm2(1:36,3) = S_M_c2(:,252);
% well_36_ss2(1:36,1:3) = 0;
% well_36_ss2(1:36,1:2) = Well_36;
% well_36_ss2(1:36,3) = S_S_c2(:,252);

%    for i = 1:36
%             fprintf(fid,'%d %d %d\n', well_36_st(i,:));
%    end
%     fclose(fid);
