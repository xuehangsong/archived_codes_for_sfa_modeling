nsim = 100;
t = 200;
init = 170;
istart = 170;
for i = istart:init + t
    BC_cs(:,:,i-169) = load(sprintf('E:/PNNL_RESEARCH_FILES/BC_CS/BC%d.txt',i));
end
hold all;
BC_East = h5read('..\Data_for_Test_Case\Test_case_Input_Include_HDF5_Files\BC_UK1_Oct2011_Starting0_exponential.h5','/BC_East/Data');
BC_West = h5read('..\Data_for_Test_Case\Test_case_Input_Include_HDF5_Files\BC_UK1_Oct2011_Starting0_exponential.h5','/BC_West/Data');
BC_North = h5read('..\Data_for_Test_Case\Test_case_Input_Include_HDF5_Files\BC_UK1_Oct2011_Starting0_exponential.h5','/BC_North/Data');
BC_South = h5read('..\Data_for_Test_Case\Test_case_Input_Include_HDF5_Files\BC_UK1_Oct2011_Starting0_exponential.h5','/BC_South/Data');
BC(1,1:480,1:201) = BC_cs(1:480,14+2,1:201);
BC(2,1:480,1:201) = BC_cs(1:480,19+2,1:201);
BC(3,1:480,1:201) = BC_cs(1:480,22+2,1:201);
BC(4,1:480,1:201) = BC_cs(1:480,50+2,1:201);
BC(5,1:480,1:201) = BC_cs(1:480,52+2,1:201);
BC(6,1:480,1:201) = BC_cs(1:480,61+2,1:201);
BC(7,1:480,1:201) = BC_cs(1:480,79+2,1:201);
BC(8,1:480,1:201) = BC_cs(1:480,93+2,1:201);
BC(9,1:480,1:201) = BC_cs(1:480,94+2,1:201);
for i = 1:201
    BC(10,1:120,i) = BC_South(i,1:120);
    BC(10,121:240,i) = BC_North(i,1:120);
    BC(10,241:360,i) = BC_West(i,1:120);
    BC(10,361:480,i) = BC_East(i,1:120);
end
for i = 1:480
    for j = 1:201
        var_BC(i,j) = std(BC(:,i,j));
    end
end
%subplot(2,2,1);
hold all;
%plot(1:120,var_BC(1:120,5),'LineWidth',3);
plot(1:120,var_BC(1:120,10),'LineWidth',3);
% plot(1:120,var_BC(1:120,15),'LineWidth',3);
% plot(1:120,var_BC(1:120,20),'LineWidth',3);
% plot(1:120,var_BC(1:120,30),'LineWidth',3);
plot(1:120,var_BC(1:120,50),'LineWidth',3);
plot(1:120,var_BC(1:120,100),'LineWidth',3);
plot(1:120,var_BC(1:120,150),'LineWidth',3);
%title('South BC','fontsize',16);
set(gca,'fontsize',16);
xlabel('X','FontSize',18);
ylabel('Standard deviation of hydraulic head (m)','FontSize',18);
legend('10 hours','50 hours','100 hours','150 hours');