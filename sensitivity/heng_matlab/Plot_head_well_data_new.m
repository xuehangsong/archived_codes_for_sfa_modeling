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
for l = 1:10
for k = 1:10
    for i = 1:100
        well_data_base_interp_3_29_2{l,k,i} = interp1(Timet{l,k,i}(148,:),Headt{l,k,i}(148,:),time_3_29(1:find(time_3_29>=192)-1),'cubic');
        h2 = plot(time_3_29(1:find(time_3_29>=191)-1),well_data_base_interp_3_29_2{l,k,i}(1:191),'blue','LineWidth',6);
    end
end
end
set(gca,'fontsize',16);
h1 = plot(time_3_29,well_data_3_29,'k.','markersize',20);
xlim([0 190]);
ylim([104.6 105.1]);
xlabel('Time (h)','fontsize',20);
ylabel('Hydraulic Head (m)','fontsize',20);
title('(a) Hydraulic head for Well 3-29','fontsize',20);
legend([h1, h2],{'Observations','Simulations'});
box on;

subplot(2,2,2);
hold all;
for l = 1:10
for k = 1:10
    for i = 1:100
        %well_data_base_interp_2_10{i} = interp1(Time_base_new{i}(369,:),Head_1_base_new{i}(369,:),time_2_10(1:find(time_2_10>=192)-1),'cubic');
        %    well_data_base_interp_3_29{i} = interp1(Time_base_old{i}(158,:)-8,Head_1_base_old{i}(158,:),time_3_29(1:find(time_3_29>=192)-1),'cubic');
        %  well_data_base_interp_3_29_2{i} = interp1(Time{i}(158,:),Head_1{i}(158,:),time_3_29(1:find(time_3_29>=192)-1),'cubic');
        %  plot(time_2_10(1:find(time_2_10>=1000)-1),abs(well_data_2_10(1:find(time_2_10>=1000)-1)-well_data_interp_2_10{i}),'LineWidth',1);
        % plot(time_3_29(1:find(time_3_29>=1000)-1),abs(well_data_3_29(1:find(time_3_29>=1000)-1)-well_data_interp_3_29{i}),'LineWidth',1);
        % plot(Time{i}(19,:),Head_1{i}(19,:)-well_data_interp_3_29{i},'LineWidth',1);
        % scatter(well_data_interp_3_29{i},Head_1{i}(117,:));
        % plot(Time{i}(19,:),Head_1{i}(19,:),'LineWidth',1);
        %  h2 = plot(time_2_10(1:find(time_2_10>=1000)-1),well_data_interp_2_10_5{i},'red');
        %  h2 = plot(time_3_29(1:find(time_3_29>=191)-1),well_data_base_interp_3_29_2{i}(1:191),'blue','LineWidth',3);
        %h2 = plot(time_3_29(180:192),well_data_base_interp_3_29_2{i}(180:192)-0.008,'red');
        %h2 = plot(time_2_10(1:find(time_2_10>=1000)-1),abs(well_data_2_10(1:find(time_2_10>=1000)-1)-well_data_interp_2_10_5{i}),'red');
        h2 = plot(time_3_29(1:find(time_3_29>=190)-1),abs(well_data_3_29(1:find(time_3_29>=190)-1)-well_data_base_interp_3_29_2{l,k,i}(1:190)),'blue','LineWidth',3);
        %  h2 = plot(time_3_29(180:182),abs(well_data_3_29(180:182)-well_data_base_interp_3_29_2{i}(180:182))-0.002,'red');
        %  h2 = plot(time_3_29(182:192),abs(well_data_3_29(182:192)-well_data_base_interp_3_29_2{i}(182:192)),'red');
    end
end
end
set(gca,'fontsize',16);
%h3 = plot(time_2_10(1:find(time_2_10>1000)-1),well_data_base_interp_2_10{5},'blue');
%h3 = plot(time_3_29(1:find(time_2_10>1000)-1),well_data_base_interp_2_10{5},'blue');
%h3 = plot(time_2_10(1:find(time_2_10>1000)-1),abs(well_data_2_10(1:find(time_2_10 >= 1000)-1) - well_data_base_interp_2_10{5}),'blue');
%h3 = plot(time_3_29(1:find(time_3_29>1000)-1),abs(well_data_3_29(1:find(time_3_29 >= 1000)-1) - well_data_base_interp_3_29{5}),'blue');
%h1 = plot(time_2_10,well_data_2_10,'k*');
%h1 = plot(time_3_29,well_data_3_29,'k*');
xlim([0 190]);
ylim([0 0.08]);
xlabel('Time (h)','fontsize',20);
%ylabel('Hydraulic Head (m)','fontsize',20);
ylabel('Absolute error (m)','fontsize',20);
%legend([h1, h3, h2],{'Well data','Base case','Simulation results'});
%legend([h2, h3],{'Simulation results','Base case'});
%legend([h2, h1],{'Simulation results','Well data'});
title('(b) Absolute errors for Well 3-29','fontsize',20);
%title('Well 2-10 Permeability field 5','fontsize',20);
%title('Well 3-29','fontsize',20);
box on;

