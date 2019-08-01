%BC_OK = load('..\Data_for_Test_Case\BC_Data_From_Chen\4heng\BC_OK\BC_height161.txt');
nt = 1000;
% for i = 1:nt
%     BC_OK(1:480,i) = load(sprintf('C:\\Users\\daih524\\Desktop\\2015_Spring\\Data_for_Test_Case\\BC_Data_From_Chen\\4heng\\BC_OK\\BC_height%d.txt',i+168));
% end
%BC_South_OK = BC_OK(1:120,:);
%BC_North_OK = BC_OK(121:240,:);
%BC_West_OK = BC_OK(241:360,:);
%BC_East_OK = BC_OK(361:480,:);
BC_East = h5read('..\Sensitivity_Analysis\Test_Case\BC_UK1_Oct2011_Starting0_exponential.h5','/BC_East/Data');
BC_West = h5read('..\Sensitivity_Analysis\Test_Case\BC_UK1_Oct2011_Starting0_exponential.h5','/BC_West/Data');
BC_North = h5read('..\Sensitivity_Analysis\Test_Case\BC_UK1_Oct2011_Starting0_exponential.h5','/BC_North/Data');
BC_South = h5read('..\Sensitivity_Analysis\Test_Case\BC_UK1_Oct2011_Starting0_exponential.h5','/BC_South/Data');
t = 1000;
subplot(2,2,1);
%plot(1:120,BC_West_OK(:,t),'LineWidth',3);
title('South BC','fontsize',16);
hold all;
plot(1:120,BC_West(t,1:120),'LineWidth',3);
set(gca,'fontsize',16)
xlabel('X','FontSize',18);
ylabel('h','FontSize',18);
%legend('Kriging','Test data');
subplot(2,2,2);
%plot(1:120,BC_East_OK(:,t),'LineWidth',3);
title('North BC','fontsize',16);
hold all;
plot(1:120,BC_East(t,1:120),'LineWidth',3);
%legend('Kriging','Test data');
set(gca,'fontsize',16)
xlabel('X','FontSize',18);
ylabel('h','FontSize',18);
subplot(2,2,3);
%plot(1:120,BC_North_OK(:,t),'LineWidth',3);
title('East BC','fontsize',16);
hold all;
plot(1:120,BC_North(t,1:120),'LineWidth',3);
%legend('Kriging','Test data');
set(gca,'fontsize',16)
xlabel('Y','FontSize',18);
ylabel('h','FontSize',18);
subplot(2,2,4);
%plot(1:120,BC_South_OK(:,t),'LineWidth',3);
title('West BC','fontsize',16);
hold all;
plot(1:120,BC_South(t,1:120),'LineWidth',3);
%legend('Kriging','Test data');
set(gca,'fontsize',16)
xlabel('Y','FontSize',18);
ylabel('h','FontSize',18);