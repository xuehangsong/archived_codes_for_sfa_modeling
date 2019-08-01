nsim = 100;
t = 1000;
init = 169;
istart = 169;
% for i = istart:init + t
%      BC_cs(:,:,i-168) = load(sprintf('C:\\Users\\daih524\\Desktop\\2015_Spring\\Data_for_Test_Case\\BC_Data_From_Chen\\4heng\\BC_CS\\BC%d.txt',i));
% end
% BC_East = h5read('..\Data_for_Test_Case\Test_case_Input_Include_HDF5_Files\BC_UK1_Oct2011_Starting0_exponential.h5','/BC_East/Data');
% BC_West = h5read('..\Data_for_Test_Case\Test_case_Input_Include_HDF5_Files\BC_UK1_Oct2011_Starting0_exponential.h5','/BC_West/Data');
% BC_North = h5read('..\Data_for_Test_Case\Test_case_Input_Include_HDF5_Files\BC_UK1_Oct2011_Starting0_exponential.h5','/BC_North/Data');
% BC_South = h5read('..\Data_for_Test_Case\Test_case_Input_Include_HDF5_Files\BC_UK1_Oct2011_Starting0_exponential.h5','/BC_South/Data');
t = 100;
subplot(2,2,1);
hold all;
for j = 1:nsim
    if j == 1
        plot(1:120,BC_cs(1:120,j+2,t),'black','LineWidth',3);
    end
    plot(1:120,BC_cs(1:120,j+2,t),'LineWidth',3);
end
h1 = plot(1:120,BC_South(t,1:120),'black','LineWidth',3);
title('South Boundary','fontsize',20);
set(gca,'fontsize',16)
xlabel('X','FontSize',18);
ylabel('h','FontSize',18);
%legend(h1,{'Test case data'});
legend(h1,{'Kriging'});
subplot(2,2,2);
hold all;
for j = 1:nsim
    if j == 1
        plot(1:120,BC_cs(121:240,j+2,t),'black','LineWidth',3);
    end
    plot(1:120,BC_cs(121:240,j+2,t),'LineWidth',3);
end
h2 = plot(1:120,BC_North(t,1:120),'black','LineWidth',3);
title('North Boundary','fontsize',20);
%legend(h2,{'Test case data'});
legend(h2,{'Kriging'});
set(gca,'fontsize',16)
xlabel('X','FontSize',18);
ylabel('h','FontSize',18);
subplot(2,2,3);
hold all;
for j = 1:nsim
    if j == 1
        plot(1:120,BC_cs(241:360,j+2,t),'black','LineWidth',3);
    end    
    plot(1:120,BC_cs(241:360,j+2,t),'LineWidth',3);
end
h3 = plot(1:120,BC_West(t,1:120),'black','LineWidth',3);
title('West Boundary','fontsize',20);
%legend(h3,{'Test case data'});
legend(h3,{'Kriging'});
set(gca,'fontsize',16)
xlabel('Y','FontSize',18);
ylabel('h','FontSize',18);
subplot(2,2,4);
hold all;
for j = 1:nsim
    if j == 1
        plot(1:120,BC_cs(361:480,j+2,t),'black','LineWidth',3);
    end    
    plot(1:120,BC_cs(361:480,j+2,t),'LineWidth',3);
end
title('East Boundary','fontsize',20);
h4 = plot(1:120,BC_East(t,1:120),'black','LineWidth',3);
%legend(h4,{'Test case data'});
legend(h4,{'Kriging'});
set(gca,'fontsize',16)
xlabel('Y','FontSize',18);
ylabel('h','FontSize',18);