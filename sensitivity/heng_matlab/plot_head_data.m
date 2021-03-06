clearvars well_data_interp_2_10 well_data_interp_3_29 well_data_base_interp_2_10 well_data_base_interp_3_29;
% time = linspace(0,1510.3,6042);
% plot(time,well_2_5_data);
time_3_26 = (Time_3_26 - 40835.45833).*24;
time_2_10 = (Time_2_10 - 40835.45833).*24;
time_3_29 = (Time_3_29 - 40835.45833).*24;
%plot(time_3_29,well_data_3_29,'LineWidth',3);
set(gca,'fontsize',16)
%xlabel('Time (h)','fontsize',20);
%ylabel('Head (m)','fontsize',20);
%xlabel('Time (h)','fontsize',20);
%ylabel('Absolute error (m)','fontsize',20);
subplot(2,2,1);
hold all;
for i = 1:100
    well_data_interp_2_10_5{i} = interp1(Time_4{i}(117,:),Head_1_4{i}(117,:),time_2_10(1:find(time_2_10>=1000)-1),'cubic');
    well_data_interp_3_29_5{i} = interp1(Time_4{i}(19,:),Head_1_4{i}(19,:),time_3_29(1:find(time_3_29>=1000)-1),'cubic');
    well_data_base_interp_2_10{i} = interp1(Time_base{i}(117,:),Head_1_base{i}(117,:),time_2_10(1:find(time_2_10>=1000)-1),'cubic');
    well_data_base_interp_3_29{i} = interp1(Time_base{i}(19,:),Head_1_base{i}(19,:),time_3_29(1:find(time_3_29>=1000)-1),'cubic');
  %  plot(time_2_10(1:find(time_2_10>=1000)-1),abs(well_data_2_10(1:find(time_2_10>=1000)-1)-well_data_interp_2_10{i}),'LineWidth',1);
  % plot(time_3_29(1:find(time_3_29>=1000)-1),abs(well_data_3_29(1:find(time_3_29>=1000)-1)-well_data_interp_3_29{i}),'LineWidth',1);
  % plot(Time{i}(19,:),Head_1{i}(19,:)-well_data_interp_3_29{i},'LineWidth',1);
  % scatter(well_data_interp_3_29{i},Head_1{i}(117,:));
  % plot(Time{i}(19,:),Head_1{i}(19,:),'LineWidth',1);
  %  h2 = plot(time_2_10(1:find(time_2_10>=1000)-1),well_data_interp_2_10_5{i},'red');
  %  h2 = plot(time_3_29(1:find(time_3_29>=1000)-1),well_data_interp_3_29{i},'red');
  %h2 = plot(time_2_10(1:find(time_2_10>=1000)-1),abs(well_data_2_10(1:find(time_2_10>=1000)-1)-well_data_interp_2_10_5{i}),'red');
  h2 = plot(time_3_29(1:find(time_3_29>=1000)-1),abs(well_data_3_29(1:find(time_3_29>=1000)-1)-well_data_interp_3_29_5{i}),'red');
end
%h3 = plot(time_2_10(1:find(time_2_10>1000)-1),well_data_base_interp_2_10{5},'blue');
%h3 = plot(time_3_29(1:find(time_2_10>1000)-1),well_data_base_interp_2_10{5},'blue');
%h3 = plot(time_2_10(1:find(time_2_10>1000)-1),abs(well_data_2_10(1:find(time_2_10 >= 1000)-1) - well_data_base_interp_2_10{5}),'blue');
h3 = plot(time_3_29(1:find(time_3_29>1000)-1),abs(well_data_3_29(1:find(time_3_29 >= 1000)-1) - well_data_base_interp_3_29{5}),'blue');
%h1 = plot(time_2_10,well_data_2_10,'k*');
%h1 = plot(time_3_29,well_data_3_29,'k*');
xlim([0 1000]);
xlabel('Time (h)','fontsize',14);
%ylabel('Hydraulic Head (m)');
ylabel('Absolute error (m)','fontsize',14);
%legend([h1, h3, h2],{'Well data','Base case','Simulation results'});
legend([h2, h3],{'Simulation results','Base case'});
%title('Well 3-29','fontsize',20);
%title('Well 2-10 Permeability field 5','fontsize',20);
title('Well 3-29 Permeability field 5','fontsize',20);
subplot(2,2,2);
hold all;
for i = 1:100
    well_data_interp_2_10_15{i} = interp1(Time_15{i}(117,:),Head_1_15{i}(117,:),time_2_10(1:find(time_2_10>=1000)-1),'cubic');
    well_data_interp_3_29_15{i} = interp1(Time_15{i}(19,:),Head_1_15{i}(19,:),time_3_29(1:find(time_3_29>=1000)-1),'cubic');
    %h2 = plot(time_2_10(1:find(time_2_10>=1000)-1),well_data_interp_2_10_15{i},'red');
    %h2 = plot(time_2_10(1:find(time_2_10>=1000)-1),abs(well_data_2_10(1:find(time_2_10>=1000)-1)-well_data_interp_2_10_15{i}),'red');
    h2 = plot(time_3_29(1:find(time_3_29>=1000)-1),abs(well_data_3_29(1:find(time_3_29>=1000)-1)-well_data_interp_3_29_15{i}),'red');