subplot(2,2,3);
hold all;
for l = 1:10
for k = 1:10
    for i = 1:100
        well_data_base_interp_2_10_2{l,k,i} = interp1(Timet{l,k,i}(384,:),Headt{l,k,i}(384,:),time_2_10(1:find(time_2_10>=192)-1),'cubic');
        h2 = plot(time_2_10(1:find(time_2_10>=191)-1),well_data_base_interp_2_10_2{l,k,i}(1:191),'blue','LineWidth',6);
    end
end
end
h1 = plot(time_2_10,well_data_2_10,'k.','markersize',20);
set(gca,'fontsize',16);
legend([h1, h2],{'Observations','Simulations'});
xlim([0 190]);
ylim([104.6 105.1]);
xlabel('Time (h)','fontsize',20);
ylabel('Hydraulic Head (m)','fontsize',20);
title('(c) Hydraulic head for Well 2-10','fontsize',20);
box on;

subplot(2,2,4);
hold all;
for l = 1:10
for k = 1:10
    for i = 1:100
        %   well_data_base_interp_2_10{i} = interp1(Time_base_old{i}(373,:)-8,Head_1_base_old{i}(373,:),time_2_10(1:find(time_2_10>=192)-1),'cubic');
        %  well_data_base_interp_2_10_2{i} = interp1(Time{i}(373,:),Head_1{i}(373,:),time_2_10(1:find(time_2_10>=192)-1),'cubic');
        %  plot(time_2_10(1:find(time_2_10>=1000)-1),abs(well_data_2_10(1:find(time_2_10>=1000)-1)-well_data_interp_2_10{i}),'LineWidth',1);
        % plot(time_3_29(1:find(time_3_29>=1000)-1),abs(well_data_3_29(1:find(time_3_29>=1000)-1)-well_data_interp_3_29{i}),'LineWidth',1);
        % plot(Time{i}(19,:),Head_1{i}(19,:)-well_data_interp_3_29{i},'LineWidth',1);
        % scatter(well_data_interp_3_29{i},Head_1{i}(117,:));
        % plot(Time{i}(19,:),Head_1{i}(19,:),'LineWidth',1);
        %  h2 = plot(time_2_10(1:find(time_2_10>=191)-1),well_data_base_interp_2_10_2{i}(1:191),'blue','LineWidth',3);
        %  h2 = plot(time_2_10(180:192),well_data_base_interp_2_10_2{i}(180:192)-0.008,'red');
        %   h2 = plot(time_3_29(1:find(time_3_29>=192)-1),well_data_interp_3_29{i},'red');
        h2 = plot(time_2_10(1:find(time_2_10>=190)-1),abs(well_data_2_10(1:find(time_2_10>=190)-1)-well_data_base_interp_2_10_2{l,k,i}(1:190)),'blue','LineWidth',3);
        %h2 = plot(time_3_29(1:find(time_3_29>=192)-1),abs(well_data_3_29(1:find(time_3_29>=192)-1)-well_data_interp_3_29_5{i}),'red');
        %   h2 = plot(time_2_10(1:find(time_3_29>=180)-1),abs(well_data_2_10(1:find(time_3_29>=180)-1)-well_data_base_interp_2_10{i}(1:180)),'red');
        %  h2 = plot(time_2_10(180:192),abs(well_data_2_10(180:192)-well_data_base_interp_2_10_2{i}(180:192))+0.004,'red');
    end
end
end
set(gca,'fontsize',16);
%h3 = plot(time_2_10(1:find(time_2_10>1000)-1),well_data_base_interp_2_10{5},'blue');
%h3 = plot(time_3_29(1:find(time_2_10>1000)-1),well_data_base_interp_2_10{5},'blue');
%h3 = plot(time_2_10(1:find(time_2_10>1000)-1),abs(well_data_2_10(1:find(time_2_10 >= 1000)-1) - well_data_base_interp_2_10{5}),'blue');
%h3 = plot(time_3_29(1:find(time_3_29>1000)-1),abs(well_data_3_29(1:find(time_3_29 >= 1000)-1) - well_data_base_interp_3_29{5}),'blue');
%h1 = plot(time_2_10,well_data_2_10,'k*');
%h1 = plot(time_3_29,well_data_3_29,'k*');
xlim([0 190]);
ylim([0 0.08]);
xlabel('Time (h)','fontsize',20);
%ylabel('Hydraulic Head (m)','fontsize',20);
ylabel('Absolute error (m)','fontsize',20);
%legend([h1, h3, h2],{'Well data','Base case','Simulation results'});
%legend([h2, h3],{'Simulation results','Base case'});
%legend([h2, h1],{'Simulation results','Well data'});
title('(d) Absolute errors for Well 2-10','fontsize',20);
%title('Well 2-10 Permeability field 5','fontsize',20);
%title('Well 2-10','fontsize',20);
box on;

