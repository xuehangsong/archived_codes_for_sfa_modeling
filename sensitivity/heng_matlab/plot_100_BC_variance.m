nsim = 100;
t = 200;
init = 170;
istart = 170;
for i = istart:init + t
    BC_cs(:,:,i-169) = load(sprintf('F:/PNNL_RESEARCH_FILES/BC_CS/BC%d.txt',i));
end
BC_East = h5read('..\Data_for_Test_Case\Test_case_Input_Include_HDF5_Files\BC_UK1_Oct2011_Starting0_exponential.h5','/BC_East/Data');
BC_West = h5read('..\Data_for_Test_Case\Test_case_Input_Include_HDF5_Files\BC_UK1_Oct2011_Starting0_exponential.h5','/BC_West/Data');
BC_North = h5read('..\Data_for_Test_Case\Test_case_Input_Include_HDF5_Files\BC_UK1_Oct2011_Starting0_exponential.h5','/BC_North/Data');
BC_South = h5read('..\Data_for_Test_Case\Test_case_Input_Include_HDF5_Files\BC_UK1_Oct2011_Starting0_exponential.h5','/BC_South/Data');
for i = 1:201
    BC_cs(1:120,103,i) = BC_South(i,1:120);
    BC_cs(121:240,103,i) = BC_North(i,1:120);
    BC_cs(241:360,103,i) = BC_West(i,1:120);
    BC_cs(361:480,103,i) = BC_East(i,1:120);
end
for i = 1:480
    for j = 1:201
        var_BC_100(i,j) = var(BC_cs(i,3:103,j));
    end
end

subplot(2,2,1);
hold all;
plot(1:120,var_BC(1:120,5),'r-','LineWidth',3);
plot(1:120,var_BC(1:120,50),'b-','LineWidth',3);
plot(1:120,var_BC(1:120,100),'g-','LineWidth',3);
plot(1:120,var_BC_100(1:120,5),'r*','LineWidth',3);
plot(1:120,var_BC_100(1:120,50),'b*','LineWidth',3);
plot(1:120,var_BC_100(1:120,100),'g*','LineWidth',3);
title('South BC','fontsize',16);
set(gca,'fontsize',16)
xlabel('X','FontSize',18);
ylabel('Variance of h','FontSize',18);
%legend('10 hours','30 hours','50 hours','70 hours','90 hours');
subplot(2,2,2);
hold all;
plot(1:120,var_BC(121:240,5),'r-','LineWidth',3);
plot(1:120,var_BC(121:240,50),'b-','LineWidth',3);
plot(1:120,var_BC(121:240,100),'g-','LineWidth',3);
plot(1:120,var_BC_100(121:240,5),'r*','LineWidth',3);
plot(1:120,var_BC_100(121:240,50),'b*','LineWidth',3);
plot(1:120,var_BC_100(121:240,100),'g*','LineWidth',3);
title('North BC','fontsize',16);
set(gca,'fontsize',16)
xlabel('X','FontSize',18);
ylabel('Variance of h','FontSize',18);
legend('5 hours using 10 BC','50 hours using 10 BC','100 hours using 10 BC','5 hours using 100 BC','50 hours using 100 BC','100 hours using 100 BC');
subplot(2,2,3);
hold all;
plot(1:120,var_BC(241:360,5),'r-','LineWidth',3);
plot(1:120,var_BC(241:360,50),'b-','LineWidth',3);
plot(1:120,var_BC(241:360,100),'g-','LineWidth',3);
plot(1:120,var_BC_100(241:360,5),'r*','LineWidth',3);
plot(1:120,var_BC_100(241:360,50),'b*','LineWidth',3);
plot(1:120,var_BC_100(241:360,100),'g*','LineWidth',3);
title('West BC','fontsize',16);
set(gca,'fontsize',16)
xlabel('X','FontSize',18);
ylabel('Variance of h','FontSize',18);
%legend('10 hours','30 hours','50 hours','70 hours','90 hours');
subplot(2,2,4);
hold all;
plot(1:120,var_BC(361:480,5),'r-','LineWidth',3);
plot(1:120,var_BC(361:480,50),'b-','LineWidth',3);
plot(1:120,var_BC(361:480,100),'g-','LineWidth',3);
plot(1:120,var_BC_100(361:480,5),'r*','LineWidth',3);
plot(1:120,var_BC_100(361:480,50),'b*','LineWidth',3);
plot(1:120,var_BC_100(361:480,100),'g*','LineWidth',3);
title('East BC','fontsize',16);
set(gca,'fontsize',16)
xlabel('X','FontSize',18);
ylabel('Variance of h','FontSize',18);
%legend('10 hours','30 hours','50 hours','70 hours','90 hours');

