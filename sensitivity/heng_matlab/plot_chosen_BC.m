nsim = 100;
t = 1000;
init = 169;
istart = 169;
for i = istart:init + t
    BC_cs(:,:,i-168) = load(sprintf('C:\\Users\\daih524\\Desktop\\2015_Spring\\Data_for_Test_Case\\BC_Data_From_Chen\\4heng\\BC_CS\\BC%d.txt',i));
end
BC_East = h5read('..\Sensitivity_Analysis\Test_Case\BC_UK1_Oct2011_Starting0_exponential.h5','/BC_East/Data');
BC_West = h5read('..\Sensitivity_Analysis\Test_Case\BC_UK1_Oct2011_Starting0_exponential.h5','/BC_West/Data');
BC_North = h5read('..\Sensitivity_Analysis\Test_Case\BC_UK1_Oct2011_Starting0_exponential.h5','/BC_North/Data');
BC_South = h5read('..\Sensitivity_Analysis\Test_Case\BC_UK1_Oct2011_Starting0_exponential.h5','/BC_South/Data');
subplot(2,2,1);
hold all;
plot(1:120,BC_South(t,1:120),'LineWidth',3);
plot(1:120,BC_cs(1:120,17+2,t),'LineWidth',3);
plot(1:120,BC_cs(1:120,38+2,t),'LineWidth',3);
title('South BC','fontsize',16);
set(gca,'fontsize',16)
xlabel('X','FontSize',18);
ylabel('h','FontSize',18);
legend('Test case data','Simulation 1','Simulation 2');
subplot(2,2,2);
hold all;
plot(1:120,BC_North(t,1:120),'LineWidth',3);
plot(1:120,BC_cs(121:240,17+2,t),'LineWidth',3);
plot(1:120,BC_cs(121:240,38+2,t),'LineWidth',3);
title('North BC','fontsize',16);
set(gca,'fontsize',16)
xlabel('X','FontSize',18);
ylabel('h','FontSize',18);
legend('Test case data','Simulation 1','Simulation 2');
subplot(2,2,3);
hold all;
plot(1:120,BC_West(t,1:120),'LineWidth',3);
plot(1:120,BC_cs(241:360,17+2,t),'LineWidth',3);
plot(1:120,BC_cs(241:360,38+2,t),'LineWidth',3);
title('West BC','fontsize',16);
set(gca,'fontsize',16)
xlabel('X','FontSize',18);
ylabel('h','FontSize',18);
legend('Test case data','Simulation 1','Simulation 2');
subplot(2,2,4);
hold all;
plot(1:120,BC_East(t,1:120),'LineWidth',3);
plot(1:120,BC_cs(361:480,17+2,t),'LineWidth',3);
plot(1:120,BC_cs(361:480,38+2,t),'LineWidth',3);
title('East BC','fontsize',16);
set(gca,'fontsize',16)
xlabel('X','FontSize',18);
ylabel('h','FontSize',18);
legend('Test case data','Simulation 1','Simulation 2');