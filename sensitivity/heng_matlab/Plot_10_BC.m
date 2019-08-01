nsim = 100;
t = 100;
init = 169;
istart = 169;
for i = istart:init + t
    BC_cs(:,:,i-168) = load(sprintf('E:/PNNL_Research_Files/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/BC_CS/BC%d.txt',i));
end
BC_East2 = h5read('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/BC_hdf5_CS/BC_sim10.h5','/BC_East/Data');

% 
% BC_East1 = h5read('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/Test_case_Input_Include_HDF5_Files/BC_UK1_Oct2011_Starting0_exponential.h5','/BC_East/Data');
% BC_West1 = h5read('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/Test_case_Input_Include_HDF5_Files/BC_UK1_Oct2011_Starting0_exponential.h5','/BC_West/Data');
% BC_North1 = h5read('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/Test_case_Input_Include_HDF5_Files/BC_UK1_Oct2011_Starting0_exponential.h5','/BC_North/Data');
% BC_South1 = h5read('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/Test_case_Input_Include_HDF5_Files/BC_UK1_Oct2011_Starting0_exponential.h5','/BC_South/Data');

BC_East = h5read('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/BC_hdf5_OK/BC_OK.h5','/BC_East/Data');
BC_West = h5read('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/BC_hdf5_OK/BC_OK.h5','/BC_West/Data');
BC_North = h5read('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/BC_hdf5_OK/BC_OK.h5','/BC_North/Data');
BC_South = h5read('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/BC_hdf5_OK/BC_OK.h5','/BC_South/Data');
subplot(2,2,1);
hold all;
plot(1:120,BC_South(t,1:120),'k-','LineWidth',6);
%plot(1:120,BC_South1(t,1:120),'-*','LineWidth',3);
plot(1:120,BC_cs(1:120,5+2,t),'LineWidth',3);
plot(1:120,BC_cs(1:120,6+2,t),'LineWidth',3);
plot(1:120,BC_cs(1:120,17+2,t),'LineWidth',3);
plot(1:120,BC_cs(1:120,39+2,t),'LineWidth',3);
plot(1:120,BC_cs(1:120,66+2,t),'LineWidth',3);
plot(1:120,BC_cs(1:120,69+2,t),'LineWidth',3);
plot(1:120,BC_cs(1:120,71+2,t),'LineWidth',3);
plot(1:120,BC_cs(1:120,89+2,t),'LineWidth',3);
plot(1:120,BC_cs(1:120,97+2,t),'LineWidth',3);
title('South Boundary','fontsize',20);
set(gca,'fontsize',16)
xlabel('X (m)','FontSize',18);
ylabel('Hydraulic head (m)','FontSize',18);
%legend('Kriging','BC 14','BC 19','BC 22','BC 50','BC 52','BC 61','BC 79','BC 93','BC 94');
subplot(2,2,2);
hold all;
plot(1:120,BC_North(t,1:120),'k-','LineWidth',6);
%plot(1:120,BC_North1(t,1:120),'-*','LineWidth',3);
plot(1:120,BC_cs(121:240,5+2,t),'LineWidth',3);
plot(1:120,BC_cs(121:240,6+2,t),'LineWidth',3);
plot(1:120,BC_cs(121:240,17+2,t),'LineWidth',3);
plot(1:120,BC_cs(121:240,39+2,t),'LineWidth',3);
plot(1:120,BC_cs(121:240,66+2,t),'LineWidth',3);
plot(1:120,BC_cs(121:240,69+2,t),'LineWidth',3);
plot(1:120,BC_cs(121:240,71+2,t),'LineWidth',3);
plot(1:120,BC_cs(121:240,89+2,t),'LineWidth',3);
plot(1:120,BC_cs(121:240,97+2,t),'LineWidth',3);
title('North Boundary','fontsize',20);
set(gca,'fontsize',16)
xlabel('X (m)','FontSize',18);
ylabel('Hydraulic head (m)','FontSize',18);
legend('Kriging','BC 5','BC 6','BC 17','BC 39','BC 66','BC 69','BC 71','BC 89','BC 97');
subplot(2,2,3);
hold all;
plot(1:120,BC_West(t,1:120),'k-','LineWidth',6);
%plot(1:120,BC_West1(t,1:120),'-*','LineWidth',3);
plot(1:120,BC_cs(241:360,5+2,t),'LineWidth',3);
plot(1:120,BC_cs(241:360,6+2,t),'LineWidth',3);
plot(1:120,BC_cs(241:360,17+2,t),'LineWidth',3);
plot(1:120,BC_cs(241:360,39+2,t),'LineWidth',3);
plot(1:120,BC_cs(241:360,66+2,t),'LineWidth',3);
plot(1:120,BC_cs(241:360,69+2,t),'LineWidth',3);
plot(1:120,BC_cs(241:360,71+2,t),'LineWidth',3);
plot(1:120,BC_cs(241:360,89+2,t),'LineWidth',3);
plot(1:120,BC_cs(241:360,97+2,t),'LineWidth',3);
title('West Boundary','fontsize',20);
set(gca,'fontsize',16)
xlabel('Y (m)','FontSize',18);
ylabel('Hydraulic head (m)','FontSize',18);
%legend('Kriging','BC 14','BC 19','BC 22','BC 50','BC 52','BC 61','BC 79','BC 93','BC 94');
subplot(2,2,4);
hold all;
plot(1:120,BC_East(t,1:120),'k-','LineWidth',6);
%plot(1:120,BC_East1(t,1:120),'-*','LineWidth',3);
plot(1:120,BC_cs(361:480,5+2,t),'LineWidth',3);
plot(1:120,BC_cs(361:480,6+2,t),'LineWidth',3);
plot(1:120,BC_cs(361:480,17+2,t),'LineWidth',3);
plot(1:120,BC_cs(361:480,39+2,t),'LineWidth',3);
plot(1:120,BC_cs(361:480,66+2,t),'LineWidth',3);
plot(1:120,BC_cs(361:480,69+2,t),'LineWidth',3);
plot(1:120,BC_cs(361:480,71+2,t),'LineWidth',3);
plot(1:120,BC_cs(361:480,89+2,t),'LineWidth',3);
plot(1:120,BC_cs(361:480,97+2,t),'LineWidth',3);
title('East Boundary','fontsize',20);
set(gca,'fontsize',16)
xlabel('Y (m)','FontSize',18);
ylabel('Hydraulic head (m)','FontSize',18);
%legend('Kriging','BC 14','BC 19','BC 22','BC 50','BC 52','BC 61','BC 79','BC 93','BC 94');