subplot(2,2,1);
hold all;
plot(1:120,var_BC(1:120,5),'r-','LineWidth',3);
plot(1:120,var_BC(1:120,50),'b-','LineWidth',3);
plot(1:120,var_BC(1:120,100),'g-','LineWidth',3);
plot(1:120,var_BC_100(1:120,5),'r*','LineWidth',3);
plot(1:120,var_BC_100(1:120,50),'b*','LineWidth',3);
plot(1:120,var_BC_100(1:120,100),'g*','LineWidth',3);
title('South BC','fontsize',16);
set(gca,'fontsize',16)
xlabel('X','FontSize',18);
ylabel('Variance of h','FontSize',18);
%legend('10 hours','30 hours','50 hours','70 hours','90 hours');
subplot(2,2,2);
hold all;
plot(1:120,var_BC(121:240,5),'r-','LineWidth',3);
plot(1:120,var_BC(121:240,50),'b-','LineWidth',3);
plot(1:120,var_BC(121:240,100),'g-','LineWidth',3);
plot(1:120,var_BC_100(121:240,5),'r*','LineWidth',3);
plot(1:120,var_BC_100(121:240,50),'b*','LineWidth',3);
plot(1:120,var_BC_100(121:240,100),'g*','LineWidth',3);
title('North BC','fontsize',16);
set(gca,'fontsize',16)
xlabel('X','FontSize',18);
ylabel('Variance of h','FontSize',18);
legend('5 hours using 10 BC','50 hours using 10 BC','100 hours using 10 BC','5 hours using 100 BC','50 hours using 100 BC','100 hours using 100 BC');
subplot(2,2,3);
hold all;
plot(1:120,var_BC(241:360,5),'r-','LineWidth',3);
plot(1:120,var_BC(241:360,50),'b-','LineWidth',3);
plot(1:120,var_BC(241:360,100),'g-','LineWidth',3);
plot(1:120,var_BC_100(241:360,5),'r*','LineWidth',3);
plot(1:120,var_BC_100(241:360,50),'b*','LineWidth',3);
plot(1:120,var_BC_100(241:360,100),'g*','LineWidth',3);
title('West BC','fontsize',16);
set(gca,'fontsize',16)
xlabel('X','FontSize',18);
ylabel('Variance of h','FontSize',18);
%legend('10 hours','30 hours','50 hours','70 hours','90 hours');
subplot(2,2,4);
hold all;
plot(1:120,var_BC(361:480,5),'r-','LineWidth',3);
plot(1:120,var_BC(361:480,50),'b-','LineWidth',3);
plot(1:120,var_BC(361:480,100),'g-','LineWidth',3);
plot(1:120,var_BC_100(361:480,5),'r*','LineWidth',3);
plot(1:120,var_BC_100(361:480,50),'b*','LineWidth',3);
plot(1:120,var_BC_100(361:480,100),'g*','LineWidth',3);
title('East BC','fontsize',16);
set(gca,'fontsize',16)
xlabel('X','FontSize',18);
ylabel('Variance of h','FontSize',18);
%legend('10 hours','30 hours','50 hours','70 hours','90 hours');