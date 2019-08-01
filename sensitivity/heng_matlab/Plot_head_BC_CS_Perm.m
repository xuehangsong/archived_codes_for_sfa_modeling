%clearvars well_data_interp_2_10 well_data_interp_3_29 well_data_base_interp_2_10 well_data_base_interp_3_29;
% time = linspace(0,1510.3,6042);
% plot(time,well_2_5_data);
time_3_26 = (Time_3_26 - 40835.45833).*24;
time_2_10 = (Time_2_10 - 40835.45833).*24;
time_3_29 = (Time_3_29 - 40835.45833).*24;
set(gca,'fontsize',16)
subplot(3,1,1);
hold all;
h1 = plot(time_3_29,well_data_3_29,'k*');
for i = 1:100
   % well_data_interp_2_10{i} = interp1(Time{i}(117,:),Head_1{i}(117,:),time_2_10(1:find(time_2_10>=1000)-1),'cubic');
    well_data_interp_3_29{i} = interp1(Time_base{i}(19,:),Head_1{i}(19,:),time_3_29(1:find(time_3_29>=1000)-1),'cubic');
    h2 = plot(time_3_29(1:find(time_3_29>=1000)-1),well_data_interp_3_29{i},'red');
end
xlim([0 1000]);
xlabel('Time (h)','fontsize',14);
ylabel('Hydraulic Head (m)');
legend([h1, h2],{'Well data','Material ID simulation results'});
subplot(3,1,2);
hold all;
h1 = plot(time_3_29,well_data_3_29,'k*');
for i = 1:100
   % well_data_interp_2_10{i} = interp1(Time{i}(117,:),Head_1{i}(117,:),time_2_10(1:find(time_2_10>=1000)-1),'cubic');
    well_data_interp_3_29_BC{i} = interp1(Time_BC{i}(19,:),Head_1_BC{i}(19,:),time_3_29(1:find(time_3_29>=1000)-1),'cubic');
    h2 = plot(time_3_29(1:find(time_3_29>=1000)-1),well_data_interp_3_29_BC{i},'red');
end
xlim([0 1000]);
xlabel('Time (h)','fontsize',14);
ylabel('Hydraulic Head (m)');
legend([h1, h2],{'Well data','Boundary condition simulation results'});
subplot(3,1,3);
hold all;
h1 = plot(time_3_29,well_data_3_29,'k*');
for i = 1:100
   % well_data_interp_2_10{i} = interp1(Time{i}(117,:),Head_1{i}(117,:),time_2_10(1:find(time_2_10>=1000)-1),'cubic');
    well_data_interp_3_29_perm{i} = interp1(Time_base{i}(19,:),Head_1_perm{i}(19,:),time_3_29(1:find(time_3_29>=1000)-1),'cubic');
    h2 = plot(time_3_29(1:find(time_3_29>=1000)-1),well_data_interp_3_29_perm{i},'red');
end
xlim([0 1000]);
xlabel('Time (h)','fontsize',14);
ylabel('Hydraulic Head (m)');
legend([h1, h2],{'Well data','Permeability field simulation results'});