end
%h3 = plot(time_2_10(1:find(time_2_10>1000)-1),well_data_base_interp_2_10{15},'blue');
%h3 = plot(time_2_10(1:find(time_2_10>1000)-1),abs(well_data_2_10(1:find(time_2_10 >= 1000)-1) - well_data_base_interp_2_10{15}),'blue');
h3 = plot(time_3_29(1:find(time_3_29>1000)-1),abs(well_data_3_29(1:find(time_3_29 >= 1000)-1) - well_data_base_interp_3_29{15}),'blue');
%h1 = plot(time_2_10,well_data_2_10,'k*');
%h1 = plot(time_3_29,well_data_3_29,'k*');
xlim([0 1000]);
xlabel('Time (h)','fontsize',14);
%ylabel('Hydraulic Head (m)');
ylabel('Absolute error (m)','fontsize',14);
%legend([h1, h3, h2],{'Well data','Base case','Simulation results'});
legend([h2, h3],{'Simulation results','Base case'});
%title('Well 3-29','fontsize',20);
%title('Well 2-10 Permeability field 15','fontsize',20);
title('Well 3-29 Permeability field 15','fontsize',20);
subplot(2,2,3);
hold all;
for i = 1:100
    well_data_interp_2_10_25{i} = interp1(Time_25{i}(117,:),Head_1_25{i}(117,:),time_2_10(1:find(time_2_10>=1000)-1),'cubic');
    well_data_interp_3_29_25{i} = interp1(Time_25{i}(19,:),Head_1_25{i}(19,:),time_3_29(1:find(time_3_29>=1000)-1),'cubic');
    %h2 = plot(time_2_10(1:find(time_2_10>=1000)-1),well_data_interp_2_10_25{i},'red');
    %h2 = plot(time_2_10(1:find(time_2_10>=1000)-1),abs(well_data_2_10(1:find(time_2_10>=1000)-1)-well_data_interp_2_10_25{i}),'red');
    h2 = plot(time_3_29(1:find(time_3_29>=1000)-1),abs(well_data_3_29(1:find(time_3_29>=1000)-1)-well_data_interp_3_29_25{i}),'red');
end
%h3 = plot(time_2_10(1:find(time_2_10>1000)-1),well_data_base_interp_2_10{25},'blue');
%h3 = plot(time_2_10(1:find(time_2_10>1000)-1),abs(well_data_2_10(1:find(time_2_10 >= 1000)-1) - well_data_base_interp_2_10{25}),'blue');
h3 = plot(time_3_29(1:find(time_3_29>1000)-1),abs(well_data_3_29(1:find(time_3_29 >= 1000)-1) - well_data_base_interp_3_29{25}),'blue');
%h1 = plot(time_2_10,well_data_2_10,'k*');
%h1 = plot(time_3_29,well_data_3_29,'k*');
xlim([0 1000]);
xlabel('Time (h)','fontsize',14);
%ylabel('Hydraulic Head (m)');
%legend([h1, h3, h2],{'Well data','Base case','Simulation results'});
legend([h2, h3],{'Simulation results','Base case'});
%title('Well 3-29','fontsize',20);
title('Well 3-29 Permeability field 25','fontsize',20);
%title('Well 2-10 Permeability field 25','fontsize',20);
subplot(2,2,4);
hold all;
for i = 1:100
    well_data_interp_2_10_35{i} = interp1(Time_35{i}(117,:),Head_1_35{i}(117,:),time_2_10(1:find(time_2_10>=1000)-1),'cubic');
    well_data_interp_3_29_35{i} = interp1(Time_35{i}(19,:),Head_1_35{i}(19,:),time_3_29(1:find(time_3_29>=1000)-1),'cubic');
%    h2 = plot(time_2_10(1:find(time_2_10>=1000)-1),well_data_interp_2_10_35{i},'red');
%    h2 = plot(time_2_10(1:find(time_2_10>=1000)-1),abs(well_data_2_10(1:find(time_2_10>=1000)-1)-well_data_interp_2_10_35{i}),'red');
    h2 = plot(time_3_29(1:find(time_3_29>=1000)-1),abs(well_data_3_29(1:find(time_3_29>=1000)-1)-well_data_interp_3_29_35{i}),'red');
end
%h3 = plot(time_2_10(1:find(time_2_10>1000)-1),well_data_base_interp_2_10{35},'blue');
%h3 = plot(time_2_10(1:find(time_2_10>1000)-1),abs(well_data_2_10(1:find(time_2_10 >= 1000)-1) - well_data_base_interp_2_10{35}),'blue');
h3 = plot(time_3_29(1:find(time_3_29>1000)-1),abs(well_data_3_29(1:find(time_3_29 >= 1000)-1) - well_data_base_interp_3_29{35}),'blue');
%h1 = plot(time_2_10,well_data_2_10,'k*');
%h1 = plot(time_3_29,well_data_3_29,'k*');
xlim([0 1000]);
xlabel('Time (h)');
%ylabel('Hydraulic Head (m)');
%legend([h1, h3, h2],{'Well data','Base case','Simulation results'});
legend([h2, h3],{'Simulation results','Base case'});
%title('Well 3-29','fontsize',20);
%title('Well 2-10 Permeability field 35','fontsize',20);
title('Well 3-29 Permeability field 35','fontsize',20);